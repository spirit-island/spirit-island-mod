empty = false
contents = {
    ["a39453"] = {102.50, 0.80, 54.50},
    ["e0d42d"] = {110.50, 0.80, 54.50},
    ["640292"] = {102.50, 0.80, 44.00},
    ["2fd45e"] = {111.60, 0.80, 44.0},
    ["3bc101"] = {105.00, 0.80, 33.50},
    ["b67827"] = {105.00, 0.80, 23.00},
}
otherBags = {"Editors","f42a3e"}

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
        width = 1400,
        height = 750,
        font_size = 300,
    })
    updateButton()
end

function updateButton()
    local label = "Show\nRulebooks"
    if empty then
        label = "Hide\nRulebooks"
    end
    self.editButton({
        index = 0,
        label = label,
        width = 1400,
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
        toggleBags()
        for _, bagObject in pairs(self.getObjects()) do
            self.takeObject({
                guid = bagObject.guid,
                position = contents[bagObject.guid],
                rotation = {0,180,0},
                smooth = false,
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

function toggleBags()
    for _,otherBagGUID in pairs(otherBags) do
        local otherBag = getObjectFromGUID(otherBagGUID)
        if otherBag.getVar("empty") then
          otherBag.call("toggleObjects")
        end
    end
end
