class PhoPawn_ZedHusk extends KFPawn_ZedHusk;

const MyTimeBetweenFireBalls = 0.20f; //0.15

simulated function PostBeginPlay() {
	super.PostBeginPlay();
	SetTimer( 0.01f, true, nameof(ChangeKFAICstate) );
}

function ChangeKFAICstate() {
	if (Controller!=None) {
		KFAIController_ZedHusk(Controller).MaxDistanceForFireBall=4500;
		KFAIController_ZedHusk(Controller).RequiredHealthPercentForSuicide=0.45f;
		KFAIController_ZedHusk(Controller).TimeBetweenFlameThrower=0.5;
		KFAIController_ZedHusk(Controller).MaxDistanceForFlameThrower=550;
		if (IsTimerActive(nameof(ChangeKFAICstate))) {
			ClearTimer( nameof(ChangeKFAICstate) );
		}
	}
}

/** If true, assign custom player controlled skin when available */
simulated event bool UsePlayerControlledZedSkin() {
	return true;
}

//火球発射間隔の設定
simulated event Tick( float DeltaTime ) {
	super.Tick( DeltaTime );
	if (Controller!=None) {
		KFAIController_ZedHusk(Controller).TimeBetweenFireBalls = MyTimeBetweenFireBalls;
//		MyController.TimeBetweenFireBalls = MyTimeBetweenFireBalls;
	}
}

/** Turns medium range flamethrower effect on */
simulated function ANIMNOTIFY_FlameThrowerOn()
{
    if( IsDoingSpecialMove(SM_HoseWeaponAttack) )
	{
		PhoSM_Husk_FlameThrowerAttack(SpecialMoves[SpecialMove]).TurnOnFlamethrower();
	}
}

/** Turns medium range flamethrower effect off */
simulated function ANIMNOTIFY_FlameThrowerOff()
{
    if( IsDoingSpecialMove(SM_HoseWeaponAttack) )
	{
		PhoSM_Husk_FlameThrowerAttack(SpecialMoves[SpecialMove]).TurnOffFlamethrower();
	}
}

/** Called from melee special move when it's interrupted */
function NotifyAnimInterrupt( optional AnimNodeSequence SeqNode )
{
	if( MyKFAIC != none && (IsImpaired() || IsHeadless()) && !MyKFAIC.GetActiveCommand().IsA('AICommand_HeadlessWander') )
	{
		class'AICommand_HeadlessWander'.Static.HeadlessWander( MyKFAIC );
	}
}

