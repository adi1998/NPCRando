function mod.dump(o, depth)
    depth = depth or 0
    if type(o) == 'table' then
        local s = "\n" .. string.rep("\t", depth) .. '{\n'
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. string.rep("\t",(depth+1)) .. '['..k..'] = ' .. mod.dump(v, depth + 1) .. ',\n'
        end
        return s .. string.rep("\t", depth) .. '}'
    elseif type(o) == "string" then
        return "\"" .. o .. "\""
    else
        return tostring(o)
    end
end

local storyRooms = {
    "F_Story01",
    "G_Story01",
    "H_Bridge01",
    "I_Story01",

	"N_Story01",
    "O_Story01",
    "P_Story01",
}

local zagStoryRooms = {
	"A_Story01",
	"X_Story01",
	"Y_Story01",
}

if rom.mods["NikkelM-Zagreus_Journey"] and rom.mods["NikkelM-Zagreus_Journey"].config and rom.mods["NikkelM-Zagreus_Journey"].config.enabled then
	game.ConcatTableValuesIPairs(storyRooms, zagStoryRooms)
end

mod.RoomSets =
{
	F =
	{
		"F_Combat01",
		"F_Combat02",
		"F_Combat03",
		"F_Combat04",
		"F_Combat05",
		"F_Combat06",
		"F_Combat07",
		"F_Combat08",
		"F_Combat09",
		"F_Combat10",
		"F_Combat11",
		"F_Combat12",
		"F_Combat13",
		"F_Combat14",
		"F_Combat15",
		"F_Combat16",
		"F_Combat17",
		"F_Combat18",
		"F_Combat19",
		"F_Combat20",
		"F_Combat21",
		"F_Combat22",
	},

	G =
	{
		"G_Combat01",
		"G_Combat02",
		"G_Combat03",
		"G_Combat04",
		"G_Combat05",
		"G_Combat06",
		"G_Combat07",
		"G_Combat08",
		"G_Combat09",
		"G_Combat10",
		"G_Combat11",
		"G_Combat12",
		"G_Combat13",
		"G_Combat14",
		"G_Combat15",
		"G_Combat16",
		"G_Combat17",
		"G_Combat18",
		"G_Combat19",
		"G_Combat20",
	},

	H =
	{
		"H_Combat01",
		-- "H_Combat02",
		"H_Combat03",
		"H_Combat04",
		"H_Combat05",
		"H_Combat06",
		"H_Combat07",
		"H_Combat08",
		-- "H_Combat09",
		"H_Combat10",
		"H_Combat11",
		"H_Combat12",
		-- "H_Combat13",
		-- "H_Combat14",
		-- "H_Combat15",
	},

	I =
	{
		"I_Combat01",
		"I_Combat01",
		"I_Combat02",
		"I_Combat03",
		"I_Combat03",
		"I_Combat04",
		"I_Combat04",
		"I_Combat05",
		"I_Combat06",
		"I_Combat07",
		"I_Combat08",
		"I_Combat09",
		"I_Combat09",
		"I_Combat10",
		"I_Combat10",
		"I_Combat11",
		"I_Combat11",
		"I_Combat12",
		"I_Combat12",
		"I_Combat13",
		"I_Combat14",
		"I_Combat15",
		"I_Combat16",
		"I_Combat17",
		"I_Combat18",
		"I_Combat18",
		"I_Combat19",
		"I_Combat20",
		"I_Combat21",
		"I_Combat21",
		"I_Combat22",
		"I_Combat22",
		"I_Combat23",
		"I_Combat24",
	},

	N = {
		"N_Hub"
	},

	O =
	{
		"O_Combat01",
		"O_Combat02",
		"O_Combat03",
		"O_Combat04",
		"O_Combat05",
		"O_Combat06",
		"O_Combat07",
		"O_Combat08",
		"O_Combat09",
		"O_Combat10",
		"O_Combat11",
		"O_Combat12",
		"O_Combat13", -- Backup if there is nothing eligible before PreBoss
		"O_Combat14",
		"O_Combat15",
	},

	P =
	{
		"P_Combat01",
		"P_Combat02",
		"P_Combat03",
		"P_Combat04",
		"P_Combat05",
		"P_Combat06",
		"P_Combat07",
		"P_Combat08",
		"P_Combat09",
		"P_Combat10",
		"P_Combat11",
		"P_Combat12",
		"P_Combat13",
		"P_Combat14",
		"P_Combat15",
		"P_Combat16",
		"P_Combat17",
		"P_Combat18",
		"P_Combat19",
	},
}

