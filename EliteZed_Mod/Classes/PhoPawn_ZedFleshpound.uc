class PhoPawn_ZedFleshpound extends KFPawn_ZedFleshPound;

/** Shield Vars */
/** Amount of health shield has remaining */
var float                           ShieldHealth;
var float                           ShieldHealthMax;
var const array<float>              ShieldHealthMaxDefaults;
var float							ShieldHealthScale;

/** Replicated shield health percentage */
var repnotify   byte                ShieldHealthPctByte;

var float LastShieldHealthPct;
var ParticleSystem InvulnerableShieldFX;
var ParticleSystemComponent InvulnerableShieldPSC;
var name ShieldSocketName;

var KFSkinTypeEffects ShieldImpactEffects;
var KFGameExplosion ShieldShatterExplosionTemplate;

var const color ShieldColorGreen;
var const color ShieldCoreColorGreen;
var const color ShieldColorYellow;
var const color ShieldCoreColorYellow;
var const color ShieldColorOrange;
var const color ShieldCoreColorOrange;
var const color ShieldColorRed;
var const color ShieldCoreColorRed;

/** Current phase of battle */
var int CurrentPhase;

//見た目はVS
simulated event bool UsePlayerControlledZedSkin() {
	return true;
}

simulated function float GetHealthPercent()
{
    return float(Health) / float(HealthMax);
}

replication
{
    if (bNetDirty)
        CurrentPhase, ShieldHealthPctByte;
}


//
simulated event ReplicatedEvent(name VarName)
{
    if (VarName == nameof(ShieldHealthPctByte))
    {
        UpdateShield();
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
}

/** Reduce damage when in hunt and heal mode */
function AdjustDamage(out int InDamage, out vector Momentum, Controller InstigatedBy, vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    super.AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);

    if (ShieldHealth > 0)
    {
        ShieldHealth -= InDamage;

        if (ShieldHealth < 0)
        {
            InDamage = Abs(ShieldHealth);
            ShieldHealth = 0;
        }
        else
        {
            InDamage = 0;
        }

        ShieldHealthPctByte = FloatToByte(FClamp(ShieldHealth / ShieldHealthMax, 0.f, 1.f));
        UpdateShield();
    }
}

function SetShieldScale(float InScale)
{
	ShieldHealthScale = InScale;
}

function ActivateShield()
{
    local KFGameInfo KFGI;
    local float HealthMod;
    local float HeadHealthMod;

    KFGI = KFGameInfo(WorldInfo.Game);
    if (KFGI != None)
    {
        HealthMod = 1.f;
        KFGI.DifficultyInfo.GetAIHealthModifier(self, KFGI.GameDifficulty, KFGI.GetLivingPlayerCount(), HealthMod, HeadHealthMod);

        ShieldHealth = ShieldHealthMaxDefaults[KFGI.GameDifficulty] * HealthMod * ShieldHealthScale;
        ShieldHealthMax = ShieldHealth;
        ShieldHealthPctByte = 1;
        UpdateShield();
    }
}

simulated function ActivateShieldFX()
{
    InvulnerableShieldPSC = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(InvulnerableShieldFX, Mesh, ShieldSocketName, true);
    InvulnerableShieldPSC.SetAbsolute(false, true, true);
}

simulated function UpdateShield()
{
    local float ShieldHealthPct;

    // Not on dedicated servers
    if (WorldInfo.NetMode == NM_DedicatedServer)
    {
        return;
    }

    ShieldHealthPct = ByteToFloat(ShieldHealthPctByte);

    if (ShieldHealthPct > 0.f && LastShieldHealthPct <= 0.f)
    {
        ActivateShieldFX();
    }

    // Break the shield if it has no health left
    if (ShieldHealthPct == 0.f
        && InvulnerableShieldPSC != none
        && InvulnerableShieldPSC.bIsActive
        && InvulnerableShieldPSC.bAttached)
    {
        BreakShield();
    }
    else if (InvulnerableShieldPSC != none)
    {
        if (ShieldHealthPct >= 0.75f) // Green
        {
            if (LastShieldHealthPct < 0.75f)
            {
                InvulnerableShieldPSC.SetVectorParameter('Shield_Color', MakeVectorFromColor(ShieldColorGreen));
                InvulnerableShieldPSC.SetVectorParameter('Shield_CoreColor', MakeVectorFromColor(ShieldCoreColorGreen));
            }
        }
        else if (ShieldHealthPct >= 0.5f) // Yellow
        {
            if (LastShieldHealthPct >= 0.75f || LastShieldHealthPct < 0.5f)
            {
                InvulnerableShieldPSC.SetVectorParameter('Shield_Color', MakeVectorFromColor(ShieldColorYellow));
                InvulnerableShieldPSC.SetVectorParameter('Shield_CoreColor', MakeVectorFromColor(ShieldCoreColorYellow));
            }
        }
        else if (ShieldHealthPct >= 0.25f) // Orange
        {
            if (LastShieldHealthPct >= 0.5f || LastShieldHealthPct < 0.25f)
            {
                InvulnerableShieldPSC.SetVectorParameter('Shield_Color', MakeVectorFromColor(ShieldColorOrange));
                InvulnerableShieldPSC.SetVectorParameter('Shield_CoreColor', MakeVectorFromColor(ShieldCoreColorOrange));
            }
        }
        else if (LastShieldHealthPct >= 0.25f) // Red
        {
            InvulnerableShieldPSC.SetVectorParameter('Shield_Color', MakeVectorFromColor(ShieldColorRed));
            InvulnerableShieldPSC.SetVectorParameter('Shield_CoreColor', MakeVectorFromColor(ShieldCoreColorRed));
        }

        // Scale the invulnerable material param
        CharacterMICs[0].SetScalarParameterValue('Scalar_DamageResist', ShieldHealthPct);

        // Cache off so we know whether the material params need to change
        LastShieldHealthPct = ShieldHealthPct;

        UpdateShieldUI();
    }
}

