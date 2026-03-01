function mod.HandleHeraclesSpawn( eventSource )
	local currentRun = game.CurrentRun
	local currentRoom = game.CurrentRun.CurrentRoom
	local currentEncounter = eventSource

	local newUnit = game.DeepCopyTable( game.EnemyData.NPC_Heracles_01 )
	local dummyEncounter = { SpawnNearId = currentRun.Hero.ObjectId, SpawnRadius = 900, }
	local spawnPointId = SelectSpawnPoint( currentRoom, newUnit, dummyEncounter, { RequireMinEndPointDistance = 400 } )
	spawnPointId = spawnPointId or currentRun.Hero.ObjectId
	newUnit.ObjectId = game.SpawnUnit({ Name = "NPC_Heracles_01", Group = "Standing", DestinationId = spawnPointId })
	newUnit.UseActivatePresentation = false
	newUnit.OccupyingSpawnPointId = spawnPointId
	
	game.AdjustZLocation({ Id = newUnit.ObjectId, Distance = 2500 })
	game.IgnoreGravity({ Id = newUnit.ObjectId })

	currentEncounter.HeraclesId = newUnit.ObjectId
	game.SetupUnit( newUnit, game.CurrentRun, { IgnoreAI = true, } )
	game.UseableOff({ Id = newUnit.ObjectId })
	game.MapState.RoomRequiredObjects[newUnit.ObjectId] = newUnit
	newUnit.TextLinesUseWeaponIdle = true
    newUnit.PostCombatAI = _PLUGIN.guid .. "." .. "HeraclesPostCombat"
	
	currentEncounter.StartPlayerMoney = GameState.Resources.Money

	-- dummy enemy
	local dummyName = game.GetRandomValue(game.EncounterData[currentEncounter.Name].HeraclesDummyUnitSet)
	local dummyTarget = game.DeepCopyTable( game.EnemyData[dummyName] )
	local setupArgs = {}
	setupArgs.SkipAISetup = true
	dummyTarget.UseActivatePresentation = false
	dummyTarget.RequiredKill = false
	dummyTarget.MoneyDropOnDeath = nil
	dummyTarget.IgnoreCurseDamage = true
	dummyTarget.ObjectId = game.SpawnUnit({ Name = dummyName, Group = "Standing", DestinationId = spawnPointId })
	game.thread(game.SetupUnit, dummyTarget, game.CurrentRun, setupArgs )
	currentEncounter.DummyTargetId = dummyTarget.ObjectId

	print("currentEncounter HandleHeraclesSpawn", mod.dump(currentEncounter))

	if not game.EncounterData[currentEncounter.Name].SkipHeraclesSpawnPresentation then
		mod.HeraclesSpawnPresentation( newUnit, dummyTarget, currentEncounter )
	end
end

