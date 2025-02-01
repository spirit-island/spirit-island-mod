local rescan
local currentSpirit

function onLoad()
    self.createButton({
        click_function = "nullFunc",
        label = "Place Spirit Panel Here",
        font_color = {1,1,1},
        font_size = 300,
        position = {0,0.1,0},
        width = 0,
        height = 0,
    })
    Color.Add("SoftBlue", Color.new(0.53,0.92,1))
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
    Wait.time(scan, 0.5, -1)
    rescan = false
end

function scan()
    local objs = upCast(self, 1, 0, {"Tile"})
    if #objs ~= 1 then
        clearButtons()
        return
    end
    currentSpirit = objs[1]
    if rescan or #self.getButtons() == 1 then
        rescan = false
        createButtons(currentSpirit)
    end
end

function clearButtons()
    local buttons = self.getButtons()
    for i=2,#buttons do
        self.removeButton(buttons[i].index)
    end
end

function createButtons(obj)
    if not obj.hasTag("Spirit") then
        self.createButton({
            click_function = "button1",
            function_owner = self,
            label          = "Validate\nSpirit Panel",
            position       = {0,0.6,0},
            width          = 4000,
            height         = 1800,
            font_size      = 600,
        })
    end

    local func = function() makeSpirit(obj) end
    self.setVar("button1",func)
end

---
local Elements = {}
Elements.__index = Elements
function Elements:new(init)
    local outTable = {0,0,0,0,0,0,0,0}
    setmetatable(outTable, self)
    outTable:add(init)
    return outTable
end
function Elements:add(other)
    if other == nil then
        return
    elseif type(other) == "table" then
        for i = 1, 8 do
            self[i] = self[i] + other[i]
        end
    elseif type(other) == "string" then
        for i = 1, string.len(other) do
            self[i] = self[i] + math.floor(string.sub(other, i, i))
        end
    end
end
function Elements:__tostring()
    return table.concat(self, "")
end
---

local function round(val, quantum)
    return math.floor(val/quantum+0.5)*quantum
end

function updateElements(player)
    if currentSpirit == nil then
        return
    end
    local hits = upCast(currentSpirit, 1, 0, {"Generic"})
    local trackElements = {}
    local function insert(position, elements)
        for _, entry in pairs(trackElements) do
            if entry.position == position then
                entry.elements:add(elements)
                return
            end
        end
        table.insert(trackElements, {
            position=position,
            elements=Elements:new(elements)
        })
    end
    for _, entry in pairs(hits) do
        if entry.getVar("elements") ~= nil then
            local pos = currentSpirit.positionToLocal(entry.getPosition())
            pos = Vector(round(pos.x,0.01), 0, round(pos.z,0.01))
            insert(pos, entry.getVar("elements"))
            entry.destroy()
        end
    end
    for _, trackElement in pairs(trackElements) do
        trackElement.elements = tostring(trackElement.elements)
    end
    table.sort(trackElements, function (a, b) return a.position.x < b.position.x or (a.position.x == b.position.x and a.position.z < a.position.z) end)
    local state = {}
    if currentSpirit.script_state ~= "" then
        state = JSON.decode(currentSpirit.script_state)
    end
    state.trackElements = trackElements
    currentSpirit.script_state = JSON.encode(state)
    currentSpirit.setTable("trackElements", trackElements)
    player.broadcast("Updated Elements for " .. currentSpirit.getName(), Color.SoftBlue)
end

function populateElements()
    if currentSpirit == nil then
        return
    end
    local trackElements = currentSpirit.getTable("trackElements")
    if trackElements == nil then
        return
    end
    local anyBag = getObjectFromGUID("861b95")
    for _, trackElement in pairs(trackElements) do
        local elements = Elements:new(trackElement.elements)
        local position = currentSpirit.positionToWorld(trackElement.position)
        for i, count in ipairs(elements) do
            for j = 1, count do
                anyBag.takeObject{
                    position = position + j * Vector(0, 1, 0),
                    callback_function = function(obj) obj.setState(i) end,
                }
            end
        end
    end
