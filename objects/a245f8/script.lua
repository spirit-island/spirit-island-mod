size = 600
offset = {0,2.5,-1.3}
rotation = {220,180,180}
color = {0.95,0.95,0.95}

local callbackObj, callbackFunc

function onLoad(saved_data)
    upd()
end
function onObjectEnterContainer(container, enter_object)
    if container == self then upd() end
end
function onObjectLeaveContainer(container, leave_object)
    if container == self then upd() end
end
function upd()
    self.clearButtons()
    if self.getCustomObject().type == 7 then return end
    self.createButton({
        click_function = "nullFunc",
        function_owner = self,
        label          = #self.getObjects(),
        position       = offset,
        rotation       = rotation,
        scale          = {1,1,1},
        width          = 0,
        height         = 0,
        font_size      = size,
        font_color     = color,
    })
    if #self.getObjects() == 0 and Global.getVar("gameStarted") then broadcastToAll("City Bag is now empty", {1,0.4,0}) end
    if callbackObj ~= nil and callbackFunc ~= nil then
        callbackObj.call(callbackFunc, {count=#self.getObjects()})
    end
end

function setCallback(params)
    callbackObj = params.obj
    callbackFunc = params.func
end