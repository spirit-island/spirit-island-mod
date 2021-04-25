local serpentGUID = "cebe09"
local serpent
local initialized = false
local playerBlock

local slumberTrack = {[0] = 5, 7, 8, 10, 11, 12, 13}
local slumberPoints = {
    Vector(1.14, 0.20, 0.65),
    Vector(0.92, 0.20, 0.65),
    Vector(0.70, 0.20, 0.65),
    Vector(1.25, 0.20, 0.84),
    Vector(1.03, 0.20, 0.84),
    Vector(0.81, 0.20, 0.84),
}

function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        playerBlock = getObjectFromGUID(loaded_data.playerBlock)
        initialized = loaded_data.initialized
    end

    serpent = getObjectFromGUID(serpentGUID)

    if initialized then
        self.interactable = false
        updatePresence()
        Wait.time(updatePresence, 1, -1)
    elseif not Global.getVar("gameStarted") then
        self.createButton({
            click_function = "setupDeepSlumber",
            function_owner = self,
            label = "Add Deep Slumber Snap Points",
            position = {0,0.2,0},
            rotation = {0,180,0},
            width = 4000,
            height = 500,
            font_size = 300,
        })
    end
end

function onSave()
    return JSON.encode{
        initialized = initialized,
        playerBlock = playerBlock and playerBlock.guid,
    }
end

function setupDeepSlumber(_, color)
    doSpiritSetup{color=color}
end

function findSerpent(color)
    local elementScanZone = getObjectFromGUID(Global.getVar("elementScanZones")[color])
    for _, obj in pairs(elementScanZone.getObjects()) do
        if obj.guid == serpentGUID then
            return true
        end
    end
    return false
end

function doSpiritSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing button!", "Red")
        return
    end

    if not findSerpent(color) then
        Player[color].broadcast("You have not picked Serpent Slumbering Beneath the Island!", "Red")
        return
    end

    local snapPoints = serpent.getSnapPoints()
    for _, position in pairs(slumberPoints) do
        table.insert(snapPoints, {position = position})
    end
    serpent.setSnapPoints(snapPoints)

    playerBlock = Global.getVar("playerBlocks")[color]

    initialized = true
    self.clearButtons()
    self.locked = true
    self.interactable = false
    local position = self.getPosition()
    position.y = -2
    self.setPosition(position)

    updatePresence()
    Wait.time(updatePresence, 1, -1)
end

local function presenceOnIsland(color)
    local count = 0
    for _, presence in pairs(getObjectsWithTag("Presence")) do
        if presence.getName() == color .. "'s Presence" then
            local bounds = presence.getBoundsNormalized()
            local origin = bounds.center - Vector(0, bounds.size.y/2, 0)
            local size = 0.5 * Vector(bounds.size.x, 0, bounds.size.z)
            local hits = Physics.cast{
                origin = origin,
                size = size,
                direction = Vector(0, -1, 0),
                max_distance = 1,
                type = 2, -- sphere
            }
            for _, hit in pairs(hits) do
                local obj = hit.hit_object
                if obj.hasTag("Balanced") or obj.hasTag("Thematic") then
                    local quantity = presence.getQuantity()
                    if quantity == -1 then
                        count = count + 1
                    else
                        count = count + quantity
                    end
                    break
                end
            end
        end
    end
    return count
end

local function slumberPresence()
    local count = 0
    for _, position in pairs(slumberPoints) do
        local hits = Physics.cast{
            origin = serpent.positionToWorld(position),
            direction = Vector(0, 1, 0),
            max_distance = 1,
            type = 1, --ray
        }
        for _, hit in pairs(hits) do
            if hit.hit_object.hasTag("Presence") then
                count = count + 1
                break
            end
        end
    end
    return count
end

function updatePresence()
    local color = playerBlock.getVar("playerColor")
    local slumberCount = slumberPresence()
    local islandCount = presenceOnIsland(color)
    local maxPresence = slumberTrack[math.min(slumberCount, #slumberTrack)]
    serpent.UI.setValue("presence", "(" .. islandCount .. "/" .. maxPresence .. ")")
end
