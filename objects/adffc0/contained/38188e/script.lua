spiritName = "Ocean's Hungry Grasp"

local healthCount = 0
local autoExchange = true

function onSave()
    -- We must build on the existing script state, to avoid overwriting setupComplete
    local data_table = {}
    if self.script_state ~= "" then
        data_table = JSON.decode(self.script_state)
    end
    data_table.healthCount = healthCount
    data_table.autoExchange = autoExchange
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
            self.UI.setAttribute("players", "text", getNumPlayers())
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
    Global.call("cleanupObject", {obj=enter_object, fear=true, color=enter_object.getVar("color"), reason="Drowning"})
    return false
end

function doSetup(params)
    self.UI.setAttribute("count", "text", healthCount)
    self.UI.setAttribute("players", "text", getNumPlayers())
    self.UI.setAttribute("drownPanel", "visibility", "")
    self.UI.setAttribute("drownPanel2", "visibility", "")
    return true
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
    self.UI.setAttribute("players", "text", getNumPlayers())
    self.UI.setAttribute("toggleExchange", "isOn", autoExchange)
end
function exchange(_, color, alt_click)
    local spiritColor = Global.call("getSpiritColor", {name = spiritName})
    if spiritColor == nil then
        Player[color].broadcast("Unable to find "..spiritName.."!", Color.Red)
        return
    end
    local numPlayers = getNumPlayers()

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
    local numPlayers = getNumPlayers()
    local energy = math.floor(healthCount / numPlayers)
    if energy == 0 then return end
    local color = Global.call("getSpiritColor", {name = spiritName})
    if color == nil then
        return
    end
    local success = Global.call("giveEnergy", {color=color, energy=energy, ignoreDebt=false})
    if success then
        healthCount = healthCount % numPlayers
    else
        broadcastToAll("Unable to find Ocean player to give exchanged Energy to", Color.Red)
    end
end

function getNumPlayers()
    local numPlayers = Global.getVar("numPlayers")
    if Global.getVar("SetupChecker").getVar("optionalDrowningCap") then
        if numPlayers > 4 then
            return 4
        end
    end
    return numPlayers
end
