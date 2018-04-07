class PhoAIController_ZedHusk extends KFAIController_ZedHusk;

DefaultProperties
{
	// Fireball
	MinDistanceForFireBall=300
	MaxDistanceForFireBall=4500  //4000

	FireballRandomizedValue=0  //1

	SplashAimChanceNormal=0.25
	SplashAimChanceHard=0.35
	SplashAimChanceSuicidal=0.5
	SplashAimChanceHellOnEarth=0.75

	FireballSpeed=3600.f
	FireballAimError=0.03f
	FireballLeadTargetAimError=0.03f
	bDebugAimError=false
	bCanLeadTarget=true

	// FlameThrower
	TimeBetweenFlameThrower=0.5
	MaxDistanceForFlameThrower=550  //500
	LowIntensityAttackScaleOfFireballInterval=1.25

	// Suicide
	MinDistanceToSuicide=300  //280
	RequiredHealthPercentForSuicide=0.45f  //0.15
}