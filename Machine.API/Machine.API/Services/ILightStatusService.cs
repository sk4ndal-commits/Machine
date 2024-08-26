using Machine.API.Enums;

namespace Machine.API.Services;

public interface ILightStatusService
{
    LightStatus GetStatus();
    void Toggle();
}