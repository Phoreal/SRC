class PhoMutator extends KFMutator

	config(RGplay);

	/* Init Config */
		var config bool bIWontInitThisConfig;
	/* Mode Select */
		var config bool bEnableMode_PowerZeds;
	/* PhoPawn */
		var config byte PhoPawn_SpawnRate_Bloat;
		var config byte PhoPawn_SpawnRate_Husk;
		var config byte PhoPawn_SpawnRate_Stalker;
		var config byte PhoPawn_SpawnRate_Siren;
		var config byte PhoPawn_SpawnRate_Fleshpound;
		var config byte PhoPawn_SpawnRate_Crawler;
		var config byte PhoPawn_SpawnRate_Scrake;
		var config byte PhoPawn_Spawnrate_EliteGorefast;
		var config byte PhoPawn_Spawnrate_EliteSlasher;
	/* */


	
	/* RGPlay::Global */
		var byte OldWaveNum;
		const Time_BeginWaveInterval = 5.0f; 
		var float Time_WaitForSpawn;
	/* PhoPawn */
		Struct PowerZedsSpawn {
			var byte SpawnRate;
			var class<KFPawn_Monster> NormalClass;
			var class<KFPawn_Monster> PowerClass;
		};
		var array<PowerZedsSpawn> PZS;
		var float TimeNextSpawn;
	/* */



	function InitConfigVar() {
		/* Init Config */
			bIWontInitThisConfig = true;
		/* Mode Select */
			bEnableMode_PowerZeds = true;
		/* PhoPawn */
			PhoPawn_SpawnRate_Bloat = 40;
			PhoPawn_SpawnRate_Husk = 40;
			PhoPawn_SpawnRate_Stalker = 35;
			PhoPawn_SpawnRate_Siren = 40;
			PhoPawn_SpawnRate_Fleshpound = 15;
			PhoPawn_SpawnRate_Crawler = 0;
			PhoPawn_SpawnRate_Scrake = 15;
			PhoPawn_Spawnrate_EliteGorefast = 25;
			PhoPawn_Spawnrate_EliteSlasher = 35;
		/* */
	}



	function PostBeginPlay() {
		Super.PostBeginPlay();
		//ini config
			if (!bIWontInitThisConfig) InitConfigVar();
			SaveConfig();
		//PhoPawn
			if (bEnableMode_PowerZeds) PowerZeds_Init();
		//
	}
	
	function Tick( float DeltaTime ) {
		super.Tick(DeltaTime);
		RGPlay_Update();
	}


