sourceSpiritID = "SourceSpirit"

local rescan
local currentSpirit

function onLoad()
    self.createButton({
        click_function = "nullFunc",
        label = "Spirit Board\nValidator",
        font_color = {1,1,1},
        position = {0,1,0.65},
        scale = {0.3,0.3,0.5},
        width = 0,
        height = 0,
    })
    Color.Add("SoftBlue", Color.new(0.45,0.6,0.7))
    Wait.time(scan, 0.5, -1)
    rescan = false
end

function scan()
    local objs = upCast(self, 0.4, 0.1, {"Tile"})
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
    if obj.hasTag("Spirit") then
        self.createButton({
            click_function = "nullFunc",
            label          = "Spirit Validated",
            position       = {0,0.1,-0.6},
            scale          = {0.1,0.1,0.1},
            width          = 4800,
            height         = 800,
            font_size      = 600,
        })
    else
        self.createButton({
            click_function = "button1",
            function_owner = self,
            label          = "Make Me A Spirit!",
            position       = {0,0.1,-0.6},
            scale          = {0.1,0.1,0.1},
            width          = 4800,
            height         = 800,
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
    local hits = upCast(currentSpirit, 0.4, 0.1, {"Generic"})
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
    player.broadcast("Updated elements for " .. currentSpirit.getName() .. ".", Color.SoftBlue)
end
function populateElements()
    if currentSpirit == nil then
        return
    end
    local trackElements = currentSpirit.getTable("trackElements")
    if trackElements == nil then
        return
    end
    local anyBag = getObjectFromGUID("AnyElements")
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
    local hits = upCast(currentSpirit, 0.4, 0.1, {"Chip"})
    local trackEnergy = {}
    for _, entry in pairs(hits) do
        local pos = currentSpirit.positionToLocal(entry.getPosition())
        pos = Vector(round(pos.x,0.01), 0, round(pos.z,0.01))

        local quantity = entry.getQuantity()
        if quantity == -1 then
            quantity = 1
        end

        table.insert(trackEnergy, {
            position = pos,
            count = quantity
        })
        entry.destroy()
    end
    table.sort(trackEnergy, function (a, b) return a.count > b.count or (a.count == b.count and a.position.x < b.position.x) or (a.count == b.count and a.position.x == b.position.x and a.position.z < a.position.z) end)
    local state = {}
    if currentSpirit.script_state ~= "" then
        state = JSON.decode(currentSpirit.script_state)
    end
    state.trackEnergy = trackEnergy
    currentSpirit.script_state = JSON.encode(state)
    currentSpirit.setTable("trackEnergy", trackEnergy)
    player.broadcast("Updated energy for " .. currentSpirit.getName() .. ".", Color.SoftBlue)
end
function populateEnergy()
    if currentSpirit == nil then
        return
    end
    local trackEnergy = currentSpirit.getTable("trackEnergy")
    if trackEnergy == nil then
        return
    end
    local energyBag = getObjectFromGUID("Energy")
    for _, energy in pairs(trackEnergy) do
        local position = currentSpirit.positionToWorld(energy.position)
        for i = 1, energy.count do
            energyBag.takeObject({position = position + i * Vector(0, 1, 0)})
        end
    end
end

function makeSpirit(obj)
    obj.addTag("Spirit")
    obj.reload()
    rescan = true
    scan()
end

function upCast(obj,dist,offset,types)
    dist = dist or 1
    offset = offset or 0
    local hits = Physics.cast({
        origin       = obj.getPosition() + Vector(0,offset,0),
        direction    = Vector(0,1,0),
        type         = 3,
        size         = obj.getBoundsNormalized().size,
        orientation  = obj.getRotation(),
        max_distance = dist,
        --debug        = true,
    })
    local hitObjects = {}
    for _,v in pairs(hits) do
        if types ~= nil then
            local matchesType = false
            for _,t in pairs(types) do
                if v.hit_object.type == t then matchesType = true end
            end
            if matchesType then
                table.insert(hitObjects,v.hit_object)
            end
        else
            table.insert(hitObjects,v.hit_object)
        end
    end
    return hitObjects
end
