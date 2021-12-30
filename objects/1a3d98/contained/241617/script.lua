local lightningGuid = "4a0884"
function doSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing this button!", Color.Red)
        return
    elseif color ~= getPlayerColor() then
        Player[color].broadcast("You have not picked Lightning's Swift Strike!", Color.Red)
        return
    end

    local lightning = getObjectFromGUID(lightningGuid)
    local json = JSON.decode(lightning.script_state)
    if not json.immense then
        for _,data in pairs(json.trackEnergy) do
            data.count = data.count * 2
        end
        json.immense = true
        lightning.script_state = JSON.encode(json)
        lightning.setTable("trackEnergy", json.trackEnergy)
    end
end
function getPlayerColor()
    local zoneGuids = {}
    for color,guid in pairs(Global.getTable("elementScanZones")) do
        zoneGuids[guid] = color
    end
    for _,zone in pairs(getObjectFromGUID(lightningGuid).getZones()) do
        if zoneGuids[zone.guid] then
            return zoneGuids[zone.guid]
    end
    end
    return ""
end