//<<---PhoMutator::Global--->>//
	
	
	function RGPlay_Update() {
		local array<class<KFPawn_Monster> > SpawnList;
		if (!MyKFGI.IsWaveActive()) return;
		if ( MyKFGI.MyKFGRI.WaveNum < MyKFGI.MyKFGRI.WaveMax ) {
			
				if (MyKFGI.MyKFGRI.WaveNum!=OldWaveNum) {
					
						Time_WaitForSpawn = WorldInfo.TimeSeconds+Time_BeginWaveInterval;
					
						MyKFGI.SpawnManager.TimeUntilNextSpawn += 0.05f;
					//
				}
			//PZmod用の処理
				if (`TimeSince(Time_WaitForSpawn)>0) {
					if (RGPlay_ShouldAddAI()) {
						MyKFGI.SpawnManager.TimeUntilNextSpawn = 1000; 
						SpawnList = RGPlay_GetNextSpawnList();
						MyKFGI.NumAISpawnsQueued += MyKFGI.SpawnManager.SpawnSquad( SpawnList );
						
						if (bEnableMode_PowerZeds) PowerZeds_UpdateSpawnTimer();
					}
				}
			//
		}
		OldWaveNum = MyKFGI.MyKFGRI.WaveNum;
	}
	
	
	function array< class<KFPawn_Monster> > RGPlay_GetNextSpawnList() {
		if (bEnableMode_PowerZeds) return PowerZeds_GetNextSpawnList();
		return MyKFGI.SpawnManager.GetNextSpawnList();
	}
	
	
	function bool RGPlay_ShouldAddAI() {
		if ( (bEnableMode_PowerZeds)	&& (PowerZeds_ShouldAddAI())	) return true;
		return false;
	}
	
//<<---PhoPawn--->>//
	
	
	function PowerZeds_Init() {
		
			TimeNextSpawn = WorldInfo.TimeSeconds;
		
			PowerZeds_SetSpawnRate(PhoPawn_SpawnRate_Bloat			,class'KFPawn_ZedBloat'			,class'PhoPawn_ZedBloat'			);
			PowerZeds_SetSpawnRate(PhoPawn_SpawnRate_Husk			,class'KFPawn_ZedHusk'			,class'PhoPawn_ZedHusk'				);
			PowerZeds_SetSpawnRate(PhoPawn_SpawnRate_Stalker		,class'KFPawn_ZedStalker'		,class'PhoPawn_ZedStalker'			);
			PowerZeds_SetSpawnRate(PhoPawn_SpawnRate_Siren			,class'KFPawn_ZedSiren'			,class'PhoPawn_ZedSiren'			);
			PowerZeds_SetSpawnRate(PhoPawn_SpawnRate_Scrake			,class'KFPawn_ZedScrake'		,class'PhoPawn_ZedScrake'			);
			PowerZeds_SetSpawnRate(PhoPawn_SpawnRate_Fleshpound		,class'KFPawn_ZedFleshpound'	,class'PhoPawn_ZedFleshpound'		);
			PowerZeds_SetSpawnRate(PhoPawn_Spawnrate_EliteGorefast	,class'KFPawn_ZedGorefast'		,class'PhoPawn_ZedEliteGorefast'	);
			PowerZeds_SetSpawnRate(PhoPawn_Spawnrate_EliteSlasher	,class'KFPawn_ZedClot_Slasher'	,class'PhoPawn_ZedEliteSlasher'		);
		//
	}
	
	
	function PowerZeds_SetSpawnRate(byte SpawnRate,class<KFPawn_Monster> NormalClass,class<KFPawn_Monster> PowerClass) {
		local PowerZedsSpawn PZSbuf;
		if (SpawnRate==0) return;
		PZSbuf.SpawnRate = SpawnRate;
		PZSbuf.NormalClass = NormalClass;
		PZSbuf.PowerClass = PowerClass;
		PZS.AddItem(PZSbuf);
	}
	
	
	function PowerZeds_UpdateSpawnTimer() {
		TimeNextSpawn = WorldInfo.TimeSeconds + MyKFGI.SpawnManager.CalcNextGroupSpawnTime();
	}
		
	
	function array< class<KFPawn_Monster> > PowerZeds_GetNextSpawnList() {
		local array<class<KFPawn_Monster> > SpawnList;
		local int i;
		local PowerZedsSpawn PZSbuf;
	
			SpawnList = MyKFGI.SpawnManager.GetNextSpawnList();
		
		for (i=0;i<SpawnList.length;++i) {
/*
if (rand(2)==0) {
	SpawnList[i] = class'KFPawn_ZedScrake';
}else{
	SpawnList[i] = class'KFPawn_ZedFleshpound';
}
*/
				foreach PZS(PZSbuf) {
					if (IsSameClassBased(SpawnList[i],PZSbuf.NormalClass)) {
						
							if (Rand(100)<PZSbuf.SpawnRate) {
								SpawnList[i] = PZSbuf.PowerClass;
							}
						//
						break;
					}
				}
//SpawnList[i] = class'PowerZeds_KFP_Bloat';
//SpawnList[i] = class'PowerZeds_KFP_Siren';
//SpawnList[i] = class'PowerZeds_KFP_Husk';
				
			}
		//
		return SpawnList;
	}
	
	function bool IsSameClassBased (class<KFPawn_Monster> SpawnClass,class<KFPawn_Monster> PowerClass) {
		if (class<KFPawn_ZedScrake>(SpawnClass)!=None) {
			return ( class'KFPawn_ZedScrake' == PowerClass );
		}
		if (class<KFPawn_ZedFleshpound>(SpawnClass)!=None) {
			return ( class'KFPawn_ZedFleshpound' == PowerClass );
		}
		if (class<KFPawn_ZedCrawler>(SpawnClass)!=None) {
			return ( class'KFPawn_ZedCrawler' == PowerClass );
		}
		return ( SpawnClass == PowerClass ) ;
	}
	
	function bool PowerZeds_ShouldAddAI() {
		local KFAISpawnManager SM;
		SM = MyKFGI.SpawnManager;
		if( ( SM.LeftoverSpawnSquad.Length > 0 || `TimeSince(TimeNextSpawn) > 0 ) && !SM.IsFinishedSpawning() ) {
			return SM.GetNumAINeeded() > 0;
		}
		return false;
	}
