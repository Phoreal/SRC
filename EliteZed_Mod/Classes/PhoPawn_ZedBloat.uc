class PhoPawn_ZedBloat extends KFPawn_ZedBloat_Versus;

const MineNum = 3;
const MaxPukeCount = 1;
var array<rotator> DeathPukeMineRotations_Mine;
var byte PukeCount;

simulated function PostBeginPlay(){
	local int i;
	super.PostBeginPlay();
	DeathPukeMineRotations_Mine.Add(MineNum);
	for (i=0;i<MineNum;++i) {
		DeathPukeMineRotations_Mine[i].Pitch = 8190;
		DeathPukeMineRotations_Mine[i].Yaw = (2*32768)*i/MineNum-32768;
		DeathPukeMineRotations_Mine[i].Roll = 0;
	}
	PukeCount = 0;
}

/** This pawn has died. */
function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	My_Puke();
	return super.Died( Killer, damageType, HitLocation );
}

function Puke() {
	super.Puke();
	if (PukeCount++<MaxPukeCount) {
		My_Puke();
	}
}

//Ž©ìƒQƒ“Š‰ºŠÖ”
function My_Puke(){
	local rotator DPMR;
	foreach DeathPukeMineRotations_Mine(DPMR) {
		SpawnPukeMine(Location,DPMR);
	}
}

defaultproperties
{
	Health=550
	HeadlessBleedOutTime=6.f
	// Override Head GoreHealth (aka HeadHealth)
    HitZones[HZI_HEAD]=(ZoneName=head, BoneName=Head, Limb=BP_Head, GoreHealth=115, DmgScale=1.0001, SkinID=1)
	HitZones.Add((ZoneName=rknife, BoneName=RightForearm, Limb=BP_RightArm, GoreHealth=20, DmgScale=0.2, SkinID=2))
	HitZones.Add((ZoneName=lknife, BoneName=LeftForearm, Limb=BP_LeftArm, GoreHealth=20, DmgScale=0.2, SkinID=2))

	DoshValue=20

	PukeMineProjectileClass=class'PM_Mod.PhoProj_BloatPukeMine'
    DifficultySettings=class'PhoDifficulty_Bloat'
    ControllerClass=class'PhoAIController_ZedBloat'


	// for reference: Vulnerability=(default, head, legs, arms, special)
	IncapSettings(AF_Stun)=		(Vulnerability=(0.2, 0.7, 0.2, 0.2, 0.2), Cooldown=5.0,  Duration=1.5)
	IncapSettings(AF_Knockdown)=(Vulnerability=(0.2),	                  Cooldown=1.0)
	IncapSettings(AF_Stumble)=	(Vulnerability=(0.1),	                  Cooldown=1.0)
	IncapSettings(AF_GunHit)=	(Vulnerability=(0.0, 0.0, 0.0, 0.0, 0.0),	Cooldown=0.1)
	IncapSettings(AF_MeleeHit)=	(Vulnerability=(0.0),	                  Cooldown=0.3)
	IncapSettings(AF_Poison)=	(Vulnerability=(0.0),	                  Cooldown=20.5, Duration=5.0)
	IncapSettings(AF_Microwave)=(Vulnerability=(0.5),	                  Cooldown=5.0,  Duration=8.0)
	IncapSettings(AF_FirePanic)=(Vulnerability=(0.9),		                  Cooldown=5.0,	 Duration=3.7) //duration 8
	IncapSettings(AF_EMP)=		(Vulnerability=(0.7),                     Cooldown=5.0,  Duration=3.0)
	IncapSettings(AF_Freeze)=	(Vulnerability=(0.5),                     Cooldown=3.0,  Duration=2.0)
    IncapSettings(AF_Snare)=	(Vulnerability=(0.7, 0.7, 1.0, 0.7),      Cooldown=5.5,  Duration=3.0)
    IncapSettings(AF_Bleed)=    (Vulnerability=(0.25))

    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Submachinegun', 	DamageScale=(0.35)))  //0.25
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_AssaultRifle', 	DamageScale=(0.35)))  //0.25
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Shotgun', 	        DamageScale=(0.25)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Handgun', 	        DamageScale=(0.35)))  //0.2
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Rifle', 	        DamageScale=(0.30)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Slashing', 	                DamageScale=(0.3)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Bludgeon', 	                DamageScale=(0.3)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Fire', 	                    DamageScale=(1.0)))  //1.2 //1.6
	DamageTypeModifiers.Add((DamageType=class'KFDT_Microwave', 	                DamageScale=(0.8)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Explosive', 	                DamageScale=(0.5)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Piercing', 	                DamageScale=(0.25)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Toxic', 		                DamageScale=(0.0)))

	//Special Case damage resistance
	DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_9mm',              DamageScale=(0.65))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_AR15',             DamageScale=(0.40))

	SprintSpeed=400
	SprintStrafeSpeed=300.f
	Groundspeed=260

	ParryResistance=4

	PenetrationResistance=3.5

    // Gameplay
	VomitRange=400.f
	VomitDamage=14		//16
	ExplodeRange=550.f
	Begin Object Name=MeleeHelper_0
		BaseDamage=17.f 		//18
		MaxHitRange=250.f
		MomentumTransfer=25000.f
		MyDamageType=class'KFDT_Slashing_ZedWeak'
	End Object
}