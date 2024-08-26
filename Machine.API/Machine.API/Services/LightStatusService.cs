using Machine.API.Enums;

namespace Machine.API.Services;

public class LightStatusService : ILightStatusService
{
    private LightStatus _lightStatus = LightStatus.LightOff;


    public LightStatus GetStatus()
    {
        return _lightStatus;
    }

    public void Toggle()
    {
        _lightStatus = _lightStatus switch
        {
            LightStatus.LightOn => LightStatus.LightOff,
            LightStatus.LightOff => LightStatus.LightOn,
            _ => throw new ArgumentOutOfRangeException()
        };
    }
}