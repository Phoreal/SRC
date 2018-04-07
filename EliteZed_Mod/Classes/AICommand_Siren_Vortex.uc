class AICommand_Siren_Vortex extends AICommand_SpecialMove
	within PhoAIController_ZedSiren;


static function bool Vortex(PhoAIController_ZedSiren AI)
{
    local AICommand_Siren_Vortex Cmd;

    if (AI != None)
    {
        Cmd = new(AI) Default.Class;
        if (Cmd != None)
        {
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }

    return false;
}