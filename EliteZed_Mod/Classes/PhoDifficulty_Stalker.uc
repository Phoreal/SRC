class PhoDifficulty_Stalker extends KFDifficulty_Stalker;

DefaultProperties
{
	// Hell On Earth difficulty
	HellOnEarth={(SprintChance=1.00000,
		DamagedSprintChance=1.000000,
		MovementSpeedMod=1.4, //1.6
		EvadeOnDamageSettings={(Chance=1.0, DamagedHealthPctToTrigger=0.01)},
		RallySettings={(bCauseSprint=true, DealtDamageModifier=1.2, TakenDamageModifier=0.9)}
	)}
}