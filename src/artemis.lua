local artemisEncounters = {
    H = {
        ArtemisCombatH = {
            InheritFrom = { "BaseArtemisCombat", "GeneratedH" },
            DifficultyModifier = 170,
            CanEncounterSkip = false,
            GameStateRequirements =
            {
                {
                    PathTrue = { "GameState", "EncountersCompletedCache", "ArtemisCombatIntro" },
                },
                {
                    PathFalse = { "CurrentRun", "UseRecord", "NPC_Artemis_Field_01" },
                },
                {
                    Path = { "CurrentRun", "BiomeDepthCache" },
                    Comparison = ">=",
                    Value = 0,
                },
                NamedRequirements = { "NoRecentFieldNPCEncounter" },
                NamedRequirementsFalse = { "StandardPackageBountyActive", "SurfaceRouteLockedByTyphonKill" },
            },
        },
    },

    I = {
        ArtemisCombatI = {
            InheritFrom = { "BaseArtemisCombat", "GeneratedI" },
            DifficultyModifier = 200,
            CanEncounterSkip = false,
        },
    },

    P = {
        ArtemisCombatP = {
            InheritFrom = { "BaseArtemisCombat", "GeneratedP" },
            DifficultyModifier = 250,
            BlockMultipleEncounters = true,
            CanEncounterSkip = false,
        },
    },
}

local weight = 5

for roomSet, encounterTable in pairs(artemisEncounters) do
    for _, roomName in ipairs(mod.RoomSets[roomSet]) do
        local roomData = game.RoomData[roomName]
        for encounterName, encounterData in pairs(encounterTable) do
            game.EncounterData[encounterName] = encounterData
            for i = 1, weight do
                if roomSet ~= "H" then
                    table.insert(roomData.LegalEncounters, encounterName)
                    if roomData.MultipleEncountersData then
                        table.insert(roomData.MultipleEncountersData[1].LegalEncounters, encounterName)
                    end
                else
                    table.insert(game.ObstacleData.FieldsRewardCage.LegalEncounters, encounterName)
                end
            end
            table.insert(game.NamedRequirementsData.NoRecentFieldNPCEncounter[1].TableValuesToCount, encounterName)
        end
    end
end