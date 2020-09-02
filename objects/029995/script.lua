empty = false
contents = {
    -- JE Reminders
    ["932d66"] = {{-94.95, 0.90, -31.06},{0.00, 180.00, 0.00}},
    ["6ff60a"] = {{-87.67, 0.90, -31.06},{0.00, 180.00, 0.00}},
    ["d986c8"] = {{-80.39, 0.90, -31.06},{0.00, 180.00, 0.00}},
    ["ec5eb3"] = {{-73.11, 0.90, -31.06},{0.00, 180.00, 0.00}},
    ["715233"] = {{-65.83, 0.90, -31.06},{0.00, 180.00, 0.00}},
    -- Aid Cards
    ["b16225"] = {{-96.12, 0.90, -37.21},{0.00, 180.00, 180.00}},
    ["e3a850"] = {{-91.03, 0.91, -37.22},{0.00, 180.00, 0.00}},
    ["d1de40"] = {{-86.08, 0.90, -37.21},{0.00, 180.00, 180.00}},
    ["1e477e"] = {{-80.97, 0.90, -37.22},{0.00, 180.00, 0.00}},
    ["e58dc4"] = {{-75.89, 0.90, -37.30},{0.00, 180.00, 180.00}},
    ["49913c"] = {{-70.86, 0.90, -37.22},{0.00, 180.00, 0.00}},
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
    label = "Show\nReminders"
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
            if obj ~= nil then
                obj.setLock(false)
                self.putObject(obj)
                count = count + 1
                objectsMoved = objectsMoved + 1
            end
        end
        empty = false
    else
        for _,obj in pairs(self.getObjects()) do
            self.takeObject({
                guid = obj.guid,
                position = contents[obj.guid][1],
                rotation = contents[obj.guid][2],
                callback_function = function(obj) obj.setLock(true) objectsMoved = objectsMoved + 1 end,
            })
            count = count + 1
        end
        empty = true
    end
    timerID = Wait.time(function()
        if count == objectsMoved then
            updateButton()
            Wait.stop(timerID)
        end
    end, 1, -1)
end