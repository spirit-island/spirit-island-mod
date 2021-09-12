function doSpiritSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing this button!", Color.Red)
        return
    end

    local zone = getObjectFromGUID(Global.getVar("elementScanZones")[color])
    local objs = zone.getObjects()
    local found = false
    local serpent = nil
    for _,obj in pairs(objs) do
        if obj.guid == "cebe09" then
            found = true
            serpent = obj
            break
       end
    end
    if not found then
        Player[color].broadcast("You have not picked Serpent Slumbering Beneath the Island!", Color.Red)
        return
    end

    local snapPoints = serpent.getSnapPoints()

    table.insert(snapPoints,{position={1.14, 0.20, 0.65}})
    table.insert(snapPoints,{position={0.92, 0.20, 0.65}})
    table.insert(snapPoints,{position={0.70, 0.20, 0.65}})
    table.insert(snapPoints,{position={1.25, 0.20, 0.84}})
    table.insert(snapPoints,{position={1.03, 0.20, 0.84}})
    table.insert(snapPoints,{position={0.81, 0.20, 0.84}})
    serpent.setSnapPoints(snapPoints)

    self.destruct()
end