/** Creates a vector parameter from a standard color */
simulated function vector MakeVectorFromColor(color InColor)
{
    local LinearColor LinColor;
    local vector ColorVec;

    LinColor = ColorToLinearColor(InColor);
    ColorVec.X = LinColor.R;
    ColorVec.Y = LinColor.G;
    ColorVec.Z = LinColor.B;

    return ColorVec;
}

/** Breaks the shield */
simulated function BreakShield()
{
    local KFExplosionActor ExplosionActor;

    if (WorldInfo.NetMode != NM_DedicatedServer)
    {
        // Detach shield and zero out material params
        DetachShieldFX();
        CharacterMICs[0].SetScalarParameterValue('Scalar_DamageResist', 0.0);

        // Spawn a shatter explosion
        ExplosionActor = Spawn(class'KFExplosionActor', self, , Location, rotator(vect(0, 0, 1)));
        if (ExplosionActor != None)
        {
            ExplosionActor.Explode(ShieldShatterExplosionTemplate);
        }
    }
}

simulated function DetachShieldFX()
{
    LastShieldHealthPct = 0.f;
    DetachEmitter(InvulnerableShieldPSC);
    UpdateShieldUI();
}

simulated function UpdateShieldUI()
{
    local KFPlayerController KFPC;

    KFPC = KFPlayerController(GetALocalPlayerController());
    if (KFPC != none && KFPC.IsLocalController())
    {
        if (KFPC.MyGFxHUD != none && KFPC.MyGFxHUD.bossHealthBar != none)
        {
            KFPC.MyGFxHUD.bossHealthBar.UpdateBossShield(LastShieldHealthPct);
        }
    }
}

