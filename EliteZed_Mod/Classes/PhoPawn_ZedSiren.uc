class PhoPawn_ZedSiren extends KFPawn_ZedSiren_Versus;

simulated function PostBeginPlay() {
	super.PostBeginPlay();
	SetTimer( 0.01f, true, nameof(ChangeKFAICstate) );
}

function ChangeKFAICstate() {
	if (Controller!=None) {
		KFAIController_ZedSiren(Controller).ScreamCooldown = 1.0;
		if (IsTimerActive(nameof(ChangeKFAICstate))) {
			ClearTimer( nameof(ChangeKFAICstate) );
		}
	}
}

simulated function ANIMNOTIFY_SirenScream()
{
	local PhoSM_Siren_Scream ScreamSM;

	ScreamSM = PhoSM_Siren_Scream(SpecialMoves[SpecialMove]);
    if( ScreamSM != none )
    {
    	ScreamSM.ScreamBegan();
    	if( WorldInfo.NetMode != NM_Client )
    	{
	    	DisablebOnDeathAchivement();
	    }
    }
}


defaultproperties
{
    SprintSpeed=400.0f  //420
    SprintStrafeSpeed=300.f
    GroundSpeed=200.0f 

	DifficultySettings=class'PhoDifficulty_Siren'
    ControllerClass=class'PhoAIController_ZedSiren'

    // Off by default, turned on by the vortex SM
	bCanHeadTrack=false
	bIsHeadTrackingActive=false

    Health=400 
    HitZones[HZI_HEAD]=(ZoneName=head, BoneName=Head, Limb=BP_Head, GoreHealth=210, DmgScale=1.01, SkinID=1)

	DoshValue=30

    ParryResistance=2 

	// for reference: Vulnerability=(default, head, legs, arms, special)
	IncapSettings(AF_Stun)=		(Vulnerability=(0.5, 0.5, 0.1, 0.1, 0.1), Cooldown=5.0,  Duration=1.5)
	IncapSettings(AF_Knockdown)=(Vulnerability=(0.2),                     Cooldown=1.0)
	IncapSettings(AF_Stumble)=	(Vulnerability=(0.1),                     Cooldown=1.0)   
	IncapSettings(AF_GunHit)=	(Vulnerability=(0.0, 0.0, 0.0, 0.0, 0.0),  Cooldown=0.2)
	IncapSettings(AF_MeleeHit)=	(Vulnerability=(0.0),                     Cooldown=0.0)
	IncapSettings(AF_FirePanic)=(Vulnerability=(0.9),                     Cooldown=6.0,  Duration=5.0)
	IncapSettings(AF_EMP)=		(Vulnerability=(1.0),                     Cooldown=5.0,  Duration=5.0)
	IncapSettings(AF_Poison)=	(Vulnerability=(0.15),	                  Cooldown=20.5, Duration=5.0)
	IncapSettings(AF_Microwave)=(Vulnerability=(0.5),                       Cooldown=6.5,  Duration=4.0)
	IncapSettings(AF_Freeze)=	(Vulnerability=(1.0),                     Cooldown=1.5,  Duration=4.2)
	IncapSettings(AF_Snare)=	(Vulnerability=(0.7, 0.7, 1.0, 0.7, 0.7), Cooldown=5.5,  Duration=3.0)
  IncapSettings(AF_Bleed)=    (Vulnerability=(0.25))

	DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Submachinegun', 	DamageScale=(1.0))) //0.75
  DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_AssaultRifle', 	DamageScale=(1.0)))
  DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Shotgun', 	        DamageScale=(1.0)))
  DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Handgun', 	        DamageScale=(1.0)))  //0.7
  DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Rifle', 	        DamageScale=(1.0)))  //0.75
  DamageTypeModifiers.Add((DamageType=class'KFDT_Slashing', 	                DamageScale=(1.0)))  //0.75
	DamageTypeModifiers.Add((DamageType=class'KFDT_Bludgeon', 	                DamageScale=(1.0)))  //0.85
	DamageTypeModifiers.Add((DamageType=class'KFDT_Fire', 	                    DamageScale=(0.5))) //0.5
	DamageTypeModifiers.Add((DamageType=class'KFDT_Microwave', 	                DamageScale=(0.85))) //0.85
	DamageTypeModifiers.Add((DamageType=class'KFDT_Explosive', 				    DamageScale=(0.85))) //0.6
	DamageTypeModifiers.Add((DamageType=class'KFDT_Piercing', 	                DamageScale=(0.5))) //0.5
	DamageTypeModifiers.Add((DamageType=class'KFDT_Toxic', 	                    DamageScale=(0.25))) //0.25	

	//Special Case damage resistance
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_9mm',              DamageScale=(1.0))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Rem1858',          DamageScale=(1.0))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_DBShotgun',        DamageScale=(1.1))

	Begin Object Name=MeleeHelper_0
	BaseDamage=16.f        //17 
		MaxHitRange=180.f
		MyDamageType=class'KFDT_Slashing_ZedWeak'
	End Object

  Begin Object Class=KFSpecialMoveHandler Name=SpecialMoveHandler_0 Archetype=KFSpecialMoveHandler'kfgamecontent.Default__KFPawn_ZedSiren:SpecialMoveHandler_0'
    SpecialMoveClasses(0)=None
    SpecialMoveClasses(1)=Class'KFGame.KFSM_MeleeAttack'
    SpecialMoveClasses(2)=Class'KFGame.KFSM_DoorMeleeAttack'
    SpecialMoveClasses(3)=Class'KFGame.KFSM_GrappleCombined'
    SpecialMoveClasses(4)=Class'KFGame.KFSM_Stumble'
    SpecialMoveClasses(5)=Class'KFGame.KFSM_RecoverFromRagdoll'
    SpecialMoveClasses(6)=Class'KFGame.KFSM_RagdollKnockdown'
    SpecialMoveClasses(7)=Class'KFGame.KFSM_DeathAnim'
    SpecialMoveClasses(8)=Class'KFGame.KFSM_Stunned'
    SpecialMoveClasses(9)=Class'KFGame.KFSM_Frozen'
    SpecialMoveClasses(10)=None
    SpecialMoveClasses(11)=None
    SpecialMoveClasses(12)=None
    SpecialMoveClasses(13)=Class'KFGame.KFSM_Zed_Taunt'
    SpecialMoveClasses(14)=Class'KFGame.KFSM_Zed_WalkingTaunt'
    SpecialMoveClasses(15)=Class'KFGame.KFSM_Evade'
    SpecialMoveClasses(16)=Class'kfgamecontent.KFSM_Evade_Fear'     
    SpecialMoveClasses(17)=None
    SpecialMoveClasses(18)=None
    SpecialMoveClasses(19)=None
    SpecialMoveClasses(20)=Class'PM_Mod.PhoSM_Siren_Scream'
    SpecialMoveClasses(21)=None
    SpecialMoveClasses(22)=None
    SpecialMoveClasses(23)=None
    SpecialMoveClasses(24)=None
    SpecialMoveClasses(25)=Class'PM_Mod.VSSM_Siren_VortexScream'
    SpecialMoveClasses(26)=None
    SpecialMoveClasses(27)=None
    SpecialMoveClasses(28)=None
    SpecialMoveClasses(29)=None
    SpecialMoveClasses(30)=None
    SpecialMoveClasses(31)=None
    SpecialMoveClasses(32)=None
    SpecialMoveClasses(33)=None
    SpecialMoveClasses(34)=None
    SpecialMoveClasses(35)=Class'KFGame.KFSM_Zed_Boss_Theatrics'
    Name="SpecialMoveHandler_0"
    ObjectArchetype=KFSpecialMoveHandler'kfgamecontent.Default__KFPawn_ZedSiren:SpecialMoveHandler_0'
  End Object
  SpecialMoveHandler=KFSpecialMoveHandler'PM_Mod.Default__PowerZeds_KFP_Siren:SpecialMoveHandler_0'
}