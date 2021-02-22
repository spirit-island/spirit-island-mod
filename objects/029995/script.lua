empty = false
contents = {
    -- JE Reminders
    ["932d66"] = {{-69.67, 0.99, -20.18},{0.00, 180.00, 0.00}},
    ["6ff60a"] = {{-66.18, 0.99, -20.18},{0.00, 180.00, 0.00}},
    ["d986c8"] = {{-62.69, 0.99, -20.18},{0.00, 180.00, 0.00}},
    ["ec5eb3"] = {{-73.17, 0.99, -20.18},{0.00, 180.00, 0.00}},
    ["715233"] = {{-59.19, 0.99, -20.18},{0.00, 180.00, 0.00}},
    -- Aid Cards
    ["b16225"] = {{-57.56, 0.98, -16.47},{0.00, 180.00, 180.00}},
    ["e3a850"] = {{-64.25, 0.98, -16.47},{0.00, 180.00, 0.00}},
    ["d1de40"] = {{-70.93, 0.98, -16.47},{0.00, 180.00, 180.00}},
    ["1e477e"] = {{-74.27, 0.98, -16.47},{0.00, 180.00, 0.00}},
    ["e58dc4"] = {{-67.59, 0.98, -16.47},{0.00, 180.00, 180.00}},
    ["49913c"] = {{-60.91, 0.98, -16.47},{0.00, 180.00, 0.00}},
--    [""] = {{},{0.00, 180.00, 0.00}},
  --  [""] = {{},{0.00, 180.00, 0.00}},
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
        width = 1400,
        height = 750,
        font_size = 300,
    })
    updateButton()
end

function updateButton()
    local label = "Show\nReminders"
    if empty then
        label = "Hide\nReminders"
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
        for _, bagObject in pairs(self.getObjects()) do
            self.takeObject({
                guid = bagObject.guid,
                position = contents[bagObject.guid][1],
                rotation = contents[bagObject.guid][2],
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
