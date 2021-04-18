function onObjectLeaveContainer(container, leave_object)
    if container == self then
        upd()
        if leave_object.getName() == "Blight" then
            if #self.getObjects() == 0 then
                if Global.getVar("blightedIsland") then
                    broadcastToAll("Blight Container is now empty", "Red")
                    broadcastToAll("Invaders win via Blight Loss Condition!", "Red")
                else
                    broadcastToAll("Blight Container is now empty", {1,0.4,0})
                end
            end
        end
    end
end
function onObjectEnterContainer(container, enter_object)
    if container == self then upd() end
end

function onLoad(saved_data)
    local count = #self.getObjects()
    self.createButton({
        click_function = "nullFunc",
        function_owner = self,
        label          = count,
        position       = {2.0,0.1,0},
        rotation       = {180,180,180},
        scale          = {2,2,2},
        width          = 0,
        height         = 0,
        font_size      = 500,
        font_color     = {0,0,0},
    })
    UI.setAttribute("panelBlightPool", "text", count)
    local active
    if count == 0 and not Global.getVar("blightedIsland") then
        active = true
    else
        active = false
    end
    UI.setAttribute("panelBlightButton", "active", active)
end
function upd()
    local count = #self.getObjects()
    self.editButton({
        index = 0,
        label = count,
    })
    UI.setAttribute("panelBlightPool", "text", count)
    local active
    if count == 0 and not Global.getVar("blightedIsland") then
        active = true
    else
        active = false
    end
    UI.setAttribute("panelBlightButton", "active", active)
end
function nullFunc() return end