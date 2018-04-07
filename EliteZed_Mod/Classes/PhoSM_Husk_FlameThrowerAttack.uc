class PhoSM_Husk_FlameThrowerAttack extends KFSM_Husk_FlameThrowerAttack;


/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	if ( bCanBeInterrupted && (NewMove == 'KFSM_Stunned' || NewMove == 'KFSM_Stumble' || NewMove == 'KFSM_Knockdown' || NewMove == 'KFSM_Frozen') )
	{
		return TRUE; // for NotifyAttackParried
	}
	return FALSE;
}

DefaultProperties
{
	// SpecialMove
	Handle=PhoSM_Husk_FlameThrowerAttack
	bDisableSteering=false
	bDisableMovement=false
	bDisableTurnInPlace=true
   	bCanBeInterrupted=false
   	bUseCustomRotationRate=true
   	CustomRotationRate=(Pitch=66000,Yaw=100000,Roll=66000)
   	CustomTurnInPlaceAnimRate=2.f

}
