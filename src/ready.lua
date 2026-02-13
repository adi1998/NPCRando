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
    "H_Story01",
    "I_Story01",

    "N_Story01",
    "O_Story01",
    "P_Story01",
}

modutil.mod.Path.Wrap("ChooseNextRoomData", function (base, currentRun, args, otherDoors)
    args = args or {}
    if currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"] then
        args.ForceNextRoomSet = currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"]
        game.CurrentRun.BiomesReached[currentRun.CurrentRoom[_PLUGIN.guid .. "CurrentBiome"]] = nil
    end
    local nextRoomData = base(currentRun, args, otherDoors)
    if game.Contains(storyRooms, nextRoomData.Name) then
        nextRoomData = game.RoomData[storyRooms[math.random(#storyRooms)]]
        nextRoomData[_PLUGIN.guid .. "CurrentBiome"] = currentRun.CurrentRoom.RoomSetName
    end
    return nextRoomData
end)
