function onObjectLeaveContainer(container, leave_object)
    if container == self then
        upd()
        if leave_object.getName() == "Blight" then
            if #self.getObjects() == 0 then
                broadcastToAll("Blight Container is now empty", {1,0.4,0})
            end
        end
    end
end
function onObjectEnterContainer(container, enter_object)
    if container == self then upd() end
end

function onLoad(saved_data)
    self.createButton({
        click_function = "nullFunc",
        function_owner = self,
        label          = #self.getObjects(),
        position       = {2.0,0.1,0},
        rotation       = {180,180,180},
        scale          = {2,2,2},
        width          = 0,
        height         = 0,
        font_size      = 500,
        font_color     = {0,0,0},
    })
    UI.setAttribute("panelBlightPool", "text", #self.getObjects())
end
function upd()
    self.editButton({
        index = 0,
        label = #self.getObjects(),
    })
    UI.setAttribute("panelBlightPool", "text", #self.getObjects())
end
function nullFunc() return end