function mod.HeraclesSpawnPresentation( heracles, dummyTarget, currentEncounter )
    
	HideCombatUI("HeraclesIntro")
    currentEncounter[_PLUGIN.guid .. "FieldUnit"] = heracles
	local encounter = currentEncounter
	print("CurrentRoom.Encounter", mod.dump(encounter))
	-- local heracles = ActiveEnemies[encounter.HeraclesId]
	-- local dummyTarget = ActiveEnemies[encounter.DummyTargetId]

	-- before arrival

	local encounterData = game.EncounterData[encounter.Name]
	local spawnWaitDuration = encounterData.HeraclesSpawnWait or 1.5
	print("dummy id", encounter.DummyTargetId)

	wait(spawnWaitDuration/2.5)
	AngleTowardTarget({ Id = dummyTarget.ObjectId, DestinationId = CurrentRun.Hero.ObjectId })
	thread( InCombatText, dummyTarget.ObjectId, "Alerted", 0.45, { OffsetY = dummyTarget.HealthBarOffsetY, SkipShadow = true }  )
	PlaySound({ Name = dummyTarget.IsAggroedSound or "/EmptyCue", Id = dummyTarget.ObjectId, ManagerCap = 28 })
	wait(spawnWaitDuration/2.5)

	local teleportId = nil
	if ActiveEnemies[dummyTarget.ObjectId] == nil then
		teleportId = SelectSpawnPoint(CurrentRun.CurrentRoom, heracles, { SpawnNearId = CurrentRun.Hero.ObjectId, SpawnRadius = 500, SpawnRadiusMin = 100 })
	else
		teleportId = dummyTarget.ObjectId
	end

	SetPlayerInvulnerable( "HeraclesSpawnPresentation" )

	Teleport({ Id = heracles.ObjectId, DestinationId = teleportId })
	SetAnimation({ DestinationId = heracles.ObjectId, Name = "Heracles_Combat_Taunt" })

	ObeyGravity({ Id = heracles.ObjectId })
	ApplyUpwardForce({ Id = heracles.ObjectId, Speed = -3500 })

	PlaySound({ Name = "/SFX/Enemy Sounds/Heracles/EmotePowerCharging", Id = heracles.ObjectId })

	BloomRequestStart({ SourceName = "HeraclesSpawnPresentation", BloomType = "BlurryLight", Duration = 0.5 })

	Rumble({ Duration = 0.3, RightFraction = 0.17 })

	AdjustRadialBlurDistance({ Fraction = 1.5, Duration = 0.35 })
	AdjustRadialBlurStrength({ Fraction = 1.5, Duration = 0.35 })

	wait( 0.5, RoomThreadName )

	SecretMusicPlayer( heracles.ThemeMusic )
	SetSoundCueValue({ Names = { "Section" }, Id = AudioState.SecretMusicId, Value = 0 })
	SetSoundCueValue({ Names = { "Keys" }, Id = AudioState.SecretMusicId, Value = 1 })
	SetSoundCueValue({ Names = { "Drums" }, Id = AudioState.SecretMusicId, Value = 1 })

	PlaySound({ Name = "/SFX/Enemy Sounds/Heracles/EmotePowerAttacking", Id = heracles.ObjectId })

	thread( DisplayDamageText, dummyTarget, { DamageAmount = 9999, SourceProjectile = "Heracles", IsCrit = true } )
	thread( Kill, dummyTarget)

	PlaySound({ Name = "/SFX/StabSplatterEndSequence", Id = heracles.ObjectId })
	PlaySound({ Name = "/SFX/Enemy Sounds/Polyphemus/PolyphemusGroundSlam", Id = heracles.ObjectId })
	CreateAnimation({ Name = "HydraTouchdownFx", DestinationId = heracles.ObjectId }) --nopkg

	AdjustRadialBlurDistance({ Fraction = 0, Duration = 1.5 })
	AdjustRadialBlurStrength({ Fraction = 1.5, Duration = 1.5 })
	BloomRequestEnd({ SourceName = "HeraclesSpawnPresentation", Duration = 1.5 })

	ShakeScreen({ Speed = 500, Distance = 4, FalloffSpeed = 1000, Duration = 1.5 })

	AddInputBlock({ Name = "HeraclesSpawnPresentation" })
	EndAutoSprint({ Halt = true, EndWeapon = true })
	SetPlayerInvulnerable( "HeraclesSpawnPresentation" )

	-- after arrival

	PanCamera({ Ids = heracles.ObjectId, Duration = 1.5, EaseIn = 0.05, EaseOut = 0.03 })
	PlaySound({ Name = "/Leftovers/World Sounds/MapZoomSlow" })
	PlaySound({ Name = "/Leftovers/SFX/GoalScoredNEW" })

	AngleTowardTarget({ Id = heracles.ObjectId, DestinationId = CurrentRun.Hero.ObjectId })

	wait( 0.3, RoomThreadName )

	AngleTowardTarget({ Id = CurrentRun.Hero.ObjectId, DestinationId = heracles.ObjectId })

	PlayVoiceLines( heracles.EntranceVoiceLines, nil, heracles )

	wait( 0.1, RoomThreadName )

	PanCamera({ Ids = heracles.ObjectId, Duration = 1.5, EaseIn = 0.05, EaseOut = 0.03 })
	PlaySound({ Name = "/Leftovers/World Sounds/MapZoomSlow" })

	wait( 0.5, RoomThreadName )

	ProcessTextLines( heracles, heracles.BossIntroTextLineSets )

	RemoveInputBlock({ Name = "HeraclesSpawnPresentation" })
	SetPlayerVulnerable( "HeraclesSpawnPresentation" )

	local textLines = GetRandomEligibleTextLines( heracles, heracles.BossIntroTextLineSets, GetNarrativeDataValue( heracles, "BossIntroTextLinePriorities" ) )
	PlayTextLines( heracles, textLines )

	SetSoundCueValue({ Names = { "Keys" }, Id = AudioState.SecretMusicId, Value = 1 })
	SetSoundCueValue({ Names = { "Drums" }, Id = AudioState.SecretMusicId, Value = 1 })

	ShowCombatUI("HeraclesIntro")

	LockCamera({ Id = CurrentRun.Hero.ObjectId, Duration = 1.25 })
	PlaySound({ Name = "/Leftovers/World Sounds/MapZoomSlow" })

	SetPlayerVulnerable( "HeraclesSpawnPresentation" )

	SetupAI(heracles )
