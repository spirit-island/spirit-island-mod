local count = 0

function onSave()
    local data_table = {
        count = count
    }
    return JSON.encode(data_table)
end
function onLoad(save_state)
    if Global.getVar("gameStarted") then
        if save_state ~= "" then
            local loaded_data = JSON.decode(save_state)
            count = loaded_data.count
        end
        Wait.frames(function()
            self.UI.setAttribute("count", "text", count)
            self.UI.setAttribute("water", "text", 0)
            self.UI.setAttribute("waterPanel", "visibility", "")
            self.UI.setAttribute("waterPanel2", "visibility", "")

            Wait.time(countWater, 2, -1)
        end, 2)
    end
end

function doSetup(params)
    if not Global.getVar("gameStarted") then
        return
    end
    self.UI.setAttribute("count", "text", count)
    self.UI.setAttribute("water", "text", 0)
    self.UI.setAttribute("waterPanel", "visibility", "")
    self.UI.setAttribute("waterPanel2", "visibility", "")

    Wait.time(countWater, 2, -1)
end
function timePasses()
    count = 0
    self.UI.setAttribute("count", "text", count)
end

function countWater()
    local color = Global.call("getSpiritColor", {name = "Downpour Drenches the World"})
    if color == nil then
        return
    end

    local water = Global.getTable("selectedColors")[color].elements[5].getButtons()[1].label
    water = math.min(math.floor(tonumber(water) / 2), 5)
    self.UI.setAttribute("water", "text", water)
end

function energy(player, _, _)
    local max = tonumber(self.UI.getAttribute("water", "text"))
    if count < max then
        local color = Global.call("getSpiritColor", {name = "Downpour Drenches the World"})
        local success = Global.call("giveEnergy", {color=color, energy=1})
        if success then
            count = count + 1
            self.UI.setAttribute("count", "text", count)
        else
            Player[player.color].broadcast("Unable to find Downpour player to give exchanged energy to", Color.Red)
        end
    else
        Player[player.color].broadcast("No uses of Pour Down Across the Island remaining", Color.Red)
    end
end
function repeatPower(player, _, _)
    local max = tonumber(self.UI.getAttribute("water", "text"))
    if count < max then
        count = count + 1
        self.UI.setAttribute("count", "text", count)
    else
        Player[player.color].broadcast("No uses of Pour Down Across the Island remaining", Color.Red)
    end
end
