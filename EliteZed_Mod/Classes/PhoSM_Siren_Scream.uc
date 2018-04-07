class PhoSM_Siren_Scream extends KFSM_Siren_Scream;


DefaultProperties
{
	// SpecialMove
	ProjectileShieldLifetime=2.2 // 0.52

	AnimName=Atk_Combo1_V1
	Handle=PhoSM_Siren_Scream
	bDisableSteering=false
	bDisableMovement=false
   	AnimStance=EAS_UpperBody
   	bCanBeInterrupted=false

	ScreamDamage=18		//20
	ScreamDamageFrequency=0.5f //1.0
	ScreamInterruptSound=AkEvent'WW_ZED_Siren.Stop_Siren_Scream'

   	bDrawProjectileShield=false
	bDrawWaveRadius=false

	ExplosionActorClass=class'KFExplosion_SirenScream'

	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		//Damage=15	@NOTE: This is now set using the ScreamDamage variable -MattF
		DamageRadius=800 //800
		DamageFalloffExponent=1f
		DamageDelay=0.f

		MomentumTransferScale=0
		
		ActorClassToIgnoreForDamage=class'KFPawn_Monster'

		// Damage Effects
		MyDamageType=class'KFDT_Sonic'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=none
		ExplosionSound=none

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.SirenScream'
		CamShakeInnerRadius=450
		CamShakeOuterRadius=900
		CamShakeFalloff=1.f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0
}