end

function mod.SetUnitPostCombatAI(eventSource)
    local currentEncounter = eventSource
    print("SetUnitPostCombatAI", mod.dump(eventSource))
    if currentEncounter[_PLUGIN.guid .. "FieldUnit"] then
        local enemy = currentEncounter[_PLUGIN.guid .. "FieldUnit"]
        enemy.AIDisabled = true
        print("disabled AI", enemy.Name)
        -- game.wait(0.01)
        if enemy.PostCombatAI then
            print("forcing PostCombatAI", enemy.PostCombatAI)
            game.SetAI( enemy.PostCombatAI, enemy )
        end
    end
end

function mod.HeraclesPostCombat( enemy )
	enemy.PostCombatTravel = true
	AddTimerBlock( CurrentRun, "HeraclesPostCombat" )
	print("HeraclesPostCombat")
	local moveToId = SelectLootSpawnPoint(CurrentRun.CurrentRoom) or CurrentRun.Hero.ObjectId
	local distanceToTarget = GetDistance({ Id = enemy.ObjectId, DestinationId = moveToId })

	Move({ Id = enemy.ObjectId, DestinationId = moveToId, SuccessDistance = 40 })
	enemy.AINotifyName = "WithinDistance_"..enemy.Name.."_"..enemy.ObjectId
	NotifyWithinDistance({ Id = enemy.ObjectId, DestinationId = moveToId, Distance = 100, Notify = enemy.AINotifyName, Timeout = 10.0 })
	waitUntil( enemy.AINotifyName, enemy.AIThreadName )

	Stop({ Id = enemy.ObjectId })
	AngleTowardTarget({ Id = enemy.ObjectId, DestinationId = CurrentRun.Hero.ObjectId })
	enemy.PostCombatTravel = false
	enemy.TextLinesUseWeaponIdle = nil
	RemoveTimerBlock( CurrentRun, "HeraclesPostCombat" )
	UseableOn({ Id = enemy.ObjectId })
	HeraclesEncounterEndPresentation( enemy )

	AddInteractBlock( enemy, "HeraclesPostCombat" )
	wait(1.3)

	HeraclesObjectiveResultPresentation( enemy )
	if game.CurrentRun.CurrentRoom[_PLUGIN.guid .. "CurrentCageEncounter"].PlayerMoneyObjective > 0 then
		local consumableId = SpawnObstacle({ Name = "RoomMoneyDrop", DestinationId = enemy.ObjectId, Group = "Standing" })
		local reward = CreateConsumableItem( consumableId, "RoomMoneyDrop", 0 )
		reward.DropMoney = game.CurrentRun.CurrentRoom[_PLUGIN.guid .. "CurrentCageEncounter"].PlayerMoneyObjective
		MapState.RoomRequiredObjects[reward.ObjectId] = reward
		ApplyUpwardForce({ Id = consumableId, Speed = 425 })
		ApplyForce({ Id = consumableId, Speed = 350, Angle = GetAngle({ Id = enemy.ObjectId }), SelfApplied = true })
	end

	CheckAvailableTextLines( enemy )
	SetAvailableUseText( enemy )
	RemoveInteractBlock( enemy, "HeraclesPostCombat" )

	if enemy.NextInteractLines == nil then
		if CanReceiveGift( enemy ) then
			MapState.RoomRequiredObjects[enemy.ObjectId] = nil
			wait( 0.2 )
			if CheckRoomExitsReady( CurrentRun.CurrentRoom ) then
				UnlockRoomExits( CurrentRun, CurrentRun.CurrentRoom )
			end
		else
			HeraclesExit( enemy, { WaitTime = 1.5 })
		end
	end	
