size = 600
offset = {0,1.5,0}
rotation = {-40,0,0}
color = {0.95,0.95,0.95}

local callbackObj, callbackFunc
local loss

function onSave()
    local data_table = {
        callbackFunc = callbackFunc,
        loss = loss,
    }
    if callbackObj ~= nil then
        data_table.callbackObj = callbackObj.guid
    end
    return JSON.encode(data_table)
end
function onLoad(saved_data)
    local loaded_data = JSON.decode(saved_data)
    if loaded_data ~= nil then
        callbackObj = getObjectFromGUID(loaded_data.callbackObj)
        callbackFunc = loaded_data.callbackFunc
        loss = loaded_data.loss
    end

    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
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
    if #self.getObjects() == 0 and Global.getVar("gameStarted") then broadcastToAll("Town Bag is now empty", Color.SoftYellow) end
    if callbackObj ~= nil and callbackFunc ~= nil then
        callbackObj.call(callbackFunc, {count=#self.getObjects()})
    end
end

function setCallback(params)
    callbackObj = params.obj
    callbackFunc = params.func
    loss = params.loss
end

function none()
    if loss ~= nil then
        Global.call("Defeat", loss)
    end
end
