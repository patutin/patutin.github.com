using Microsoft.SemanticKernel;
using Kernel = Microsoft.SemanticKernel.Kernel;
using System.ComponentModel;

public class CustomPlugin
{
    private readonly Kernel _kernel;
    private readonly IPromptTemplateFactory _promptTemplateFactory;
    private readonly string _serviceId;

    public CustomPlugin(Kernel kernel, IPromptTemplateFactory promptTemplateFactory = null, string serviceId = "gpt35TurboServiceId")
    {
        _kernel = kernel;
        _promptTemplateFactory = promptTemplateFactory ?? new KernelPromptTemplateFactory();
        _serviceId = serviceId;
    }

    [KernelFunction("Translate"), Description("Initiates a translation task with the ChatBot by requesting the translation of a given text to a specified language.")]
    public async Task<string> TranslateAsync(KernelArguments arguments)
    {
        var prompt = @"Place your promt here";

        var renderedPrompt = await _promptTemplateFactory.Create(new PromptTemplateConfig(prompt)).RenderAsync(_kernel, arguments);

        var skFunction = _kernel.CreateFunctionFromPrompt(
            promptTemplate: renderedPrompt,
            functionName: nameof(TranslateAsync),
            description: "Complete the prompt.");

        var result = await skFunction.InvokeAsync(_kernel, arguments);
        return result?.GetValue<string>() ?? string.Empty;
    }
}