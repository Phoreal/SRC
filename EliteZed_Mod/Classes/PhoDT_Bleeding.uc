class PhoDT_Bleeding extends KFDT_Bleeding
	abstract
	hidedropdown;

defaultproperties
{	
	DoT_Type=DOT_Bleeding
	DoT_Duration=15.0
	DoT_Interval=1.0
	DoT_DamageScale=0.1

	KDamageImpulse=400
	KDeathUpKick=200
	KDeathVel=750
	bExtraMomentumZ=true

	bStackDoT=true

	CameraLensEffectTemplate=class'PhoCameraLensEmit_BloodBase'
}