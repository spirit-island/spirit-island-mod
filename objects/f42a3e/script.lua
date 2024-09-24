empty = false
contents = {
    ["0bbd0c"] = {{105.23, 0.96, 58.65}, {90, 0, 0}},  --text
    ["a15998"] = {{105.21, 0.85, 34.91}, {0, 180, 0}}, --island editor
    ["cd370a"] = {{100.00, 0.80, 23.67}, {0, 180, 0}}, --defend
    ["85225b"] = {{101.92, 0.80, 23.67}, {0, 180, 0}}, --explorer
    ["78540e"] = {{103.84, 0.80, 23.67}, {0, 180, 0}}, --town
    ["f4eb76"] = {{105.74, 0.80, 23.67}, {0, 180, 0}}, --city
    ["b14600"] = {{107.62, 1.22, 23.67}, {0, 180, 0}}, --dahan
    ["f60888"] = {{109.56, 0.80, 23.67}, {0, 180, 0}}, --blight
    ["cb11a0"] = {{100.88, 0.80, 22.04}, {0, 180, 0}}, --beasts
    ["150475"] = {{102.79, 0.80, 22.04}, {0, 180, 0}}, --badlands
    ["bc12de"] = {{104.70, 0.80, 22.04}, {0, 180, 0}}, --wilds
    ["af56a7"] = {{106.60, 0.80, 22.04}, {0, 180, 0}}, --disease
    ["7fb430"] = {{108.51, 0.80, 22.04}, {0, 180, 0}}, --strife
    ["ae9812"] = {{110.42, 0.80, 22.04}, {0, 180, 0}}, --vitality
}
otherBags = {"9f84fc","029995","Editors"}

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
        width = 1700,
        height = 1000,
        font_size = 300,
    })
    updateButton()
end

function updateButton()
    local label = "Show\nIsland Board\nEdtior"
    if empty then
        label = "Hide\nIsland Board\nEditor"
    end
    self.editButton({
        index = 0,
        label = label,
        width = 1700,
        height = 1000,
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
            local pos = contents[bagObject.guid][1]
            local rot = contents[bagObject.guid][2]
            self.takeObject({
                guid = bagObject.guid,
                position = pos,
                rotation = rot,
                callback_function = function(obj)
                    obj.setLock(true)
                    objectsMoved = objectsMoved + 1
                    obj.setPosition(pos)
                    obj.setRotation(rot)
                    end,
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
