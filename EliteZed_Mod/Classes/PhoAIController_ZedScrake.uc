class PhoAIController_ZedScrake extends KFAIController_ZedScrake;

DefaultProperties
{
	// ---------------------------------------------
    // Danger Evasion Settings
    DangerEvadeSettings.Empty

    //Aim Blocks
    DangerEvadeSettings(0)={(ClassName="KFWeap_Rifle_Winchester1894",
                                Cooldowns=(0.5, 0.4, 0.3, 0.2), // Normal, Hard, Suicidal, HoE
                                BlockChances=(0.1, 0.2, 0.7, 1.0))}
    DangerEvadeSettings(1)={(ClassName="KFWeap_Bow_Crossbow",
                                Cooldowns=(0.5, 0.4, 0.3, 0.2), // Normal, Hard, Suicidal, HoE
                                BlockChances=(0.1, 0.2, 0.7, 1.0))}
    DangerEvadeSettings(2)={(ClassName="KFWeap_Rifle_M14EBR",
                                Cooldowns=(0.5, 0.4, 0.3, 0.2), // Normal, Hard, Suicidal, HoE
                                BlockChances=(0.1, 0.2, 0.7, 1.0))}
    DangerEvadeSettings(3)={(ClassName="KFWeap_Rifle_RailGun",
                                Cooldowns=(0.5, 0.4, 0.3, 0.2), // Normal, Hard, Suicidal, HoE
                                BlockChances=(0.1, 0.2, 0.7, 4.0))}
}
