class Bleed_MeleeHelper extends KFMeleeHelperAI within Actor;

simulated function PlayMeleeHitEffects(Actor Target, vector HitLocation, vector HitDirection, optional bool bShakeInstigatorCamera=true)
{
    Super.PlayMeleeHitEffects(Target,HitLocation,HitDirection,bShakeInstigatorCamera);
    if( WorldInfo.NetMode!=NM_Client && KFPawn(Target)!=None && KFPawn(Target).Health>0 && KFPawn(Target).AfflictionHandler!=None )
        KFPawn(Target).AfflictionHandler.AccrueAffliction(AF_Bleed,8.f);
}

defaultproperties
{
   MyDamageType=Class'PM_Mod.PhoDT_Bleeding'
   Name="Default__Bleed_MeleeHelper"
   ObjectArchetype=KFMeleeHelperAI'KFGame.Default__KFMeleeHelperAI'
}
