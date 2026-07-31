modutil.mod.Path.Context.Env("OlympusSkyEntrancePresentation", function ()
    modutil.mod.Path.Wrap("GetIds", function (base, args)
        if args.Name == "SkySpawnPoints" then
            local spawnIds = base(args)
            if game.IsEmpty(spawnIds) then
                return { game.CurrentRun.CurrentRoom.HeroEndPoint }
            end
            return spawnIds
        end
        return base(args)
    end)
end)