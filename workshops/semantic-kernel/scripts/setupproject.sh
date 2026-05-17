#!/bin/bash

# Configurable variables
solutionName="EpamSemanticKernelWorkshop"
solutionDirectory="$PWD/$solutionName"
projectName="EpamSemanticKernel.WorkshopTasks"
dotnetVersion="7.0"
packageName="Microsoft.SemanticKernel"
packageVersion="1.0.0-rc3"

echo "Installed .NET versions:"
dotnet --list-sdks

if ! command -v dotnet &> /dev/null; then
    echo ".NET version $dotnetVersion is not installed."
    exit 1
fi

echo "Creating a new solution and adding a console project..."
mkdir -p "$solutionDirectory"
cd "$solutionDirectory" || exit
dotnet new sln -n "$solutionName"
dotnet new console -n "$projectName" --framework net7.0
dotnet sln add "$projectName"

echo "Adding NuGet package $packageName --version $packageVersion to the console project..."
cd "$projectName" || exit
dotnet add package "$packageName" --version "$packageVersion"
cd ..

programContent=$(cat << 'EOL'
// EPAM Semantic Kernel Workshop
Console.WriteLine("Hello, Semantic Kernel Workshop!");
Console.WriteLine("This is your initial program.");
EOL
)

programFilePath="$solutionDirectory/$projectName/Program.cs"
echo "$programContent" > "$programFilePath"

# Create Config folder and Settings.cs file
configFolder="$solutionDirectory/$projectName/Config"
mkdir -p "$configFolder"

settingsContent=$(cat << 'EOL'
using System.Text.Json;

public static class Settings
{
    private const string DefaultConfigFile = "config/settings.json";
    private const string DefaultModel = "gpt-35-turbo";
    private const string ModelKey = "model";
    private const string SecretKey = "apikey";
    private const string ServiceIdKey = "serviceid";
    private const string EndpointKey = "endpoint";

    public static (string model, string azureEndpoint, string apiKey, string serviceId) LoadFromFile(
        string configFile = DefaultConfigFile,
        string model = DefaultModel)
    {
        try
        {
            if (string.IsNullOrEmpty(configFile) || !File.Exists(configFile))
            {
                Console.WriteLine("Invalid or missing configuration file path.");
                throw new ArgumentException("Invalid or missing configuration file path", nameof(configFile));
            }

            string json = File.ReadAllText(configFile);
            var settingsList = JsonSerializer.Deserialize<List<Dictionary<string, string>>>(json);

            if (settingsList == null || settingsList.Count == 0)
            {
                Console.WriteLine("No configurations found in the file.");
                throw new Exception("No configurations found");
            }

            var config = settingsList.FirstOrDefault(_ => _[ModelKey] == model);

            if (config == null)
            {
                Console.WriteLine($"Configuration for model '{model}' not found.");
                throw new Exception($"Configuration for model '{model}' not found");
            }

            // Validate and retrieve values
            string loadedModel = ValidateAndGet(config, ModelKey);
            string azureEndpoint = ValidateAndGet(config, EndpointKey);
            string apiKey = ValidateAndGet(config, SecretKey);
            string serviceId = ValidateAndGet(config, ServiceIdKey);

            if (serviceId == "none")
            {
                serviceId = "";
            }

            return (loadedModel, azureEndpoint, apiKey, serviceId);
        }
        catch (Exception e)
        {
            Console.WriteLine($"Something went wrong: {e.Message}");
            return ("", "", "", "");
        }
    }

    private static string ValidateAndGet(Dictionary<string, string> config, string key)
    {
        if (!config.TryGetValue(key, out var value) || string.IsNullOrEmpty(value))
        {
            Console.WriteLine($"Invalid or missing value for key '{key}'.");
            throw new ArgumentException($"Invalid or missing value for key '{key}'", nameof(key));
        }

        return value;
    }
}
EOL
)

settingsFilePath="$configFolder/Settings.cs"
echo "$settingsContent" > "$settingsFilePath"

# Create settings.json file
settingsJsonContent=$(cat << 'EOL'
[
  {
    "model": "gpt-35-turbo",
    "apikey": "",
    "endpoint": "https://ai-proxy.lab.epam.com",
    "serviceid": "AzureGtp35TurboService"
  },
  {
    "model": "gpt-4-32k",
    "apikey": "",
    "endpoint": "https://ai-proxy.lab.epam.com",
    "serviceid": "AzureGtp4TurboService"
  },
  {
    "model": "google/flan-t5-xxl",
    "apikey": "",
    "endpoint": "none",
    "serviceid": "HuggingFaceService"
  }
]
EOL
)

settingsJsonFilePath="$configFolder/settings.json"
echo "$settingsJsonContent" > "$settingsJsonFilePath"

echo "Solution and project created successfully."

# Run the application
echo "Running the application..."
cd "$solutionDirectory" || exit
dotnet run --project "$projectName"
