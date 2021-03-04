empty = false
contents = {
    ["8616a2"] = {105.02, 0.85, 54.06},
    ["4a3136"] = {101.10, 0.86, 42.86},
    ["a9a196"] = {108.38, 0.85, 42.84},
}

function onLoad()
    self.interactable = false
    if #self.getObjects() == 0 then
        empty = true
    end
    self.createButton({
        click_function = "toggleObjects",
        function_owner = self,
        label = "",
        position = {0,1.5,0},
        rotation = {0,180,0},
        width = 1000,
        height = 750,
        font_size = 300,
    })
    updateButton()
end

function updateButton()
    local label = "Show\nEditors"
    if empty then
        label = "Hide\nEditors"
    end
    self.editButton({
        index = 0,
        label = label,
        width = 1000,
        height = 750,
    })
end

function clearButton()
    self.editButton({
        index = 0,
        label = "",
        width = 0,
        height = 0,
    })
end

function toggleObjects()
    clearButton()
    local objectsMoved = 0
    local count = 0
    if empty then
        for guid,_ in pairs(contents) do
            local obj = getObjectFromGUID(guid)
            if obj ~= nil and obj.getLock() then
                obj.setLock(false)
                self.putObject(obj)
                count = count + 1
                objectsMoved = objectsMoved + 1
            end
        end
        empty = false
    else
        for _, bagObject in pairs(self.getObjects()) do
            self.takeObject({
                guid = bagObject.guid,
                position = contents[bagObject.guid],
                rotation = {0,180,0},
                callback_function = function(obj) obj.setLock(true) objectsMoved = objectsMoved + 1 end,
            })
            count = count + 1
        end
        empty = true
    end
    local timerID
    timerID = Wait.time(function()
        if count == objectsMoved then
            updateButton()
            Wait.stop(timerID)
        end
    end, 1, -1)
end