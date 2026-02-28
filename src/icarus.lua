local icarusEncounters = {
    F = {
        IcarusCombatF = {
            InheritFrom = { "BaseIcarusCombat", "GeneratedF" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
        },
    },

    G = {
        IcarusCombatG = {
            InheritFrom = { "BaseIcarusCombat", "GeneratedG" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
        },
    },

    H = {
        IcarusCombatH = {
            InheritFrom = { "BaseIcarusCombat", "GeneratedH" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
        },
    },

    I = {
        IcarusCombatI = {
            InheritFrom = { "BaseIcarusCombat", "GeneratedI" },
            DifficultyModifier = 150,
            MinWaves = 3,
            MaxWaves = 3,
        },
    },
}

-- game.OverwriteTableKeys(game.EncounterData, icarusEncounters)

local weight = 5

for roomSet, encounterTable in pairs(icarusEncounters) do
    for _, roomName in ipairs(mod.RoomSets[roomSet]) do
        local roomData = game.RoomData[roomName]
        for encounterName, encounterData in pairs(encounterTable) do
            game.EncounterData[encounterName] = encounterData
            for i = 1, weight do
                if roomSet ~= "H" then
                    table.insert(roomData.LegalEncounters, encounterName)
                else
                    table.insert(game.ObstacleData.FieldsRewardCage, encounterName)
                end
            end
            table.insert(game.NamedRequirementsData.NoRecentFieldNPCEncounter[1].TableValuesToCount, encounterName)
        end
    end
end