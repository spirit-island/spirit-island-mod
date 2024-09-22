empty = false
contents = {
    ["d667fe"] = {{105.21, 0.96, 58.65}, {90, 0, 0}},  --info text
    ["02413e"] = {{105.20, 1.00, 42.87}, {0, 180, 0}}, --spirit editor
    ["76f826"] = {{99.90, 0.80, 36.31}, {0, 180, 0}},  --reminder markers
    ["861b95"] = {{103.43, 0.80, 36.31}, {0, 180, 0}}, --element markers
    ["dc8f37"] = {{106.99, 0.80, 36.31}, {0, 180, 0}}, --energy markers
    ["3d8fa9"] = {{110.72, 0.80, 36.31}, {0, 180, 0}}, --threshold markers
    ["9207a4"] = {{105.20, 1.00, 24.95}, {0, 180, 0}}, --power editor
    ["d7a008"] = {{103.44, 0.80, 21.50}, {0, 180, 0}}, --reminder markers
    ["65aa06"] = {{106.99, 0.80, 21.50}, {0, 180, 0}}, --threshold markers
    ["53669a"] = {{105.20, 1.00, 9.77}, {0, 180, 0}},  --blight card editor
}
otherBags = {"9f84fc","029995","f42a3e"}

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
    local label = "Show\nSpirit & Card\nEditors"
    if empty then
        label = "Hide\nSpirit & Card\nEditors"
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
	local rotation
        for _, bagObject in pairs(self.getObjects()) do
            self.takeObject({
                guid = bagObject.guid,
                position = contents[bagObject.guid][1],
                rotation = contents[bagObject.guid][2],
                callback_function = function(obj)
		    obj.setLock(true)
		    objectsMoved = objectsMoved + 1
		    obj.setPosition(contents[bagObject.guid][1])
		    obj.setRotation(contents[bagObject.guid][2])
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
