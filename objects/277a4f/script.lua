empty = false
contents = {
    ["1b39da"] = {{-94.95, 0.90, -15.94},{0.00, 180.00, 180.00}},
    ["04397d"] = {{-87.67, 0.90, -15.94},{0.00, 180.00, 180.00}},
    ["7ac013"] = {{-80.39, 0.90, -15.94},{0.00, 180.00, 180.00}},
    ["ee90ad"] = {{-73.18, 0.90, -15.95},{0.00, 180.00, 180.00}},
    ["bd528e"] = {{-94.95, 0.90, -20.98},{0.00, 180.00, 180.00}},
    ["ca88f0"] = {{-87.67, 0.90, -20.98},{0.00, 180.00, 180.00}},
    ["a69e8c"] = {{-80.39, 0.90, -20.98},{0.00, 180.00, 180.00}},
    ["e924fe"] = {{-73.14, 0.90, -20.98},{0.00, 180.00, 180.00}},
    ["5a95bc"] = {{-94.95, 0.90, -26.02},{0.00, 180.00, 180.00}},
    ["b8b521"] = {{-87.67, 0.90, -26.02},{0.00, 180.00, 180.00}},
    ["ec49d4"] = {{-80.39, 0.90, -26.02},{0.00, 180.00, 180.00}},
    ["64caee"] = {{-73.11, 0.90, -26.02},{0.00, 180.00, 180.00}},
    ["3d1ba3"] = {{-65.83, 0.90, -26.02},{0.00, 180.00, 180.00}},
    --Scenario Markers
    ["0841e7"] = {{-68.66, 0.84, -16.96},{0.00, 180.00, 0.00}},
    ["5bd914"] = {{-68.53, 0.89, -18.85},{0.00, 180.00, 0.00}},
    ["eae635"] = {{-66.69, 0.89, -18.85},{0.00, 180.00, 0.00}},
    ["ab2c31"] = {{-64.85, 0.89, -18.85},{0.00, 180.00, 0.00}},
    ["bb67a0"] = {{-63.01, 0.89, -18.85},{0.00, 180.00, 0.00}},
    ["d17e1d"] = {{-68.59, 0.89, -20.72},{0.00, 180.00, 0.00}},
    ["9d73e5"] = {{-66.75, 0.89, -20.72},{0.00, 180.00, 0.00}},
    ["845abc"] = {{-64.92, 0.89, -20.72},{0.00, 180.00, 0.00}},
    ["1549ea"] = {{-63.08, 0.89, -20.72},{0.00, 180.00, 0.00}},
    --[""] = {{-68.44, 0.89, -22.61},{0.00, 180.00, 0.00}},
    --[""] = {{-66.60, 0.89, -22.61},{0.00, 180.00, 0.00}},
    --[""] = {{-64.77, 0.89, -22.61},{0.00, 180.00, 0.00}},
    --[""] = {{-62.93, 0.89, -22.61},{0.00, 180.00, 0.00}},
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
    label = "Show\nScenarios"
    if empty then
        label = "Hide\nScenarios"
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