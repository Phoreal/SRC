class PhoProj_Husk_Fireball extends KFProj_Husk_Fireball;

DefaultProperties
{
	Speed=1800
	MaxSpeed=1800

	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=30  //25
		DamageRadius=300
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Fire_HuskFireball'
		MomentumTransferScale=65000.f  //60000
		KnockDownStrength=100
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.HuskProjectile_Explosion'
		ExplosionSound=AkEvent'WW_ZED_Husk.ZED_Husk_SFX_Ranged_Shot_Impact'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.5

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.HuskFireball'
		CamShakeInnerRadius=450
		CamShakeOuterRadius=900
		CamShakeFalloff=1.f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0

	// Ground fire
	BurnDuration=4.f  
	BurnDamageInterval=0.25f
	GroundFireExplosionActorClass=class'KFExplosion_HuskFireballGroundFire'

	Begin Object Class=KFGameExplosion Name=ExploTemplate1
		Damage=3
		DamageRadius=200  //150
		DamageFalloffExponent=1.f
		DamageDelay=0.f
		// Don't burn the guy that tossed it, it's just too much damage with multiple fires, its almost guaranteed to kill the guy that tossed it
        bIgnoreInstigator=true

		MomentumTransferScale=0

		// Damage Effects
		MyDamageType=class'KFDT_Fire_ZedGround'
		KnockDownStrength=0
		FractureMeshRadius=0
		ExplosionEffects=KFImpactEffectInfo'wep_molotov_arch.Molotov_GroundFire'

		bDirectionalExplosion=true

		// Camera Shake
		CamShake=none

		// Dynamic Light
        ExploLight=FlamePointLight
        ExploLightStartFadeOutTime=1.5f
        ExploLightFadeOutTime=0.3
	End Object
	GroundFireExplosionTemplate=ExploTemplate1
}
