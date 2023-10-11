empty = false
contents = {
    ["SpiritEditor"] = {105.22, 0.85, 52.59},
    ["Reminder"] = {115.645, 0.95, 59.34},
    ["AnyElements"] = {114.81, 0.95, 54.39},
    ["Energy"] = {116.48, 0.95, 54.39},
    ["Threshold"] = {114.81, 0.95, 49.44},
    ["SmallElements"] = {116.48, 0.95, 49.44},
    ["BlightCardEditor"] = {98.98, 0.85, 42.86},
    ["PowerEditor"] = {109.33, 0.85, 42.86},
}
playerAids = "029995"
rulebooks = "9f84fc"

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
        toggleBags()
        for _, bagObject in pairs(self.getObjects()) do
            self.takeObject({
                guid = bagObject.guid,
                position = contents[bagObject.guid],
                rotation = {0,180,0},
                callback_function = function(obj) obj.setLock(true) objectsMoved = objectsMoved + 1 obj.setPosition(contents[bagObject.guid]) end,
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
    local playerAidsBag = getObjectFromGUID(playerAids)
    if playerAidsBag.getVar("empty") then
        playerAidsBag.call("toggleObjects")
    end

    local rulebooksBag = getObjectFromGUID(rulebooks)
    if rulebooksBag.getVar("empty") then
        rulebooksBag.call("toggleObjects")
    end
end
