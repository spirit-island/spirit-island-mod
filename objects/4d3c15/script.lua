size = 600
offset = {0,1.5,0}
rotation = {-40,0,0}
color = {0.95,0.95,0.95}

local callbackObj, callbackFunc
local noneCallbackBroadcast

function onSave()
    local data_table = {
        callbackFunc = callbackFunc,
        noneCallbackBroadcast = noneCallbackBroadcast,
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
        noneCallbackBroadcast = loaded_data.noneCallbackBroadcast
    end

    Color.Add("SoftBlue", Color.new(0.53,0.92,1))
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
    noneCallbackBroadcast = params.broadcast
end

function none()
    if noneCallbackBroadcast ~= nil then
        broadcastToAll(noneCallbackBroadcast, Color.SoftYellow)
    end
end
