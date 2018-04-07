class PhoPawn_ZedStalker extends KFPawn_ZedStalker_Versus;

function PlayHit( float Damage, Controller InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, TraceHitInfo HitInfo )
{
 	super.PlayHit( Damage, InstigatedBy, HitLocation, damageType, Momentum, HitInfo );

	SetCloaked( false );

	// SetTimer times are max values pulled from KFPawnAnimInfo::PlayHitReactionAnim

	// if last hit caused call to DoPauseAI
	if( HitFxInfo.DamageType != none && HitFxInfo.DamageType.default.MeleeHitPower > 0 )
	{
		SetTimer( 0.001f, false, nameof(ReCloakTimer) );
	}
	else // light hit or DOT
	{
		SetTimer( 0.001f, false, nameof(ReCloakTimer) );
	}
}

function CauseHeadTrauma( float BleedOutTime=5.f )
{
	Super.CauseHeadTrauma( BleedOutTime );

	if( bIsHeadless && IsAliveAndWell() && !IsDoingSpecialMove() )
	{
		SetCloaked( true );
	}
}

/*********************************************************************************************
`* Perk related
********************************************************************************************* */

/**
 * Called every 0.5f seconds to check if a cloaked zed has been spotted
 * Network: All but dedicated server
 */
simulated event UpdateSpottedStatus()
{
	local bool bOldSpottedByLP;
	local KFPerk LocalPerk;
	local float DistanceSq, Range;

	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	bOldSpottedByLP = bIsCloakingSpottedByLP;
	bIsCloakingSpottedByLP = false;

    if( !IsHumanControlled() || bIsSprinting )
    {
    	if( ViewerPlayer == none )
    	{
    		ViewerPlayer = KFPlayerController( GetALocalPlayerController() );
		}

		if( ViewerPlayer != none )
		{
			LocalPerk = ViewerPlayer.GetPerk();
		}

		if ( ViewerPlayer != none && ViewerPlayer.Pawn != None && ViewerPlayer.Pawn.IsAliveAndWell() && LocalPerk != none &&
			 LocalPerk.bCanSeeCloakedZeds && `TimeSince( LastRenderTime ) < 1.f )
		{
			DistanceSq = VSizeSq(ViewerPlayer.Pawn.Location - Location);
			Range = LocalPerk.GetCloakDetectionRange();

			if ( DistanceSq < Square(Range) )
			{
				bIsCloakingSpottedByLP = true;
				if ( LocalPerk.IsCallOutActive() )
				{
					// Beware of server spam.  This RPC is marked unreliable and UpdateSpottedStatus has it's own cooldown timer
					ViewerPlayer.ServerCallOutPawnCloaking(self);
				}
			}
		}
	}
	
	// If spotted by team already, there is no point in trying to update the MIC here
	if ( !bIsCloakingSpottedByTeam )
	{
		if ( bIsCloakingSpottedByLP != bOldSpottedByLP )
		{
			UpdateGameplayMICParams();
		}
	}
}

/** notification from player with CallOut ability */
function CallOutCloaking( optional KFPlayerController CallOutController )
{
	bIsCloakingSpottedByTeam = true;
	LastStoredCC = CallOutController;
	UpdateGameplayMICParams();
	SetTimer(2.f, false, nameof(CallOutCloakingExpired));
}

/** Call-out cloaking ability has timed out */
function CallOutCloakingExpired()
{
	bIsCloakingSpottedByTeam = false;
	LastStoredCC = none;
	UpdateGameplayMICParams();
}

/** Applies the rally buff and spawns a rally effect */
simulated function bool Rally(
							KFPawn 			RallyInstigator,
							ParticleSystem 	RallyEffect,
							name 			EffectBoneName,
							vector			EffectOffset,
							ParticleSystem	AltRallyEffect,
							name 			AltEffectBoneNames[2],
							vector 			AltEffectOffset,
							optional bool	bSkipEffects=false
						)
{
	local PlayerController PC;

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		PC = WorldInfo.GetALocalPlayerController();

		// Don't spawn rally effects if cloaking but not spotted
		if( bIsCloaking
			&& !bIsCloakingSpottedByLP
			&& !bIsCloakingSpottedByTeam
			&& PC.GetTeamNum() < 255
			&& PC.Pawn != none
			&& PC.Pawn.IsAliveAndWell() )
		{
			bSkipEffects = true;
		}
	}

	return super.Rally( RallyInstigator, RallyEffect, EffectBoneName, EffectOffset, AltRallyEffect, AltEffectBoneNames, AltEffectOffset, bSkipEffects );
}

/* PlayDying() is called on server/standalone game when killed
and also on net client when pawn gets bTearOff set to true (and bPlayedDeath is false)
*/
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	// Uncloak on death
	SetCloaked(false);
	bCanCloak = false;

	Super.PlayDying(DamageType, HitLoc);
}

/** Interrupt certain moves when bEmpDisrupted is set */
function OnStackingAfflictionChanged(byte Id)
{
	Super.OnStackingAfflictionChanged(Id);

	if( Role == ROLE_Authority && IsAliveAndWell() )
	{
		if ( Id == AF_EMP )
		{
			SetCloaked( !bEMPPanicked && !bEMPDisrupted );
		}
	}
}

simulated function PlayHeadAsplode()
{
	if( bIsCloaking )
	{
		SetCloaked( false );
	}

	bCanCloak = false;

	super.PlayHeadAsplode();
}

simulated function ReCloakTimer()
{
	SetCloaked( true );
}

static function bool IsStalkerPawn()
{
	return true;
}

/** Returns (hardcoded) dialog event ID for when players kills this zed type */
function int GetKillerDialogID()
{
	return 66;//KILL_Female
}

/** Returns (hardcoded) dialog event ID for when players spots this zed type */
function int GetSpotterDialogID()
{
	if( bIsCloaking && MaxHeadChunkGoreWhileAlive == 0 )
    {
        return 135;//SPOTZ_Cloaked
    }

	return 125;//SPOTZ_Generic
}

/** Returns (hardcoded) dialog event ID for when trader gives advice to player who was killed by this zed type */
static function int GetTraderAdviceID()
{
	return 40;//TRAD_AdviceStalker
}

defaultproperties
{
	Begin Object Name=MeleeHelper_0
		BaseDamage=11		//12
		MaxHitRange=180.f
		MomentumTransfer=25000.f
		MyDamageType=class'KFDT_Slashing_ZedWeak'
		MeleeImpactCamScale=0.2
		PlayerDoorDamageMultiplier=5.f
	End Object
	MeleeAttackHelper=MeleeHelper_0

	bCanGrabAttack=true

	PenetrationResistance=1.0
	ParryResistance=2

	DifficultySettings=class'PhoDifficulty_Stalker'
	ControllerClass=class'PhoAIController_ZedStalker'


	Health=150 
    // Override Head GoreHealth (aka HeadHealth)
    HitZones[HZI_HEAD]=(ZoneName=head, BoneName=Head, Limb=BP_Head, GoreHealth=40, DmgScale=1.001, SkinID=1) // default is 20  GoreHealth=75

	DoshValue=18

	// for reference: Vulnerability=(default, head, legs, arms, special)
	IncapSettings(AF_Stun)=		(Vulnerability=(0.5, 0.5, 0.1, 0.1, 0.1), Cooldown=5.0, Duration=3.0)
	IncapSettings(AF_Knockdown)=(Vulnerability=(0.2),                     Cooldown=1.0)
	IncapSettings(AF_Stumble)=	(Vulnerability=(0.1),                     Cooldown=0.5)
	IncapSettings(AF_GunHit)=	(Vulnerability=(0.0, 0.0, 0.0, 0.0, 0.0), Cooldown=0.0)
	IncapSettings(AF_MeleeHit)=	(Vulnerability=(0.0),                     Cooldown=0.0)
	IncapSettings(AF_FirePanic)=(Vulnerability=(0.5),                       Cooldown=3.0,  Duration=4.0)
	IncapSettings(AF_EMP)=		(Vulnerability=(1.0),                     Cooldown=5.0,  Duration=5.0)
	IncapSettings(AF_Poison)=	(Vulnerability=(1.0),                    Cooldown=7.5,  Duration=5.5)
	IncapSettings(AF_Microwave)=(Vulnerability=(0.25),                     Cooldown=20.5, Duration=5.0)
	IncapSettings(AF_Freeze)=	(Vulnerability=(1.0),                     Cooldown=1.5,  Duration=4.0)
	IncapSettings(AF_Snare)=	(Vulnerability=(0.7, 0.7, 1.1, 0.7, 0.7),  Cooldown=5.5,  Duration=4.0)
    IncapSettings(AF_Bleed)=    (Vulnerability=(0.25))

    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Submachinegun', 	DamageScale=(0.9))) //0.8
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_AssaultRifle', 	DamageScale=(1.5))) //2.5
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Shotgun', 	        DamageScale=(1.0)))  //0.7
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Handgun', 	        DamageScale=(1.0)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Ballistic_Rifle', 	        DamageScale=(0.85)))  //0.6
    DamageTypeModifiers.Add((DamageType=class'KFDT_Slashing', 	                DamageScale=(1.0)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Bludgeon', 	                DamageScale=(1.0)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Fire', 	                    DamageScale=(0.85))) //0.6
	DamageTypeModifiers.Add((DamageType=class'KFDT_Microwave', 	                DamageScale=(0.2)))
	DamageTypeModifiers.Add((DamageType=class'KFDT_Explosive',            	    DamageScale=(0.75))) //0.6
	DamageTypeModifiers.Add((DamageType=class'KFDT_Piercing', 	                DamageScale=(1.0)))
    DamageTypeModifiers.Add((DamageType=class'KFDT_Toxic', 	                    DamageScale=(1.0)))

    // Really fast sprint
    SprintSpeed=700  
    SprintStrafeSpeed=425.f
    GroundSpeed=500  
    JumpZ=1100

	// Cloaking
	bIsCloaking=true
	bCanCloak=true
	bCloakOnMeleeEnd=true
	CloakPercent=1.0f
	DeCloakSpeed=4.5f
	CloakSpeed=50f
	//CloakDuration=1.2

}