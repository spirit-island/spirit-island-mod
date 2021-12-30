function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
local riverGuid = "9138aa"
function doSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing this button!", Color.Red)
        return
    elseif color ~= getPlayerColor() then
        Player[color].broadcast("You have not picked River Surges in Sunlight!", Color.Red)
        return
    end

    for _, card in pairs(Player[color].getHandObjects(1)) do
        if card.guid == "22b2f3" then
            Global.call("ensureCardInPlay", {card=card})
            Wait.frames(function() Global.call("discardPowerCardFromPlay", {card = card, discardHeight = 1}) end, 1)
            Global.call("giveEnergy", {color=getPlayerColor(), energy=1})
            break
        end
    end
end
function getPlayerColor()
    local zoneGuids = {}
    for color,guid in pairs(Global.getTable("elementScanZones")) do
        zoneGuids[guid] = color
    end
    for _,zone in pairs(getObjectFromGUID(riverGuid).getZones()) do
        if zoneGuids[zone.guid] then
            return zoneGuids[zone.guid]
        end
    end
    return ""
end
