using Machine.API.Dtos;
using Machine.API.Enums;
using Machine.API.Hub;
using Machine.API.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;

namespace Machine.API.Controller;

[ApiController]
[Route("api/[controller]")]
public class LighterController(
    ILightStatusService lightStatusService,
    IHubContext<StateHub> hubContext)
    : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        var status = lightStatusService.GetStatus();
        return Ok(new LightStatusRecord(status));
    }


    [HttpPost("toggle")]
    public async Task<IActionResult> Toggle()
    {
        lightStatusService.Toggle();
        var status = lightStatusService.GetStatus();
        
        await hubContext.Clients.All.SendAsync("StatusUpdated", status);
        
        return Ok(new LightStatusRecord(status));
    }
}