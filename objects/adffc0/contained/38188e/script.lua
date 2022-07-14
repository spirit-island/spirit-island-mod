local healthCount = 0
local autoExchange = true

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
        setupComplete = true -- luacheck: ignore 111
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
            else
                self.createButton({
                    label="+1 Energy", click_function="exchange", function_owner = self,
                    position={0,0.12,1.35}, rotation={0,0,0}, height=280, width=1600,
                    font_color={0,0,0}, font_size=250
                })
            end
            self.UI.setAttribute("filler", "visibility", visiblity)
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
    Global.call("cleanupObject", {obj=enter_object, fear=true, reason="Drowning"})
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
        self.UI.setAttribute("filler", "visibility", "Invisible")
        self.removeButton(0)
    else
        self.UI.setAttribute("filler", "visibility", "")
        self.createButton({
            label="+1 Energy", click_function="exchange", function_owner = self,
            position={0,0.12,1.35}, rotation={0,0,0}, height=280, width=1600,
            font_color={0,0,0}, font_size=250
        })
    end
    self.UI.setAttribute("toggleExchange", "isOn", autoExchange)
end
function exchange(_, color, alt_click)
    local spiritColor = Global.call("getSpiritColor", {name = "Ocean's Hungry Grasp"})
    if spiritColor == nil then
        Player[color].broadcast("Unable to find Ocean's Hungry Grasp", Color.Red)
        return
    end
    local numPlayers = Global.getVar("numPlayers")

    if alt_click then
        local success = Global.call("giveEnergy", {color=spiritColor, energy=-1, ignoreDebt=false})
        if success then
            healthCount = healthCount + numPlayers
            self.UI.setAttribute("count", "text", healthCount)
        else
            Player[color].broadcast("Unable to refund exchanged energy", Color.Red)
        end
    else
        if numPlayers <= healthCount then
            local success = Global.call("giveEnergy", {color=spiritColor, energy=1, ignoreDebt=false})
            if success then
                healthCount = healthCount - numPlayers
                self.UI.setAttribute("count", "text", healthCount)
            else
                Player[color].broadcast("Unable to give exchanged energy", Color.Red)
            end
        else
            Player[color].broadcast("Not enough Health worth of Invaders currently to exchange into Energy", Color.Red)
        end
    end
end

function exchangeAuto()
    local numPlayers = Global.getVar("numPlayers")
    local energy = healthCount / numPlayers
    if energy == 0 then return end
    local color = Global.call("getSpiritColor", {name = "Ocean's Hungry Grasp"})
    local success = Global.call("giveEnergy", {color=color, energy=energy, ignoreDebt=false})
    if success then
        healthCount = healthCount % numPlayers
    else
        broadcastToAll("Unable to find Ocean player to give exchanged Energy to", Color.Red)
    end
end
