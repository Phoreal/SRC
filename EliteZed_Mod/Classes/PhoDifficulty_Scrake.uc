class PhoDifficulty_Scrake extends KFMonsterDifficultyInfo
	abstract;

defaultproperties
{
	// Normal difficulty
	Normal={(HealthMod=0.850000,
		HeadHealthMod=0.850000,
		SprintChance=1.000000,
		DamagedSprintChance=1.000000,
		DamageMod=0.425000, 
		SoloDamageMod=0.425000, //0.5
		BlockSettings={(Chance=0.05, Duration=1.25, MaxBlocks=3, Cooldown=5.0, DamagedHealthPctToTrigger=0.05,
							MeleeDamageModifier=0.9, DamageModifier=0.9, AfflictionModifier=0.2, SoloChanceMultiplier=0.1)},
		RallySettings={(bCanRally=false)}
	)}

	// Hard difficulty
	Hard={(SprintChance=1.000000,
		DamagedSprintChance=1.000000,
		DamageMod=0.700000,
		SoloDamageMod=0.500000,
		BlockSettings={(Chance=0.1, Duration=1.25, MaxBlocks=4, Cooldown=5.0, DamagedHealthPctToTrigger=0.05,
							MeleeDamageModifier=0.9, DamageModifier=0.9, AfflictionModifier=0.2, SoloChanceMultiplier=0.1)},
		RallySettings={(bCanRally=false)}
	)}

	// Suicidal difficulty
	Suicidal={(HealthMod=1.10000, //1.1
		HeadHealthMod=1.050000,
		SprintChance=1.000000,
		DamagedSprintChance=1.000000,
		SoloDamageMod=0.500000,
		BlockSettings={(Chance=0.4, Duration=1.25, MaxBlocks=5, Cooldown=5.0, DamagedHealthPctToTrigger=0.05,
							MeleeDamageModifier=0.9, DamageModifier=0.9, AfflictionModifier=0.2, SoloChanceMultiplier=0.2)}, //0.2
		RallySettings={(DealtDamageModifier=1.2, TakenDamageModifier=0.9)}
	)}

	// Hell On Earth difficulty
	HellOnEarth={(HealthMod=1.100000,
		HeadHealthMod=1.100000,
		SprintChance=1.000000,
		DamagedSprintChance=1.000000,
		DamageMod=1.25,  //1.5
		SoloDamageMod=0.650000,
		BlockSettings={(Chance=4.0, Duration=5.0, MaxBlocks=6, Cooldown=2.5, DamagedHealthPctToTrigger=0.05,
							MeleeDamageModifier=0.9, DamageModifier=1.0, AfflictionModifier=1.0, SoloChanceMultiplier=0.3)}, //0.3
		RallySettings={(bCauseSprint=true, DealtDamageModifier=1.2, TakenDamageModifier=0.9)}
	)}

	// Body and head health scale by number of players
	NumPlayersScale_BodyHealth=0.3900000 //0.5 //0.25
	NumPlayersScale_HeadHealth=0.2800000 //0.3 //0.15

	// Versus Block settings
	BlockSettings_Versus={()}
	BlockSettings_Player_Versus={(DamageModifier=0.25, MeleeDamageModifier=0.25)}

	// Versus Rally settings
	RallySettings_Versus={()}
	RallySettings_Player_Versus={(DealtDamageModifier=1.2)}
}