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

            self.createButton({
                label="+1 Energy", click_function="energy", function_owner = self,
                position={0,0.12,1.35}, rotation={0,0,0}, height=280, width=1600,
                font_color={0,0,0}, font_size=250
            })
            self.createButton({
                label="Repeat Power", click_function="repeatPower", function_owner = self,
                position={0,0.12,2.05}, rotation={0,0,0}, height=280, width=1600,
                font_color={0,0,0}, font_size=250
            })

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

    self.createButton({
        label="+1 Energy", click_function="energy", function_owner = self,
        position={0,0.12,1.35}, rotation={0,0,0}, height=280, width=1600,
        font_color={0,0,0}, font_size=250
    })
    self.createButton({
        label="Repeat Power", click_function="repeatPower", function_owner = self,
        position={0,0.12,2.05}, rotation={0,0,0}, height=280, width=1600,
        font_color={0,0,0}, font_size=250
    })

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

function energy(_, color, alt_click)
    local spiritColor = Global.call("getSpiritColor", {name = "Downpour Drenches the World"})
    if spiritColor == nil then
        Player[color].broadcast("Unable to find Downpour Drenches the World", Color.Red)
        return
    end

    if alt_click then
        if count > 0 then
            local success = Global.call("giveEnergy", {color=spiritColor, energy=-1, ignoreDebt=false})
            if success then
                count = count - 1
                self.UI.setAttribute("count", "text", count)
            else
                Player[color].broadcast("Unable to refund exchanged energy", Color.Red)
            end
        else
            Player[color].broadcast("Pour Down Across the Island has not been used", Color.Red)
        end
    else
        local max = tonumber(self.UI.getAttribute("water", "text"))
        if count < max then
            local success = Global.call("giveEnergy", {color=spiritColor, energy=1, ignoreDebt=false})
            if success then
                count = count + 1
                self.UI.setAttribute("count", "text", count)
            else
                Player[color].broadcast("Unable to give exchanged energy", Color.Red)
            end
        else
            Player[color].broadcast("No uses of Pour Down Across the Island remaining", Color.Red)
        end
    end
end
function repeatPower(_, color, alt_click)
    if alt_click then
        if count > 0 then
            count = count - 1
            self.UI.setAttribute("count", "text", count)
        else
            Player[color].broadcast("Pour Down Across the Island has not been used", Color.Red)
        end
    else
        local max = tonumber(self.UI.getAttribute("water", "text"))
        if count < max then
            count = count + 1
            self.UI.setAttribute("count", "text", count)
        else
            Player[color].broadcast("No uses of Pour Down Across the Island remaining", Color.Red)
        end
    end
end
