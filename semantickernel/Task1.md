## Session 1: Introduction to SemanticKernel

### Prerequisites
- Ensure you have received the Azure OpenAI API keys via email.
- Install [.NET SDK](https://dotnet.microsoft.com/download) version 7.0 or later on your machine.

### Step 1. Warm Up: Install and Configure

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/patutin/SemanticKernelWorkshop.git
    cd SemanticKernelWorkshop
    ```

2. **Check Installed .NET Versions:**

    ```bash
    dotnet --list-sdks
    ```

    Ensure that .NET version 7.0 is installed.

3. **Run the PowerShell Script:**

    Run the provided PowerShell script to set up the project, creating a new solution, console project, and adding necessary configurations.

    [setupproject.ps1](https://github.com/patutin/patutin.github.com/blob/main/semantickernel/scripts/setupproject.ps1)

4. **Run the Shell Script:**

    Run the provided shell script to set up the project. Similar to the PowerShell script, it automates the creation of the solution, console project, and necessary configurations.

    [setupproject.sh](https://github.com/patutin/patutin.github.com/blob/main/semantickernel/scripts/setupproject.sh)

5. **Set API Keys:**

    - Review the created files in the project directory.
    - Add your API keys or make any necessary adjustments in the `settings.json` file.

    Example of adding API keys to `Config/settings.json`:

    ```json
    [
      {
        "model": "gpt-35-turbo",
        "apikey": "your-api-key-1",
        "endpoint": "https://ai-proxy.lab.epam.com",
        "serviceid": "AzureGpt35TurboService"
      },
      {
        "model": "gpt-4-32k",
        "apikey": "your-api-key-2",
        "endpoint": "https://ai-proxy.lab.epam.com",
        "serviceid": "AzureGpt4TurboService"
      },
      {
        "model": "google/flan-t5-xxl",
        "apikey": "your-api-key-3",
        "endpoint": "none",
        "serviceid": "HuggingFaceService"
      }
    ]
    ```

6. **Run the Application:**

    ```bash
    cd SemanticKernelWorkshop
    dotnet run --project SemanticKernel.WorkshopTasks
    ```

    This will execute your application and display the initial program output.

Now you have successfully set up the SemanticKernelWorkshop project. Feel free to explore, modify, and build upon it for your Semantic Kernel workshop.

### Step 2. Calling Azure OpenAI API 
- **2.1 Create your first call to Azure OpenAI LLM model**:
  -  Develop code to make the initial request to the Azure OpenAI LLM model using SemanticKernel. Ask the Azure OpenAI to provide the top 10 best dishes in the world.
  -  Add a parameter to your prompt and ask the top 10 dishes in the county you pass as a parameter.
  -  Replace the gpt35-turbo model with gpt4-32k model, call the same prompt, and check the results.
  -  Add ChatHistory to your conversation with LLM.

### Step 3. HuggingFace: Register and Get an API Key

1. **Register or Login:**
   - Visit the Hugging Face website: [https://huggingface.co/](https://huggingface.co/)

2. **Generate an API Token:**
   - Log in to Hugging Face.
   - Click on your username and select "Settings".
   - In the "Access Tokens" tab, click the "New Token" button.
   - Enter a descriptive name for your token.
   - Select the appropriate permissions for your token.
   - Click the "Generate token" button.
   - Copy the generated API token and save it securely.

### Step 4: HuggingFace Model Call

1. **Integrate HuggingFace Model**:

   - Replace the Azure OpenAI model with a HuggingFace model.
   - Check that the code with the new model works as expected.

   <details>
     <summary>Hint</summary>

     You need to replace `AddAzureOpenAIChatCompletion` with `AddHuggingFaceChatCompletion`.
     Depending on the NuGet package version, you may need to suppress warnings with pragma: `#pragma warning disable SKEXP0020`.

   </details>

### Final Steps
- **Explore Different Models**: [https://huggingface.co/models](https://huggingface.co/models)
