class VSSM_Siren_VortexScream extends KFSM_PlayerSiren_VortexScream;

function Timer_CheckVortex()
{
    local KFPawn KFP, BestTarget;
    local Vector CameraNormal, Projection, TraceStart, GrabLocation;
    local float FOV, DistSq, BestDistSq;

    CameraNormal = vector(KFPOwner.Rotation);
    TraceStart = KFPOwner.Location + (KFPOwner.BaseEyeHeight * vect(0.0, 0.0, 1.0));

    foreach KFPOwner.WorldInfo.AllPawns(class'KFPawn', KFP)
    {

        if((KFP.GetTeamNum() != KFPOwner.GetTeamNum()) && CanInteractWithPawn(KFP))
        {
            Projection = KFP.Location - TraceStart;
            DistSq = VSizeSq(Projection);

            if(DistSq <= MaxRangeSQ)
            {
                FOV = CameraNormal Dot Normal(Projection);

                if(FOV > MinGrabTargetFOV)
                {
                    GrabLocation = KFP.Location + (KFP.BaseEyeHeight * vect(0.0, 0.0, 1.0));

                    if((IsPawnPathClear(KFPOwner, KFP, GrabLocation, TraceStart, vect(2.0, 2.0, 2.0),, true)) && IsPawnPathClear(KFPOwner, KFP, GrabLocation, TraceStart,,, true))
                    {

                        if((BestTarget == none) || DistSq < BestDistSq)
                        {
                            BestDistSq = DistSq;
                            BestTarget = KFP;
                        }
                    }
                }
            }
        }        
    }    

    if(BestTarget != none)
    {
        FollowerAttachTime = KFPOwner.WorldInfo.TimeSeconds;
        KFPOwner.DoSpecialMove(KFPOwner.SpecialMove, true, BestTarget);
        Timer_DamageFollower();
        KFPOwner.SetTimer(1.0, true, 'Timer_DamageFollower', self);
        KFPOwner.ClearTimer('Timer_CheckVortex', self);
    }    
}

defaultproperties
{
   MinGrabTargetFOV=0.500000
   VortexDuration=2.000000
   AlignDistance=375.000000
}
