local healthCount = 0
local autoExchange = true
local oceanGuid = "07dd23"

function onSave()
    local data_table = {
        healthCount = healthCount,
        autoExchange = autoExchange
    }
    return JSON.encode(data_table)
end
function onLoad(save_state)
    if Global.getVar("gameStarted") then
        if save_state ~= "" then
            local loaded_data = JSON.decode(save_state)
            healthCount = loaded_data.healthCount
            autoExchange = loaded_data.autoExchange
        end
        if autoExchange then
            exchangeAuto()
        end
        Wait.frames(function()
            self.UI.setAttribute("count", "text", healthCount)
            self.UI.setAttribute("players", "text", Global.getVar("numPlayers"))
            self.UI.setAttribute("toggleExchange", "isOn", autoExchange)
            local visiblity = ""
            if autoExchange then
                visiblity = "Invisible"
            end
            self.UI.setAttribute("buttonExchange", "visibility", visiblity)
            self.UI.setAttribute("drownPanel", "visibility", "")
            self.UI.setAttribute("drownPanel2", "visibility", "")
        end, 2)
    end
end

function tryObjectEnter(enter_object)
    if string.sub(enter_object.getName(),1,8) == "Explorer" then
        healthCount = healthCount + 1
    elseif string.sub(enter_object.getName(),1,4) == "Town" then
        healthCount = healthCount + 2
    elseif string.sub(enter_object.getName(),1,4) == "City" then
        healthCount = healthCount + 3
    end
    if autoExchange then
        exchangeAuto()
    end
    self.UI.setAttribute("count", "text", healthCount)
    Global.call("cleanupObject", {obj=enter_object, fear=true})
    return false
end

function doSetup(params)
    if not Global.getVar("gameStarted") then
        return
    end
    self.UI.setAttribute("count", "text", healthCount)
    self.UI.setAttribute("players", "text", Global.getVar("numPlayers"))
    self.UI.setAttribute("drownPanel", "visibility", "")
    self.UI.setAttribute("drownPanel2", "visibility", "")
end

function toggleExchange()
    autoExchange = not autoExchange
    if autoExchange then
        exchangeAuto()
        self.UI.setAttribute("count", "text", healthCount)
        self.UI.setAttribute("buttonExchange", "visibility", "Invisible")
    else
        self.UI.setAttribute("buttonExchange", "visibility", "")
    end
    self.UI.setAttribute("toggleExchange", "isOn", autoExchange)
end
function exchange(player, _, _)
    local numPlayers = Global.getVar("numPlayers")
    if numPlayers <= healthCount then
        local success = Global.call("giveEnergy", {color=getPlayerColor(), energy=1})
        if success then
            healthCount = healthCount - numPlayers
            self.UI.setAttribute("count", "text", healthCount)
        else
            Player[player.color].broadcast("Unable to find Ocean player to give exchanged energy to", Color.Red)
        end
    else
        Player[player.color].broadcast("Not enough Health worth of Invaders currently to exchange into Energy", Color.Red)
    end
end

function getPlayerColor()
    local zoneGuids = {}
    for color,guid in pairs(Global.getTable("elementScanZones")) do
        zoneGuids[guid] = color
    end
    for _,zone in pairs(getObjectFromGUID(oceanGuid).getZones()) do
        if zoneGuids[zone.guid] then
            return zoneGuids[zone.guid]
        end
    end
    return ""
end
function exchangeAuto()
    local numPlayers = Global.getVar("numPlayers")
    local energy = healthCount / numPlayers
    if energy == 0 then return end
    local success = Global.call("giveEnergy", {color=getPlayerColor(), energy=energy})
    if success then
        healthCount = healthCount % numPlayers
    else
        broadcastToAll("Unable to find Ocean player to give exchanged Energy to", Color.Red)
    end
end