mod.ZagRoomSets = {
	Tartarus = {
		"A_Combat01",
		"A_Combat02",
		"A_Combat03",
		"A_Combat04",
		"A_Combat05",
		"A_Combat06",
		"A_Combat07",
		"A_Combat08A",
		"A_Combat08B",
		"A_Combat09",
		"A_Combat10",
		"A_Combat11",
		"A_Combat12",
		"A_Combat13",
		"A_Combat14",
		"A_Combat15",
		"A_Combat16",
		"A_Combat17",
		"A_Combat18",
		"A_Combat19",
		"A_Combat20",
		"A_Combat21",
		"A_Combat24",
	},
	Asphodel = {
		"X_Combat01",
		"X_Combat02",
		"X_Combat03",
		"X_Combat04",
		"X_Combat05",
		"X_Combat06",
		"X_Combat07",
		"X_Combat08",
		"X_Combat09",
		"X_Combat10",
		"X_Combat21",
		"X_Combat22",
	},
	Elysium = {
		"Y_Combat01",
		"Y_Combat02",
		"Y_Combat03",
		"Y_Combat04",
		"Y_Combat05",
		"Y_Combat06",
		"Y_Combat08",
		"Y_Combat09",
		"Y_Combat10",
		"Y_Combat11",
		"Y_Combat12",
		"Y_Combat13",
		"Y_Combat14",
	},
}

if rom.mods["NikkelM-Zagreus_Journey"] and rom.mods["NikkelM-Zagreus_Journey"].config and rom.mods["NikkelM-Zagreus_Journey"].config.enabled then
	game.OverwriteTableKeys(mod.RoomSets, mod.ZagRoomSets)
end


game.RoomData["H_PreBoss01"].GameStateRequirements = {}
game.RoomData["H_PreBoss01"].ForceAtBiomeDepth = 5

for _, storyRoom in ipairs(storyRooms) do
    table.insert(game.RoomData[storyRoom].GameStateRequirements, {
        PathFalse = { "CurrentRun", _PLUGIN.guid .. "SwappedStoryMap", storyRoom }
    })
end

