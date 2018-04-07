class PhoPawn_ZedEliteGorefast extends KFPawn_ZedGorefast_Versus;

defaultproperties
{
    // Override Head GoreHealth (aka HeadHealth)
    Health=300
    HitZones[HZI_HEAD]=(ZoneName=head, BoneName=Head, Limb=BP_Head, GoreHealth=120, DmgScale=1.001, SkinID=1) // default is 20
	
    DifficultySettings=class'KFDifficulty_Gorefast'
    ControllerClass=class'PhoAIController_ZedGorefast'

    DoshValue=14

   Begin Object Class=EMP_MeleeHelper Name=EMPMeleeHelper_0
      BaseDamage=12.000000
      MomentumTransfer=25000.000000
      MaxHitRange=210.000000
      MyDamageType=class'PhoDT_EMP'
      Name="EMPMeleeHelper_0"
      ObjectArchetype=EMP_MeleeHelper'PM_Mod.Default__EMP_MeleeHelper'
   End Object
   MeleeAttackHelper=EMP_MeleeHelper'PM_Mod.Default__PhoPawn_ZedEliteGorefast:EMPMeleeHelper_0'


	PenetrationResistance=2

 	ParryResistance=3

	IncapSettings(AF_Stun)=		(Vulnerability=(0.2, 0.7, 0.2, 0.2, 0.2), Cooldown=10.0, Duration=1.5) //0.5, 1.0, 0.5, 0.5, 0.5
    IncapSettings(AF_Knockdown)=(Vulnerability=(0.2),                     Cooldown=10)
    IncapSettings(AF_Stumble)=	(Vulnerability=(0.1),                     Cooldown=5)
    IncapSettings(AF_GunHit)=	(Vulnerability=(0.0),                     Cooldown=1.7)
    IncapSettings(AF_MeleeHit)=	(Vulnerability=(0.0),                     Cooldown=1.35)
    IncapSettings(AF_Poison)=	(Vulnerability=(0.6),                     Cooldown=20.0, Duration=1.5)
    IncapSettings(AF_Microwave)=(Vulnerability=(0.5),                     Cooldown=10.0, Duration=2.5)
    IncapSettings(AF_FirePanic)=(Vulnerability=(0.9),                     Cooldown=5.0,  Duration=3.0)
    IncapSettings(AF_EMP)=		(Vulnerability=(0.7),                    Cooldown=10.0, Duration=2.2) //0.98
    IncapSettings(AF_Freeze)=	(Vulnerability=(0.5),                    Cooldown=1.5,  Duration=0.5) //0.98
    IncapSettings(AF_Snare)=	(Vulnerability=(0.7, 0.7, 1.0, 0.7),      Cooldown=8.5,  Duration=1.5)
    IncapSettings(AF_Bleed)=    (Vulnerability=(0.25))

    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Submachinegun',    DamageScale=(1.0))) 
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_AssaultRifle',     DamageScale=(1.2)))  
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Shotgun',          DamageScale=(1.6)))   
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Handgun',          DamageScale=(1.0))) 
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Rifle',            DamageScale=(1.25)))   
    DamageTypeModifiers.Add((DamageType=class'KFDT_Slashing',                   DamageScale=(0.8)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Bludgeon',                   DamageScale=(0.9)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Fire',                       DamageScale=(0.85))) 
    DamageTypeModifiers.Add((DamageType=class'KFDT_Microwave',                  DamageScale=(0.85)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Explosive',                  DamageScale=(1.0)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Piercing',                   DamageScale=(0.75)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Toxic',                      DamageScale=(0.75)))

    //Special Case damage resistance
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_9mm',              DamageScale=(1.0))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Rem1858',          DamageScale=(1.0))

    SprintSpeed=550 
    SprintStrafeSpeed=350
    GroundSpeed=350 

}