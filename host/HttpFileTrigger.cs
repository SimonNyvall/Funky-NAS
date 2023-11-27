using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace FunkuNAS.Trigger.Http;

public class HttpFileTrigger
{


    [Function("GetFiles")]
    public async Task GetFiles([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequestData req,
      FunctionContext executionContext)
    {
        var logger = executionContext.GetLogger("GetFiles");
        logger.LogInformation("C# HTTP trigger function processed a request.");

        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteStringAsync("Hello World!");
    }
}