defaultproperties
{

	Health=600 
	HitZones[HZI_HEAD]=(ZoneName=head, BoneName=Head, Limb=BP_Head, GoreHealth=285, DmgScale=1.001, SkinID=1)  // KF1=200     
	HitZones[3]       =(ZoneName=heart,	   BoneName=Spine2,		  Limb=BP_Special,  GoreHealth=110,  DmgScale=1.1, SkinID=2)    
	HitZones[8]		  =(ZoneName=rforearm, BoneName=RightForearm, Limb=BP_RightArm, GoreHealth=20,  DmgScale=0.5, SkinID=3)
	
	Begin Object Name=MeleeHelper_0
		BaseDamage=18.f 		/15
		MaxHitRange=180.f
		MomentumTransfer=25000.f
		MyDamageType=class'KFDT_Slashing_ZedWeak'
	End Object

	DoshValue=20

	PenetrationResistance=2.5
	ParryResistance=3

    SprintSpeed=570.f 
    SprintStrafeSpeed=425.f 
    GroundSpeed=250.0f 

	ControllerClass=class'PhoAIController_ZedHusk'
	DifficultySettings=class'KFDifficulty_Husk'
	
	DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Submachinegun', 	DamageScale=(0.75))) //0.5
	DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_AssaultRifle', 	DamageScale=(0.65))) //0.5
	DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Shotgun', 	        DamageScale=(1.0)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Handgun', 	        DamageScale=(0.85)))  //0.4
	DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Rifle', 	        DamageScale=(0.7))) //1
    DamageTypeModifiers.Add((DamageType=class'KFDT_Slashing', 	                DamageScale=(0.75)))  //0.45
	DamageTypeModifiers.Add((DamageType=class'KFDT_Bludgeon', 	                DamageScale=(0.85)))  //0.45
	DamageTypeModifiers.Add((DamageType=class'KFDT_Fire', 	                    DamageScale=(0.0)))  //0
	DamageTypeModifiers.Add((DamageType=class'KFDT_Microwave', 	                DamageScale=(1.15)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Explosive', 				    DamageScale=(0.75)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Piercing', 	                DamageScale=(0.5)))	
	DamageTypeModifiers.Add((DamageType=class'KFDT_Toxic', 	                    DamageScale=(0.25)))

	//Special Case damage resistance
	DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_9mm',              DamageScale=(1.0))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Rem1858',          DamageScale=(1.0))

		
	// for reference: Vulnerability=(      default, head, legs, arms, special)
	IncapSettings(AF_Stun)=		(Vulnerability=(0.5, 0.5, 0.1, 0.1, 0.1), Cooldown=5.0,  Duration=1.5)
	IncapSettings(AF_Knockdown)=(Vulnerability=(0.2),                     Cooldown=3)
	IncapSettings(AF_Stumble)=	(Vulnerability=(0.1),                     Cooldown=1.0)
	IncapSettings(AF_GunHit)=	(Vulnerability=(0.0, 0.0, 0.0, 0.0, 0.0), Cooldown=1.0)
	IncapSettings(AF_MeleeHit)=	(Vulnerability=(0.0),                     Cooldown=0.2)
	IncapSettings(AF_FirePanic)=(Vulnerability=(0.0),                     Cooldown=5.0,  Duration=2.0)
	IncapSettings(AF_EMP)=		(Vulnerability=(0.8),                     Cooldown=5.0,  Duration=3.0)
	IncapSettings(AF_Poison)=	(Vulnerability=(0.15),	                  Cooldown=20.5, Duration=5.0)
	IncapSettings(AF_Microwave)=(Vulnerability=(0.0),                       Cooldown=8.5,  Duration=4.0)
	IncapSettings(AF_Freeze)=	(Vulnerability=(0.6),                     Cooldown=1.5,  Duration=1.0)
	IncapSettings(AF_Snare)=	(Vulnerability=(0.7, 0.7, 1.0, 0.7, 0.7), Cooldown=5.5,  Duration=3.0)
    IncapSettings(AF_Bleed)=    (Vulnerability=(1.0))

	// Content
	FireballClass= class'PM_Mod.PhoProj_Husk_Fireball'

	// Special Moves
	Begin Object Name=SpecialMoveHandler_0
		SpecialMoveClasses(SM_Taunt)		 = class'KFGame.KFSM_Zed_Taunt'
		SpecialMoveClasses(SM_Suicide)		 = class'KFSM_Husk_Suicide'
		SpecialMoveClasses(SM_Evade)		 = class'KFSM_Evade'
		SpecialMoveClasses(SM_Evade_Fear)	 = class'KFSM_Evade_Fear'
		SpecialMoveClasses(SM_StandAndShootAttack)= class'KFSM_Husk_FireBallAttack'
		SpecialMoveClasses(SM_HoseWeaponAttack)= class'PhoSM_Husk_FlameThrowerAttack'
	End Object

	// Backpack/Suicide Explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=200
		DamageRadius=550
		DamageFalloffExponent=0.5f
		DamageDelay=0.f
		bFullDamageToAttachee=true

	// Damage Effects
		MyDamageType=class'KFDT_Explosive_HuskSuicide'
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.HuskSuicide_Explosion'
		ExplosionSound=AkEvent'WW_ZED_Husk.ZED_Husk_SFX_Suicide_Explode'
		MomentumTransferScale=1.f

	// Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
	    ExploLightFadeOutTime=0.5

	// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.HuskSuicide'
		CamShakeInnerRadius=450
		CamShakeOuterRadius=900
		CamShakeFalloff=1.f
		bOrientCameraShakeTowardsEpicenter=true
		End Object
		ExplosionTemplate=ExploTemplate0
}