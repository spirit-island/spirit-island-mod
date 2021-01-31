function onObjectLeaveContainer(container, leave_object)
    if container == self then upd() end
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
end
function upd()
    self.editButton({
        index = 0,
        label = #self.getObjects(),
    })
    if callbackObj ~= nil and callbackFunc ~= nil then
        callbackObj.call(callbackFunc, {count=#self.getObjects()})
    end
end

function setCallback(params)
    callbackObj = params.obj
    callbackFunc = params.func
end
function nullFunc() return end