end

local heraclesEncounters = {
    F = {
        HeraclesCombatF = {
            InheritFrom = { "BaseHeraclesCombat", "GeneratedF" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
            HeraclesDummyUnitSet = game.EnemySets.CocoonSpawnsMedium,
        },
    },

    G = {
        HeraclesCombatG = {
            InheritFrom = { "BaseHeraclesCombat", "GeneratedG" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
            HeraclesDummyUnitSet = game.EnemySets.CocoonSpawnsMedium_G,
        },
    },

    H = {
        HeraclesCombatH = {
            InheritFrom = { "BaseHeraclesCombat", "GeneratedH" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
            HeraclesDummyUnitSet = game.EnemySets.BiomeH,
            HeraclesSpawnWait = 5,
            UnthreadedEvents = {
                -- { FunctionName = "HeraclesPreSpawnPresentation" },
                { FunctionName = _PLUGIN.guid .. "." .. "HandleHeraclesSpawn" },
                { FunctionName = "EncounterAudio" },
                { FunctionName = "HeraclesEncounterStartPresentation" },
                { FunctionName = "BeginHeraclesEncounter" },
                { FunctionName = "HandleEnemySpawns" },
                { FunctionName = "CheckForAllEnemiesDead" },
                { FunctionName = "PostCombatAudio" },
                -- { FunctionName = "SpawnRoomReward" },
                { FunctionName = _PLUGIN.guid .. "." .. "SetUnitPostCombatAI" }
            },
        },
    },

    I = {
        HeraclesCombatI = {
            InheritFrom = { "BaseHeraclesCombat", "GeneratedI" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
            HeraclesDummyUnitSet = game.EnemySets.BiomeI,
        },
    },
}

-- game.OverwriteTableKeys(game.EncounterData, heraclesEncounters)

local weight = 3

for roomSet, encounterTable in pairs(heraclesEncounters) do
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
            table.insert(game.NamedRequirementsData.NoRecentHeraclesEncounter[2].TableValuesToCount, encounterName)
            table.insert(game.NamedRequirementsData.NoRecentFieldNPCEncounter[1].TableValuesToCount, encounterName)
        end
    end
end

table.insert(mod.PostSetupRunData, function ()
    for _, encounterTable in pairs(heraclesEncounters) do
        for encounterName, _ in ipairs(encounterTable) do
            local encounterData = game.EncounterData[encounterName]
            local encounterRequirements = encounterData.GameStateRequirements
            for _, requirement in ipairs(encounterRequirements) do
                if requirement.Path and table.concat(requirement.Path, ".") == "CurrentRun.EncountersCompletedCache" and type(requirement.SumOf) == "table" then
                    table.insert(requirement.SumOf, encounterName)
                end
            end
        end
    end
end)

modutil.mod.Path.Wrap("SetupUnit", function (base, unit, currentRun, args)
    base(unit, currentRun, args)
    if game.CurrentRun.CurrentRoom and game.CurrentRun.CurrentRoom[_PLUGIN.guid .. "CurrentCageEncounter"] ~= nil then
		local encounterData = game.CurrentRun.CurrentRoom[_PLUGIN.guid .. "CurrentCageEncounter"]
		if encounterData.OnSpawnFunctionName ~= nil then
            print("calling", encounterData.OnSpawnFunctionName)
			game.CallFunctionName( encounterData.OnSpawnFunctionName, unit, encounterData )
		end
	end
end)

modutil.mod.Path.Wrap("StartFieldsEncounter", function (base, rewardCage, args)
    game.CurrentRun.CurrentRoom[_PLUGIN.guid .. "CurrentCageEncounter"] = rewardCage.Encounter
    base(rewardCage, args)
end)