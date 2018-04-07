class EMP_MeleeHelper extends KFMeleeHelperAI within Actor;

simulated function PlayMeleeHitEffects(Actor Target, vector HitLocation, vector HitDirection, optional bool bShakeInstigatorCamera=true)
{
    Super.PlayMeleeHitEffects(Target,HitLocation,HitDirection,bShakeInstigatorCamera);
    if( WorldInfo.NetMode!=NM_Client && KFPawn(Target)!=None && KFPawn(Target).Health>0 && KFPawn(Target).AfflictionHandler!=None )
        KFPawn(Target).AfflictionHandler.AccrueAffliction(AF_EMP,8.f);
}

defaultproperties
{
   MyDamageType=Class'PM_Mod.PhoDT_EMP'
   Name="Default__EMP_MeleeHelper"
   ObjectArchetype=KFMeleeHelperAI'KFGame.Default__KFMeleeHelperAI'
}