DefaultProperties
{
    Health=1700

	//GoreHealth was 650
    HitZones[HZI_HEAD]=(ZoneName=head, BoneName=Head, Limb=BP_Head, GoreHealth=650, DmgScale=1.1, SkinID=1)
    HitZones[3]       =(ZoneName=heart,    BoneName=Spine1,       Limb=BP_Special,  GoreHealth=150, DmgScale=1.1, SkinID=2)
    HitZones[5]       =(ZoneName=lforearm, BoneName=LeftForearm,  Limb=BP_LeftArm,  GoreHealth=20,  DmgScale=0.2, SkinID=3)
    HitZones[8]       =(ZoneName=rforearm, BoneName=RightForearm, Limb=BP_RightArm, GoreHealth=20,  DmgScale=0.2, SkinID=3)
    DoshValue=300

    ParryResistance=6
    PenetrationResistance=5.5

    PawnAnimInfo=KFPawnAnimInfo'ZED_Fleshpound_ANIM.King_Fleshpound_AnimGroup'
    ControllerClass=class'PhoAIController_EliteFleshpound'
    DifficultySettings=class'KFDifficulty_Fleshpound'

    Begin Object Name=SpecialMoveHandler_0
        SpecialMoveClasses(SM_Taunt)=class'KFGame.KFSM_Zed_Taunt'
        SpecialMoveClasses(SM_Evade)=class'KFSM_Evade'
        SpecialMoveClasses(SM_Block)=class'KFSM_Block'
    End Object

    // for reference: Vulnerability=(default, head, legs, arms, special)
    IncapSettings(AF_Stun)=     (Vulnerability=(0.5, 0.55, 0.5, 0.0, 0.55),   Cooldown=10.0, Duration=1.55) //1.2
    IncapSettings(AF_Knockdown)=(Vulnerability=(0.25, 0.25, 0.5, 0.25, 0.4),  Cooldown=10.0)  //leg 0.25
    IncapSettings(AF_Stumble)=  (Vulnerability=(0.2, 0.25, 0.25, 0.0, 0.4),   Cooldown=5.0)
    IncapSettings(AF_GunHit)=   (Vulnerability=(0.0, 0.0, 0.0, 0.0, 0.5),     Cooldown=1.7)
    IncapSettings(AF_MeleeHit)= (Vulnerability=(1.0),                         Cooldown=1.2)
    IncapSettings(AF_Poison)=   (Vulnerability=(0.15),                        Cooldown=20.5, Duration=1.5)
    IncapSettings(AF_Microwave)=(Vulnerability=(0.8),                         Cooldown=17.0, Duration=2.5)
    IncapSettings(AF_FirePanic)=(Vulnerability=(0.7),                         Cooldown=10.0, Duration=1.5)
    IncapSettings(AF_EMP)=      (Vulnerability=(0.95),                        Cooldown=10.0, Duration=2.2)
    IncapSettings(AF_Freeze)=   (Vulnerability=(0.95),                        Cooldown=10.5,  Duration=0.5)
    IncapSettings(AF_Snare)=    (Vulnerability=(1.0, 1.0, 3.0, 1.0, 1.0),     Cooldown=8.5,  Duration=1.5)
    IncapSettings(AF_Bleed)=    (Vulnerability=(0.25))

    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Submachinegun',    DamageScale=(0.5)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_AssaultRifle',     DamageScale=(0.5)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Shotgun',          DamageScale=(0.75)))  //0.75
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Handgun',          DamageScale=(0.75)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Rifle',            DamageScale=(0.75)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Slashing',                   DamageScale=(0.5))) //0.3
    DamageTypeModifiers.Add((DamageType=class'KFDT_Bludgeon',                   DamageScale=(0.6))) //0.4
    DamageTypeModifiers.Add((DamageType=class'KFDT_Fire',                       DamageScale=(0.3)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Microwave',                  DamageScale=(1.0)))  //0.5
    DamageTypeModifiers.Add((DamageType=class'KFDT_Explosive',                  DamageScale=(1.5)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Piercing',                   DamageScale=(0.75)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Toxic',                      DamageScale=(0.25)))    
    //DamageTypeModifiers.Add((DamageType=class'KFDamageType',  DamageScale=(0.5))) // All others

    ShieldHealthMaxDefaults[0]=350
    ShieldHealthMaxDefaults[1]=400
    ShieldHealthMaxDefaults[2]=450
    ShieldHealthMaxDefaults[3]=500
	ShieldHealthScale=1.f

    Begin Object Name=MeleeHelper_0
		BaseDamage=61     //66
		MaxHitRange=250.f
		MomentumTransfer=55000.f
		MyDamageType=class'KFDT_Bludgeon_Fleshpound'
		MeleeImpactCamScale=0.45
		PlayerDoorDamageMultiplier=5.f
	End Object
	MeleeAttackHelper=MeleeHelper_0

    // Movement speeds
    SprintSpeed=800 
    SprintStrafeSpeed=450
    GroundSpeed=450

    // Shield

    //@TODO: Skin to FPK
    // invulnerable effects
    Begin Object Class=KFSkinTypeEffects_HansShield Name=ShieldEffects
    End Object

    // Shield FX
    ShieldImpactEffects=ShieldEffects
    //@TODO: Skin to FPK
    InvulnerableShieldFX=ParticleSystem'ZED_Fleshpound_King_EMIT.FX_King_Fleshpound_Shield'
    ShieldSocketName=Hips

    // Shield colors
    ShieldColorGreen=(R=50,G=255,B=50)
    ShieldCoreColorGreen=(R=0,G=255,B=0)
    ShieldColorYellow=(R=255,G=255,B=20)
    ShieldCoreColorYellow=(R=255,G=255,B=0)
    ShieldColorOrange=(R=255,G=110,B=10)
    ShieldCoreColorOrange=(R=255,G=105,B=0)
    ShieldColorRed=(R=255,G=20,B=20)
    ShieldCoreColorRed=(R=255,G=10,B=10)

    // Shield shatter explosion template
    Begin Object Class=KFGameExplosion Name=ShatterExploTemplate0
        Damage=30
        DamageRadius=500
        DamageFalloffExponent=1.f
        DamageDelay=0.f

        // Damage Effects
        KnockDownStrength=0
        KnockDownRadius=0
        FractureMeshRadius=500.0
        FracturePartVel=500.0
        ExplosionEffects=KFImpactEffectInfo'ZED_Fleshpound_King_EMIT.King_Pound_Shield_Explosion'
        ExplosionSound=AkEvent'WW_ZED_Hans.Play_Hans_Shield_Break'

        // Camera Shake
        CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
        CamShakeInnerRadius=450
        CamShakeOuterRadius=900
        CamShakeFalloff=0.5f
        bOrientCameraShakeTowardsEpicenter=true
        bUseOverlapCheck=false
    End Object
    ShieldShatterExplosionTemplate=ShatterExploTemplate0


}	