end

function updateEnergy(player)
    if currentSpirit == nil then
        return
    end
    local hits = upCast(currentSpirit, 1, 0, {"Generic"}, "Energy Marker")
    local trackEnergy = {}
    local bonusEnergy = {}
    for _, hit in pairs(hits) do
        local pos = currentSpirit.positionToLocal(hit.getPosition())
        pos = Vector(round(pos.x,0.01), 0, round(pos.z,0.01))
        local count = JSON.decode(hit.script_state).count
	local bonus = JSON.decode(hit.script_state).bonusMode
	if bonus then
        table.insert(bonusEnergy, {
            position = pos,
            count = count
        })
	else
        table.insert(trackEnergy, {
            position = pos,
            count = count
        })
	end
        hit.destroy()
    end
    table.sort(trackEnergy, function (a, b) return a.count > b.count or (a.count == b.count and a.position.x < b.position.x) or (a.count == b.count and a.position.x == b.position.x and a.position.z < a.position.z) end)
    table.sort(bonusEnergy, function (a, b) return a.count > b.count or (a.count == b.count and a.position.x < b.position.x) or (a.count == b.count and a.position.x == b.position.x and a.position.z < a.position.z) end)
    local state = {}
    if currentSpirit.script_state ~= "" then
        state = JSON.decode(currentSpirit.script_state)
    end
    currentSpirit.script_state = JSON.encode(state)
    currentSpirit.setTable("trackEnergy", trackEnergy)
    currentSpirit.setTable("bonusEnergy", bonusEnergy)
    player.broadcast("Updated Energy for " .. currentSpirit.getName(), Color.SoftBlue)
end

function populateEnergy()
    if currentSpirit == nil then
        return
    end
    local trackEnergy = currentSpirit.getTable("trackEnergy")
    local bonusEnergy = currentSpirit.getTable("bonusEnergy")
    if trackEnergy == nil and bonusEnergy == nil then
        return
    end
    local energyBag = getObjectFromGUID("dc8f37")
    local function takeEnergyObject(position, count, bonusMode)
        energyBag.takeObject({
            position = position + Vector(0, 1, 0),
            callback_function = function(obj)
                local newScriptState = {
                    count = count,
                    bonusMode = bonusMode
                }
                local encodedState = JSON.encode(newScriptState)
                obj.script_state = encodedState
                obj.call("onLoad")
            end,
        })
    end
    for _, energyTable in pairs(trackEnergy) do
	local position = currentSpirit.positionToWorld(energyTable.position)
	local count = energyTable.count
	takeEnergyObject(position, count, false)
    end
    for _, energyTable in pairs(bonusEnergy) do
        local position = currentSpirit.positionToWorld(energyTable.position)
        local count = energyTable.count
        takeEnergyObject(position, count, true)
    end
end

function updateThreshold(player)
    if currentSpirit == nil then
        return
    end

    local thresholds = {}
    local hits = upCast(currentSpirit, 1, 0, {"Generic"}, "Threshold Marker")
    for _, hit in pairs(hits) do
        local pos = currentSpirit.positionToLocal(hit.getPosition())
        pos = Vector(round(pos.x,0.01), 0, round(pos.z,0.01))
        local elements = tableToString(JSON.decode(hit.script_state).threshold)
        table.insert(thresholds, {
            position = pos,
            elements = elements
        })
        hit.destroy()
    end
    table.sort(thresholds, function (a, b) return a.position.x > b.position.x or (a.position.x == b.position.x and a.position.z < b.position.z) end)
    local state = {}
    if currentSpirit.script_state ~= "" then
        state = JSON.decode(currentSpirit.script_state)
    end
    state.thresholds = thresholds
    currentSpirit.script_state = JSON.encode(state)
    currentSpirit.setTable("thresholds", thresholds)

    player.broadcast("Updated Elemental Thresholds for " .. currentSpirit.getName(), Color.SoftBlue)