function mod.SelectRandomStoryRoom(origStoryRoom)
    local unusedStoryRooms = {}
    for _, storyRoom in ipairs(storyRooms) do
        if not game.CurrentRun[_PLUGIN.guid .. "StoryRoomsCreated"][storyRoom] and ( (not config.never_default) or origStoryRoom ~= storyRoom ) then
            table.insert(unusedStoryRooms, storyRoom)
        end
    end
	print("available story rooms", mod.dump(unusedStoryRooms))
	local retval = unusedStoryRooms[math.random(1, #unusedStoryRooms)]
	print("Selected", retval)
    return retval
end

modutil.mod.Path.Wrap("OlympusSkyExitPresentation", function (base, currentRun, exitDoor)
    local currentBiome = currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"]
    base(currentRun, exitDoor)
    if currentBiome and currentBiome ~= "P" and currentRun.CurrentRoom.Name == "P_Story01" then
        game.CurrentRun.CurrentRoom.NextRoomEntranceFunctionNameOverride = nil
	    game.CurrentRun.CurrentRoom.NextRoomEntranceFunctionArgsOverride = nil
		print("resetting NextRoomEntranceFunctionNameOverride for exit to", ((exitDoor or {}).Room or {}).Name)
    end
end)

modutil.mod.Path.Wrap("ChooseNextRoomData", function (base, currentRun, args, otherDoors)
	args = args or {}
	game.CurrentRun[_PLUGIN.guid .. "SwappedStoryMap"] = game.CurrentRun[_PLUGIN.guid .. "SwappedStoryMap"] or {}
	game.CurrentRun[_PLUGIN.guid .. "StoryRoomsCreated"] = game.CurrentRun[_PLUGIN.guid .. "StoryRoomsCreated"] or {}

	local currentBiome = currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"]
	print("CurrentRoom[_PLUGIN.guid .. \"CurrentBiome\"]", currentBiome)
	if currentBiome and args.ForceNextRoomSet == nil then
		args.ForceNextRoomSet = currentBiome
		if not currentRun.CurrentRoom[_PLUGIN.guid .. "SkipBiomeCleanup"] then
			print("removing", currentRun.CurrentRoom.RoomSetName, "from BiomesReached")
			game.CurrentRun.BiomesReached[currentRun.CurrentRoom.RoomSetName] = nil
		end
		if currentRun.CurrentRoom.RoomSetName ~= currentBiome then
			print("resetting RoomCreations for", currentRun.CurrentRoom.Name, "while linking back to current biome", currentBiome)
			game.CurrentRun.RoomCreations[currentRun.CurrentRoom.Name] = 0
		end
		local currentBiomeCombatRooms = mod.RoomSets[currentBiome]
		if not currentBiomeCombatRooms then
			print("previous room biome not valid:", currentBiome , ", getting RoomSetName from room n-2")
			local prevRoomIndex = game.TableLength( currentRun.RoomHistory ) - 1
			currentBiome = currentRun.RoomHistory[prevRoomIndex].RoomSetName
			print("new currentBiome", currentBiome)
			currentBiomeCombatRooms = mod.RoomSets[currentBiome]
		end
		local nextRoomData = game.DeepCopyTable(game.RoomData[currentBiomeCombatRooms[math.random(1, #currentBiomeCombatRooms)]])
		print("linked", currentRun.CurrentRoom.Name, "to", nextRoomData.Name)
		if currentBiome == "H" and currentRun.CurrentRoom.Name ~= "H_Bridge01" then
			currentRun.CurrentRoom.NumDoorCageRewards = (game.RandomChance(0.8) and math.min(3, nextRoomData.MaxCageRewards or 3)) or 2
			print("setting up NumDoorCageRewards", currentRun.CurrentRoom.NumDoorCageRewards)
		end
		if currentBiome == "O" then
			nextRoomData.RewardPreviewOverride = "ExitAheadPreview"
			nextRoomData[_PLUGIN.guid .. "ResetRewardPreviewOverride"] = true
			nextRoomData.EntranceDirection = "LeftRight"
			nextRoomData.FlipHorizontalChance = 0.0
		end
		if mod.ZagRoomSets[currentBiome] then
			game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = true
		else
			game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = false
		end
		return nextRoomData
	end
	local nextRoomData = base(currentRun, args, otherDoors)
	if game.Contains(storyRooms, nextRoomData.Name) then
		local origStoryRoom = nextRoomData.Name
		game.CurrentRun[_PLUGIN.guid .. "SwappedStoryMap"][origStoryRoom] = true
		nextRoomData = game.DeepCopyTable(game.RoomData[mod.SelectRandomStoryRoom(origStoryRoom)])
		nextRoomData[_PLUGIN.guid .. "CurrentBiome"] = currentRun.CurrentRoom.RoomSetName
		game.CurrentRun[_PLUGIN.guid .. "StoryRoomsCreated"][nextRoomData.Name] = true
		if game.CurrentRun.BiomesReached[nextRoomData.RoomSetName] then
			nextRoomData[_PLUGIN.guid .. "SkipBiomeCleanup"] = true
			print("skipping BiomesReached cleanup for", nextRoomData.RoomSetName)
		end
		if game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun then
			nextRoomData.RewardPreviewOverride = "ModsNikkelMHadesBiomes_StoryPreview"
		else
			nextRoomData.RewardPreviewOverride = "StoryPreview"
		end
		nextRoomData.SecretSpawnChance = 0
		nextRoomData.SecretChanceSuccess = false
		nextRoomData.ShrinePointDoorSpawnChance = 0
		nextRoomData.ShrinePointDoorChanceSuccess = false
		nextRoomData.AnomalyDoorChance = 0
		nextRoomData.AnomalyDoorChanceSuccess = false
		print("swapped", origStoryRoom, "with", nextRoomData.Name)
	end
	if currentBiome and (args.ForceNextRoomSet or nextRoomData.UsePreviousRoomSet) then
		print("story to secret biome transition detected,", "args.ForceNextRoomSet:", args.ForceNextRoomSet, ", nextRoomData.UsePreviousRoomSet:", nextRoomData.UsePreviousRoomSet)
		nextRoomData = game.DeepCopyTable(nextRoomData)
		local currentBiomeCombatRooms = mod.RoomSets[currentBiome]
		if not currentBiomeCombatRooms then
			print("previous room biome not valid:", currentBiome , ", getting RoomSetName from room n-2")
			local prevRoomIndex = game.TableLength( currentRun.RoomHistory ) - 1
			currentBiome = currentRun.RoomHistory[prevRoomIndex].RoomSetName
			print("new currentBiome", currentBiome)
		end
		print("applied NextRoomSet for room", nextRoomData.Name)
		nextRoomData.NextRoomSet = { currentBiome }
	end
	return nextRoomData
end)

modutil.mod.Path.Wrap("CreateRoom", function (base, roomData, args)
	local room = base(roomData, args)
	if game.Contains(storyRooms, room.Name) and room[_PLUGIN.guid .. "CurrentBiome"] then
		print("Resetting RoomCreations for", room.Name, "after room creation")
		game.CurrentRun.RoomCreations[room.Name] = 0
	end
	return room
end)

modutil.mod.Path.Wrap("AttemptUseDoor", function (base, door, args)
	args = args or {}
	if not (not door.ReadyToUse or not game.CheckRoomExitsReady( game.CurrentRun.CurrentRoom ) or game.CheckSpecialDoorRequirement( door ) ~= nil) and (not door.InUse) then
		local currentRun = game.CurrentRun
		local currentBiome = currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"]
		if currentBiome == "N" then
			door.ReturnToPreviousRoomName = "N_Hub"
			if not currentRun.CurrentRoom[_PLUGIN.guid .. "SkipBiomeCleanup"] then
				print("cleaning up BiomesReached", currentRun.CurrentRoom.RoomSetName)
				game.CurrentRun.BiomesReached[currentRun.CurrentRoom.RoomSetName] = nil
			end
			if currentRun.CurrentRoom.RoomSetName ~= currentBiome then
				print("resetting RoomCreations for", currentRun.CurrentRoom.Name, "while linking back to current biome", currentBiome)
				game.CurrentRun.RoomCreations[currentRun.CurrentRoom.Name] = 0
				game.CurrentRun.SpawnRecord.SoulPylon = (game.CurrentRun.SpawnRecord.SoulPylon or 0) + 1
				print("increasing destroyed SoulPylon count to", game.CurrentRun.SpawnRecord.SoulPylon)
			end
			print("linked", currentRun.CurrentRoom.Name, "to N_Hub")
			game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = false
		elseif currentBiome and currentBiome ~= "N" and currentRun.CurrentRoom.Name == "N_Story01" then
			door.ReturnToPreviousRoomName = nil
			door.NextRoomEntranceFunctionName = nil
			print("resetting ReturnToPreviousRoomName and NextRoomEntranceFunctionName while exiting to", currentBiome, "from", currentRun.CurrentRoom.Name)
		end
	end
	base(door, args)
end)

modutil.mod.Path.Wrap("LeaveRoom", function (base, currentRun, door)
    if currentRun.CurrentRoom.Name == "N_Hub" and door.Room.Name == "N_Story01" then
        local origStoryRoom = "N_Story01"
        game.CurrentRun[_PLUGIN.guid .. "SwappedStoryMap"][origStoryRoom] = true
		local roomData = game.DeepCopyTable(game.RoomData[mod.SelectRandomStoryRoom()])
		roomData.ChosenRewardType = "Story"
        door.Room = game.CreateRoom(roomData)
        door.Room[_PLUGIN.guid .. "CurrentBiome"] = currentRun.CurrentRoom.RoomSetName
        game.CurrentRun[_PLUGIN.guid .. "StoryRoomsCreated"][door.Room.Name] = true
		if game.CurrentRun.BiomesReached[door.Room.RoomSetName] then
			door.Room[_PLUGIN.guid .. "SkipBiomeCleanup"] = true
			print("skipping BiomesReached cleanup for", door.Room.RoomSetName)
		end
		door.Room.SecretSpawnChance = 0
		door.Room.SecretChanceSuccess = false
		door.Room.ShrinePointDoorSpawnChance = 0
		door.Room.ShrinePointDoorChanceSuccess = false
		door.Room.AnomalyDoorChance = 0
		door.Room.AnomalyDoorChanceSuccess = false
		print("swapped", origStoryRoom, "with", door.Room.Name)
    end
	local currentBiome = currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"]
	if currentBiome and currentBiome ~= "N" and currentRun.CurrentRoom.Name == "N_Story01" then
		game.CurrentRun.CurrentRoom.NextHeroStartPoint = nil
		game.CurrentRun.CurrentRoom.NextHeroEndPoint = nil
		print("resetting NextHeroStartPoint and NextHeroEndPoint while exiting to", currentBiome, "from", currentRun.CurrentRoom.Name)

		print("current SoulPylon SpawnRecord", game.CurrentRun.SpawnRecord.SoulPylon)
		game.CurrentRun.SpawnRecord.SoulPylon = (game.CurrentRun.SpawnRecord.SoulPylon or 1) - 1
		print("resetting SoulPylon SpawnRecord to", game.CurrentRun.SpawnRecord.SoulPylon)
		game.CurrentRun.RoomsEntered[currentRun.CurrentRoom.Name] = nil
		print("resetting CurrentRun.RoomsEntered for", currentRun.CurrentRoom.Name)
	end
	if door.Room[_PLUGIN.guid .. "CurrentBiome"] and game.Contains(zagStoryRooms, door.Room.Name) then
		game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = true
	elseif door.Room[_PLUGIN.guid .. "CurrentBiome"] and not game.Contains(zagStoryRooms, door.Room.Name) then
		game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = false
	end
    return base(currentRun, door)
end)

modutil.mod.Path.Wrap("StartRoom", function (base, currentRun, currentRoom)
	if currentRoom[_PLUGIN.guid .. "ResetRewardPreviewOverride"] then
		currentRoom.RewardPreviewOverride = nil
	end
	return base(currentRun, currentRoom)
end)

if rom.mods["NikkelM-Zagreus_Journey"] and rom.mods["NikkelM-Zagreus_Journey"].config and rom.mods["NikkelM-Zagreus_Journey"].config.enabled then
	modutil.mod.Path.Wrap("LoadCurrentRoomResources", function (base, ...)
		game.LoadPackages({ Names = { "ModsNikkelMHadesBiomesGUIOriginal" } })
		base(...)
	end)

	modutil.mod.Path.Wrap("SetupClockworkGoalReward", function (base, rewardData, currentRoom, room, previouslyChosenRewards, args, setupFunctionArgs)
		base(rewardData, currentRoom, room, previouslyChosenRewards, args, setupFunctionArgs)
		if not game.Contains({"HadesLockIcon", "ShopPreview"}, room.RewardPreviewOverride) then
			print("unexpected RewardPreviewOverride found", room.RewardPreviewOverride)
			room.RewardPreviewOverride = "ClockworkCountdown"..(game.CurrentRun.RemainingClockworkGoals or 0)
			print("replacing with", room.RewardPreviewOverride)
		end
	end)
end