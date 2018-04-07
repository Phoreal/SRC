class PhoPawn_ZedScrake extends KFPawn_ZedScrake;

function SetSprinting(bool bNewSprintStatus)
{
    // End:0x19
    if(bEmpDisrupted)
    {
        bNewSprintStatus = false;
    }
    super.SetSprinting(bNewSprintStatus);
    //return;    
}

simulated event bool UsePlayerControlledZedSkin()
{
    return true;
    //return ReturnValue;    
}


defaultproperties
{
    Health=1250

    // Custom Hit Zones (HeadHealth, SkinTypes, etc...)
    HeadlessBleedOutTime=6.f
    HitZones[HZI_HEAD]=(ZoneName=head, BoneName=Head, Limb=BP_Head, GoreHealth=600, DmgScale=1.1, SkinID=1)
    HitZones[8]       =(ZoneName=rforearm, BoneName=RightForearm, Limb=BP_RightArm, GoreHealth=20,  DmgScale=0.2, SkinID=2)
    HitZones.Add((ZoneName=rchainsaw, BoneName=RightForearm, Limb=BP_RightArm, GoreHealth=20, DmgScale=0.2, SkinID=2))
    HitZones.Add((ZoneName=rchainsawblade, BoneName=RightForearm, Limb=BP_RightArm, GoreHealth=20, DmgScale=0.2, SkinID=2))

    DoshValue=260

    DifficultySettings=class'PhoDifficulty_Scrake'
    ControllerClass=class'PhoAIController_ZedScrake'

    // for reference: Vulnerability=(default, head, legs, arms, special)
    IncapSettings(AF_Stun)=     (Vulnerability=(0.2, 0.7, 0.2, 0.2, 0.2),   Cooldown=10, Duration=1.5) //cooldown 10
    IncapSettings(AF_Knockdown)=(Vulnerability=(0.2),                       Cooldown=10)  //leg0.4
    IncapSettings(AF_Stumble)=  (Vulnerability=(0.1),                       Cooldown=5) //2.5
    IncapSettings(AF_GunHit)=   (Vulnerability=(0.0),                       Cooldown=1.7)
    IncapSettings(AF_MeleeHit)= (Vulnerability=(0.0),                       Cooldown=1.35)
    IncapSettings(AF_Poison)=   (Vulnerability=(0.15),                      Cooldown=20.5, Duration=1.5)
    IncapSettings(AF_Microwave)=(Vulnerability=(0.5),                       Cooldown=10.0, Duration=2.5)
    IncapSettings(AF_FirePanic)=(Vulnerability=(0.8),                       Cooldown=7.0,  Duration=1.5)
    IncapSettings(AF_EMP)=      (Vulnerability=(0.7),                       Cooldown=10.0, Duration=2.2)
    IncapSettings(AF_Freeze)=   (Vulnerability=(0.5),                       Cooldown=6.0,  Duration=1.0)
    IncapSettings(AF_Snare)=    (Vulnerability=(0.7, 0.7, 1.0, 0.7),        Cooldown=8.5,  Duration=1.5)
    IncapSettings(AF_Bleed)=    (Vulnerability=(0.25))

    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Submachinegun',    DamageScale=(1.0))) //0.5
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_AssaultRifle',     DamageScale=(1.0))) //0.7
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Shotgun',          DamageScale=(0.9)))  //0.8
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Handgun',          DamageScale=(0.80))) //0.8
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Rifle',            DamageScale=(1.0)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Slashing',                   DamageScale=(1.0))) //0.75
    DamageTypeModifiers.Add((DamageType=class'KFDT_Bludgeon',                   DamageScale=(1.0))) //0.75
    DamageTypeModifiers.Add((DamageType=class'KFDT_Fire',                       DamageScale=(0.3)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Microwave',                  DamageScale=(1.0)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Explosive',                  DamageScale=(0.4)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Piercing',                   DamageScale=(0.75)))    
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_RPG7Impact',       DamageScale=(4.f)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Toxic',                      DamageScale=(0.25)))

    ParryResistance=6
    PenetrationResistance=4.5

   ChainsawIdleAkComponent=ChainsawAkComponent0

    Begin Object Class=Bleed_MeleeHelper Name=BleedMeleeHelper_0
        BaseDamage=33.000000
        MomentumTransfer=45000.000000
        MaxHitRange=200.000000
        MyDamageType=class'PhoDT_Bleeding'
        Name="BleedMeleeHelper_0"
        ObjectArchetype=Bleed_MeleeHelper'PM_Mod.Default__Bleed_MeleeHelper'
    End Object
         MeleeAttackHelper=Bleed_MeleeHelper'PM_Mod.Default__PowerZeds_KFP_Scrake:BleedMeleeHelper_0'

   GroundSpeed=375.000000   //325 doesnt use new sprinting animation
   SprintSpeed=660.000000
   SprintStrafeSpeed=350.000000
}