class PhoProj_BloatPukeMine extends KFProj_BloatPukeMine;

defaultproperties
{
	Health=100  //150

	LifeSpan=0
	FuseDuration=300
	PostExplosionLifetime=1
	Speed=1000 //500
	MaxSpeed=1000 //500
	Physics=PHYS_Falling
	bBounce=true
	bNetTemporary=false

	// Explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=18		
		DamageRadius=450
		DamageFalloffExponent=0.f
		DamageDelay=0.f
		MyDamageType=class'KFDT_Toxic_BloatPukeMine'
		//bIgnoreInstigator is set to true in PrepareExplosionTemplate

		// Damage Effects
		KnockDownStrength=0
		KnockDownRadius=0
		FractureMeshRadius=0
		FracturePartVel=0
		ExplosionEffects=KFImpactEffectInfo'ZED_Bloat_ARCH.Bloat_Mine_Explosion'
		ExplosionSound=AkEvent'WW_ZED_Bloat.Play_Bloat_Mine_Explode'
		MomentumTransferScale=0

        // Dynamic Light
        ExploLight=none

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
		CamShakeInnerRadius=200
		CamShakeOuterRadius=400
		CamShakeFalloff=1.f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0

	GlassShatterType=FMGS_ShatterAll
}