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

for roomSet, encounterTable in pairs(heraclesEncounters) do
    for _, roomName in ipairs(mod.RoomSets[roomSet]) do
        local roomData = game.RoomData[roomName]
        for encounterName, encounterData in pairs(encounterTable) do
            game.EncounterData[encounterName] = encounterData
            for i = 1, 5 do
                table.insert(roomData.LegalEncounters, encounterName)
            end
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
            table.insert(game.NamedRequirementsData.NoRecentHeraclesEncounter[2].TableValuesToCount, encounterName)
            table.insert(game.NamedRequirementsData.NoRecentFieldNPCEncounter[1].TableValuesToCount, encounterName)
        end
    end
end)