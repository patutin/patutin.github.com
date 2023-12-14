# Workshop 3: Plugins in SemanticKernel

## Practical Tasks

### Task 1: Import functions from plugins
- Open project created on previous session.
- Call function from TimePlugin.

### Task 2: Create plugin using code
- Add folder Plugins to the project.
- Add folder CustomPlugin to the project.
- Add CustomPlugin.cs into the folder.
- Fill the CustomPlugin.cs with the code (Example you can get [here](https://github.com/patutin/patutin.github.com/blob/main/semantickernel/example/CustomPlugin.cs)).
- Implement "Traslate" function.
- Call "Translate" function from the main application code.

### Task 3: Create orchestrator function
- Add one more function to the CustomPlugin.cs.
- Implement multi-step function that: 
  - Ask LLM model top 3 books about {{interest}} and format response as json.
  - Deserialize JSON response and get a list of the books.
  - Call the LLM function to get the short summary of the book.
  - Using the [FileIOPlugin](https://github.com/microsoft/semantic-kernel/blob/dotnet-1.0.0-rc3/dotnet/src/Plugins/Plugins.Core/FileIOPlugin.cs) save the short summary to the file.

### Task 4: Get Access to Google Custom Search API (Optional)
- Create a new project at https://console.developers.google.com/apis/dashboard
- Create a new API key at https://console.developers.google.com/apis/credentials
- Enable the Custom Search API at https://console.developers.google.com/apis/library/customsearch.googleapis.com
- Create a new Custom Search Engine at https://cse.google.com/cse/all
- Add your API Key and your Custom Search Engine ID to settings.json and load keys from configuration.
- Write a function that takes a search term and returns the first result from Google Custom Search API.

> **Usage Limits**
> Google gives you 100 free searches per day. You can increase this limit by creating a billing account.

## Get Fun
- Use your imagination.