end

function populateThreshold()
    if currentSpirit == nil then
        return
    end
    local thresholds = currentSpirit.getTable("thresholds")
    if thresholds == nil then
        return
    end
    local thresholdBag = getObjectFromGUID("3d8fa9")
    for _, threshold in pairs(thresholds) do
        local position = currentSpirit.positionToWorld(threshold.position)
	local thresholdTable = stringToTable(threshold.elements)
        thresholdBag.takeObject({
            position = position + Vector(0, 1, 0),
            callback_function = function(obj)
                local newScriptState = {
                    threshold = thresholdTable,
                    editMode = true
                }
                obj.script_state = JSON.encode(newScriptState)
                obj.call("onLoad")
            end,
        })
    end
end

function updateReminder(player)
    if currentSpirit == nil then
        return
    end
    local hits = upCast(currentSpirit, 1, 0, {"Generic"}, "Reminder Marker")
    local location = nil
    for _, entry in pairs(hits) do
        location = entry.call("getImageLocation", {obj = currentSpirit})
        entry.destroy()
    end

    local state = {}
    if currentSpirit.script_state ~= "" then
        state = JSON.decode(currentSpirit.script_state)
    end
    state.reminder = location
    currentSpirit.script_state = JSON.encode(state)

    local opString = "Updated"
    if location == nil then
        opString = "Reset"
    end
    player.broadcast(opString .. " Reminder for " .. currentSpirit.getName(), Color.SoftBlue)
end

function populateReminder(player)
    if currentSpirit == nil then
        return
    end
    local location = Global.call("getReminderLocation", {obj = currentSpirit})
    if location == nil then
        return
    end

    if (location.field == "ImageURL" and currentSpirit.is_face_down) or (location.field == "ImageSecondaryURL" and not currentSpirit.is_face_down) then
        player.broadcast("Flip the Spirit Panel first", Color.SoftYellow)
        return
    end

    local reminderBag = getObjectFromGUID("76f826")
    reminderBag.takeObject{
        smooth = false,
        callback_function = function(obj)
             Wait.frames(function()
                 obj.call("setToLocation", {obj = currentSpirit, location = location})
             end, 1)
        end,
    }
end

function makeSpirit(obj)
    obj.addTag("Spirit")
    obj.setVar("reload", true)
    obj = obj.reload()
    obj.setVar("reload", true)
    rescan = true
    scan()
end

function upCast(obj,dist,offset,types,name)
    dist = dist or 1
    offset = offset or 0
    local hits = Physics.cast({
        origin       = obj.getPosition() + Vector(0,offset,0),
        direction    = Vector(0,1,0),
        type         = 3,
        size         = obj.getBounds().size,
        orientation  = obj.getRotation(),
        max_distance = dist,
        -- debug        = true,
    })
    local hitObjects = {}
    for _,v in pairs(hits) do
        local matchesType = false
        if types ~= nil then
            for _,t in pairs(types) do
                if v.hit_object.type == t then
                    matchesType = true
                    break
                end
            end
        else
            matchesType = true
        end

        local matchesName = false
        if name ~= nil then
            if v.hit_object.getName() == name then
                matchesName = true
            end
        else
            matchesName = true
        end

        if matchesType and matchesName then
            table.insert(hitObjects,v.hit_object)
        end
    end
    return hitObjects
end

function tableToString(tbl)
    if type(tbl) ~= "table" then
        return tostring(tbl)
    end
    local result = ""
    for _, val in pairs(tbl) do
        result = result..tableToString(val)
    end
    return result
end

function stringToTable(str)
    local tbl = {}
    for i = 1, #str do
        local char = string.sub(str, i, i)  -- Get each character in the string
        table.insert(tbl, tonumber(char))  -- Convert character to number and insert into table
    end
    return tbl
end
