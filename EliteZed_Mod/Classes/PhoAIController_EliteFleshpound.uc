class PhoAIController_EliteFleshpound extends KFAIController_ZedFleshpound;

const MaxPhases = 3;

/** Cached pawn reference */
var PowerZeds_KFP_Fleshpound MyPawn;

/** Current battle phase, 0 = start, indexes into PhaseThresholds*/
var int CurrentPhase;

/** Health percentage cutoffs for the current fight phase */
var const float PhaseThresholds[MaxPhases];

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    MyPawn = PowerZeds_KFP_Fleshpound(inPawn);
}

function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
    local float CurrentHealth;
    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, damageType, Momentum);

    //Can still transition
    if (MyPawn != none && CurrentPhase + 1 < MaxPhases)
    { 
        CurrentHealth = float(MyPawn.Health) / float(MyPawn.HealthMax);
        if (CurrentHealth < PhaseThresholds[CurrentPhase + 1])
        {
            TransitionToPhase(CurrentPhase + 1);
        }
    }
}

/** Handle any updates caused by a phase transition */
function TransitionToPhase(int NewPhase)
{
    CurrentPhase = NewPhase;
    MyPawn.CurrentPhase = NewPhase;

    switch (NewPhase)
    {
    case 1:
        MyPawn.ActivateShield();
        break;
    }
}


function NotifySpecialMoveEnded( KFSpecialMove SM )
{
    super.NotifySpecialMoveEnded( SM );

    if (SM.Handle == 'KFSM_Zed_Taunt')
    {
        TransitionToPhase(0);
    }
}

DefaultProperties
{
    PhaseThresholds[0]=1
    PhaseThresholds[1]=0.75
    PhaseThresholds[2]=0.5
}