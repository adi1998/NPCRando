local icarusEncounters = {
    F = {
        IcarusCombatF = {
            InheritFrom = { "BaseIcarusCombat", "GeneratedF" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
            GameStateRequirements = {
                Append = true,
                {
                    Path = { "CurrentRun", "EncountersOccurredCache" },
                    HasNone = {"IcarusCombatF", "IcarusCombatG", "IcarusCombatH", "IcarusCombatI", "IcarusCombatO", "IcarusCombatO2", "IcarusCombatIntro",
                                    "IcarusCombatP", "IcarusCombatP2"}
                },
            }
        },
    },

    G = {
        IcarusCombatG = {
            InheritFrom = { "BaseIcarusCombat", "GeneratedG" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
            GameStateRequirements = {
                Append = true,
                {
                    Path = { "CurrentRun", "EncountersOccurredCache" },
                    HasNone = {"IcarusCombatF", "IcarusCombatG", "IcarusCombatH", "IcarusCombatI", "IcarusCombatO", "IcarusCombatO2", "IcarusCombatIntro",
                                    "IcarusCombatP", "IcarusCombatP2"}
                },
            }
        },
    },

    H = {
        IcarusCombatH = {
            InheritFrom = { "BaseIcarusCombat", "GeneratedH" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
            ForceEncounterStart = false,
            UnthreadedEvents = {
                {
                    FunctionName = "GenericPresentation",
                    Args =
                    {
                        LoadVoiceBanks = { "Icarus" },
                        LoadPackages = { "Icarus" },
                        IgnoreAssert = true,
                    },
                },
                { FunctionName = "BeginIcarusEncounter" },
                { FunctionName = "HandleEnemySpawns" },
                { FunctionName = "CheckForAllEnemiesDead" },
                { FunctionName = "PostCombatAudio" },
                -- { FunctionName = "SpawnRoomReward" },
                { FunctionName = _PLUGIN.guid .. "." .. "SetIcarusPostCombatAI" },
            },
            WaveStartUnthreadedEvents =
            {
                { FunctionName = _PLUGIN.guid .. "." .. "CheckIcarusSpawn", Args = { FirstWaveIcarusChance = 0.0, WaveSpawnDelay = 1.8 } },
            },
            GameStateRequirements =
            {
                {
                    PathFalse = { "CurrentRun", "UseRecord", "NPC_Icarus_01" },
                },
                {
                    Path = { "CurrentRun", "BiomeDepthCache" },
                    Comparison = ">=",
                    Value = 1,
                },
                {
                    Path = { "GameState", "BiomeVisits", "O" },
                    Comparison = ">",
                    Value = 1,
                },
                {
                    Path = { "CurrentRun", "EncountersOccurredCache" },
                    HasNone = {"IcarusCombatF", "IcarusCombatG", "IcarusCombatH", "IcarusCombatI", "IcarusCombatO", "IcarusCombatO2", "IcarusCombatIntro",
                                    "IcarusCombatP", "IcarusCombatP2"}
                },
                NamedRequirements = { "NoRecentFieldNPCEncounter" },
                NamedRequirementsFalse = { "StandardPackageBountyActive" },
            },
        },
    },

    I = {
        IcarusCombatI = {
            InheritFrom = { "BaseIcarusCombat", "GeneratedI" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
            GameStateRequirements = {
                Append = true,
                {
                    Path = { "CurrentRun", "EncountersOccurredCache" },
                    HasNone = {"IcarusCombatF", "IcarusCombatG", "IcarusCombatH", "IcarusCombatI", "IcarusCombatO", "IcarusCombatO2", "IcarusCombatIntro",
                                    "IcarusCombatP", "IcarusCombatP2"}
                },
            }
        },
    },
}

-- game.OverwriteTableKeys(game.EncounterData, icarusEncounters)

local weight = 3

for roomSet, encounterTable in pairs(icarusEncounters) do
    for _, roomName in ipairs(mod.RoomSets[roomSet]) do
        local roomData = game.RoomData[roomName]
        for encounterName, encounterData in pairs(encounterTable) do
            game.EncounterData[encounterName] = encounterData
            for i = 1, weight do
                if roomSet ~= "H" then
                    table.insert(roomData.LegalEncounters, encounterName)
                else
                    table.insert(game.ObstacleData.FieldsRewardCage.LegalEncounters, encounterName)
                end
            end
            table.insert(game.NamedRequirementsData.NoRecentFieldNPCEncounter[1].TableValuesToCount, encounterName)
        end
    end
end

function mod.CheckIcarusSpawn(encounter, args)
	if encounter.IcarusId ~= nil then
		return
	end

	args = args or {}

	if encounter.WaveCount == 1 or encounter.CurrentWaveNum > 1 or game.RandomChance(args.FirstWaveIcarusChance or 0.1) then
		mod.HandleIcarusSpawn( encounter, args )
	end
end

function mod.HandleIcarusSpawn( eventSource, args )
	local currentRun = game.CurrentRun
	local currentRoom = game.CurrentRun.CurrentRoom
	local currentEncounter = eventSource

	local newUnit = DeepCopyTable( EnemyData.NPC_Icarus_01 )
	local variantData = NPCVariantData.IcarusCombat
	OverwriteSelf( newUnit, variantData )

	local spawnPointId = GetRandomValue( GetIdsByType({ Name = "CameraClamp" }) ) -- GetIds({ Name = "IcarusSpawnPoints" }) or
	spawnPointId = spawnPointId or currentRun.Hero.ObjectId
	newUnit.ObjectId = SpawnUnit({ Name = "NPC_Icarus_01", Group = "Standing", DestinationId = spawnPointId })

	SetAlpha({ Id = newUnit.ObjectId, Fraction = 0, Duration = 0 })

	currentEncounter.IcarusId = newUnit.ObjectId
	SetupUnit( newUnit, CurrentRun, { IgnoreAI = true, IgnorePackages = true } )
	UseableOff({ Id = newUnit.ObjectId })
	MapState.RoomRequiredObjects[newUnit.ObjectId] = newUnit
    currentEncounter[_PLUGIN.guid .. "FieldUnit"] = newUnit
	thread( IcarusPreSpawnPresentation, newUnit, eventSource )

	thread(SetupAI, newUnit )

	wait(args.WaveSpawnDelay, currentEncounter.SpawnThreadName)
end

function mod.IcarusPostCombat( enemy )
	enemy.PostCombatTravel = true
	local moveToId = CurrentRun.Hero.ObjectId

	Stop({ Id = enemy.ObjectId })
	wait(0.05, enemy.AIThreadName)
	Teleport({ Id = enemy.ObjectId, DestinationId = moveToId })
	wait(0.05, enemy.AIThreadName)

	--[[ check for first presentation
	local requirements =
	{
		{
			PathTrue = { "GameState", "TextLinesRecord", "ArtemisFirstMeeting" },
		},
	}
	
	if IsGameStateEligible( requirements ) then		
		thread( DirectionHintPresentation, enemy )
		ArtemisAppearancePresentation( enemy )
	else
		ArtemisFirstAppearancePresentation( enemy )
	end]]
	thread( DirectionHintPresentation, enemy )
	IcarusAppearancePresentation( enemy )

	CheckAvailableTextLines( enemy )
	UseableOn({ Id = enemy.ObjectId })

	enemy.AINotifyName = "WithinDistance_"..enemy.Name.."_"..enemy.ObjectId
	NotifyWithinDistance({ Id = enemy.ObjectId, DestinationId = CurrentRun.Hero.ObjectId, Distance = 400, Notify = enemy.AINotifyName, Timeout = 10.0 })
	waitUntil( enemy.AINotifyName, enemy.AIThreadName )
	enemy.PostCombatTravel = false
end

function mod.SetIcarusPostCombatAI(eventSource)
    local currentEncounter = eventSource
    print("SetIcarusPostCombatAI", mod.dump(eventSource))
    if currentEncounter[_PLUGIN.guid .. "FieldUnit"] then
        local enemy = currentEncounter[_PLUGIN.guid .. "FieldUnit"]
        enemy.AIDisabled = true
        print("disabled AI", enemy.Name)
        -- game.wait(0.01)
        if enemy.PostCombatAI then
            print("forcing PostCombatAI", _PLUGIN.guid .. "." .. "IcarusPostCombat")
            game.SetAI( _PLUGIN.guid .. "." .. "IcarusPostCombat", enemy )
        end
    end
end