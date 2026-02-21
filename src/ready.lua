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

mod.RoomSets.Anomaly = mod.RoomSets.G

game.RoomData["H_PreBoss01"].GameStateRequirements = {}
game.RoomData["H_PreBoss01"].ForceAtBiomeDepth = 5

for _, storyRoom in ipairs(storyRooms) do
    table.insert(game.RoomData[storyRoom].GameStateRequirements, {
        PathFalse = { "CurrentRun", _PLUGIN.guid .. "SwappedStoryMap", storyRoom }
    })
end

function mod.SelectRandomStoryRoom()
    local unusedStoryRooms = {}
    for _, storyRoom in ipairs(storyRooms) do
        if not game.CurrentRun[_PLUGIN.guid .. "StoryRoomsCreated"][storyRoom] then
            table.insert(unusedStoryRooms, storyRoom)
        end
    end
    return unusedStoryRooms[math.random(1, #unusedStoryRooms)]
end

modutil.mod.Path.Wrap("OlympusSkyExitPresentation", function (base, currentRun, exitDoor)
    local currentBiome = currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"]
    base(currentRun, exitDoor)
    if currentBiome ~= "P" and currentRun.CurrentRoom.Name == "P_Story01" then
        game.CurrentRun.CurrentRoom.NextRoomEntranceFunctionNameOverride = nil
	    game.CurrentRun.CurrentRoom.NextRoomEntranceFunctionArgsOverride = nil
    end
end)

modutil.mod.Path.Wrap("ChooseNextRoomData", function (base, currentRun, args, otherDoors)
    args = args or {}
    game.CurrentRun[_PLUGIN.guid .. "SwappedStoryMap"] = game.CurrentRun[_PLUGIN.guid .. "SwappedStoryMap"] or {}
    game.CurrentRun[_PLUGIN.guid .. "StoryRoomsCreated"] = game.CurrentRun[_PLUGIN.guid .. "StoryRoomsCreated"] or {}

    local currentBiome = currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"]
    print(currentBiome)
    if currentBiome and args.ForceNextRoomSet == nil then
        args.ForceNextRoomSet = currentBiome
		if not currentRun.CurrentRoom[_PLUGIN.guid .. "SkipBiomeCleanup"] then
			game.CurrentRun.BiomesReached[currentRun.CurrentRoom.RoomSetName] = nil
		end
        if currentRun.CurrentRoom.RoomSetName ~= currentBiome then
            game.CurrentRun.RoomCreations[currentRun.CurrentRoom.Name] = 0
        end
        local currentBiomeCombatRooms = mod.RoomSets[currentBiome]
		if not currentBiomeCombatRooms then
			print("previous room biome not valid, getting RoomSet from room n-2")
			local prevRoomIndex = game.TableLength( currentRun.RoomHistory ) - 1
			currentBiome = currentRun.RoomHistory[prevRoomIndex].RoomSetName
			print(currentBiome)
			currentBiomeCombatRooms = mod.RoomSets[currentBiome]
		end
        local nextRoomData = game.RoomData[currentBiomeCombatRooms[math.random(1, #currentBiomeCombatRooms)]]
		print("linked", currentRun.CurrentRoom.Name, "to", nextRoomData.Name)
        return nextRoomData
    end
    local nextRoomData = base(currentRun, args, otherDoors)
    if game.Contains(storyRooms, nextRoomData.Name) then
        local origStoryRoom = nextRoomData.Name
        game.CurrentRun[_PLUGIN.guid .. "SwappedStoryMap"][origStoryRoom] = true
        nextRoomData = game.RoomData[mod.SelectRandomStoryRoom()]
        nextRoomData[_PLUGIN.guid .. "CurrentBiome"] = currentRun.CurrentRoom.RoomSetName
        game.CurrentRun[_PLUGIN.guid .. "StoryRoomsCreated"][nextRoomData.Name] = true
		if game.CurrentRun.BiomesReached[nextRoomData.RoomSetName] then
			nextRoomData[_PLUGIN.guid .. "SkipBiomeCleanup"] = true
		end
        print("swapped", origStoryRoom, "with", nextRoomData.Name)
    end
    return nextRoomData
end)

modutil.mod.Path.Wrap("AttemptUseDoor", function (base, door, args)
	args = args or {}
	if not (not door.ReadyToUse or not game.CheckRoomExitsReady( game.CurrentRun.CurrentRoom ) or game.CheckSpecialDoorRequirement( door ) ~= nil) and (not door.InUse) then
		local currentRun = game.CurrentRun
		local currentBiome = currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"]
		if currentBiome == "N" then
			door.ReturnToPreviousRoomName = "N_Hub"
			if not currentRun.CurrentRoom[_PLUGIN.guid .. "SkipBiomeCleanup"] then
				game.CurrentRun.BiomesReached[currentRun.CurrentRoom.RoomSetName] = nil
			end
			if currentRun.CurrentRoom.RoomSetName ~= currentBiome then
				game.CurrentRun.RoomCreations[currentRun.CurrentRoom.Name] = 0
				game.CurrentRun.SpawnRecord.SoulPylon = (game.CurrentRun.SpawnRecord.SoulPylon or 0) + 1
			end
			print("linked", currentRun.CurrentRoom.Name, "to N_Hub")
		elseif currentBiome and currentBiome ~= "N" and currentRun.CurrentRoom.Name == "N_Story01" then
			door.ReturnToPreviousRoomName = nil
			door.NextRoomEntranceFunctionName = nil
		end
	end
	base(door, args)
end)

modutil.mod.Path.Wrap("LeaveRoom", function (base, currentRun, door)
    if currentRun.CurrentRoom.Name == "N_Hub" and door.Room.Name == "N_Story01" then
        local origStoryRoom = "N_Story01"
        game.CurrentRun[_PLUGIN.guid .. "SwappedStoryMap"][origStoryRoom] = true
        door.Room = game.CreateRoom(game.RoomData[mod.SelectRandomStoryRoom()])
        door.Room[_PLUGIN.guid .. "CurrentBiome"] = currentRun.CurrentRoom.RoomSetName
        game.CurrentRun[_PLUGIN.guid .. "StoryRoomsCreated"][door.Room.Name] = true
		if game.CurrentRun.BiomesReached[door.Room.RoomSetName] then
			door.Room[_PLUGIN.guid .. "SkipBiomeCleanup"] = true
		end
		print("swapped", origStoryRoom, "with", door.Room.Name)
    end
	local currentBiome = currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"]
	if currentBiome and currentBiome ~= "N" and currentRun.CurrentRoom.Name == "N_Story01" then
		game.CurrentRun.CurrentRoom.NextHeroStartPoint = nil
		game.CurrentRun.CurrentRoom.NextHeroEndPoint = nil
	end
    return base(currentRun, door)
end)