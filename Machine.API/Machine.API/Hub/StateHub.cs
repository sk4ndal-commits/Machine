using Machine.API.Dtos;

namespace Machine.API.Hub;

using Microsoft.AspNetCore.SignalR;

public class StateHub : Hub
{
    public async Task StatusUpdated(LightStatusRecord lightData)
    {
        await Clients.All.SendAsync("StatusUpdated", lightData);
    }
}