class PhoDifficulty_Bloat extends KFDifficulty_Bloat;

DefaultProperties
{
	// Hell On Earth difficulty
	HellOnEarth={(HealthMod=1.300000,
		HeadHealthMod=1.100000,
   		SprintChance=1.000000,
   		DamagedSprintChance=1.000000,
   		DamageMod=1.500000,
   		SoloDamageMod=0.75,
		BlockSettings={(Chance=0.85, Duration=1.25, MaxBlocks=6, Cooldown=3.5, DamagedHealthPctToTrigger=0.1,
							MeleeDamageModifier=0.9, DamageModifier=0.9, AfflictionModifier=0.2, SoloChanceMultiplier=0.2)},
		RallySettings={(bCauseSprint=true, DealtDamageModifier=1.5, TakenDamageModifier=0.5)}
	)}

}