# Workshop 2: Chaining Function in SemanticKernel

## Overview
This workshop offers hands-on experience in creating and manipulating chains of function using SemanticKernel, covering various components and integrating different models for real-world applications.

## Practical Tasks

### Task 1: Recall first part
- Open project created on previous session.
- Create a prompt that takes one parameter (a country). The prompt asks for the most popular drinks in the country you pass.
- Define a function that uses prompt as a paramter and call it using InvokeAsync.
- Check that LLM model returns the correct results.

   <details>
     <summary>Hint</summary>
        var result = await kernel.InvokeAsync(functionName, new KernelArguments(contry));
   </details>


### Task 2: Define the chains
- Add one prompt that takes the same parameter and returns most popular dish in a country.
- Define a function and check the results of the function calling.
- Combine both funcions into array.
- Define a KernelParamter that contain country name.
- Define a batch function that takes an array of functions and runs them sequentially.
- Check the results of the function execution.
- 
### Task 3: Injecting into chains
- Define the event handlers for lifecycle events.
- Call the array of functions from the previous task using InvokeAsync.
  - List of the events:
    - FunctionInvoking.
    - FunctionInvoked.
    - PromptRendering.
    - PromptRendered.
- Review the results of the function execution.
   
   <details>
     <summary>Hint</summary>
        kernel.FunctionInvoking += Kernel_FunctionInvoking;  

        void Kernel_FunctionInvoking(object? sender, FunctionInvokingEventArgs e)
        {
            Console.WriteLine($"[FunctionInvoking]: \n\t // {e.Function.Description} \n\t {e.Function.Name} ({string.Join(":", e.Arguments)})");
        }
   </details>

### Task 4: Changing parameters inside chains
- Using event handler check the calling the second function.
- Replace the parameter value.
- Check the execution results.

<details>
  <summary>Hint</summary>
  
- You can use funtion name to check the calling the second function.

</details>

### Task 5: Optional
- Review [StepwisePlanner](https://github.com/microsoft/semantic-kernel/blob/dotnet-1.0.0-rc3/dotnet/samples/KernelSyntaxExamples/Example66_FunctionCallingStepwisePlanner.cs) example.
- Try to creat previous task using StepwisePlanner.