local spiritName = "Serpent Slumbering Beneath the Island"
local initialized = false

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
        initialized = loaded_data.initialized
    end

    if initialized then
        self.interactable = false
        updatePresence()
        Wait.time(updatePresence, 1, -1)
    end
end

function onSave()
    return JSON.encode{
        initialized = initialized,
    }
end

function doSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing this button!", Color.Red)
        return
    elseif color ~= Global.call("getSpiritColor", {name = spiritName}) then
        Player[color].broadcast("You have not picked " .. spiritName .. "!", Color.Red)
    end

    local serpent = Global.call("getSpirit", {name = spiritName})

    local snapPoints = serpent.getSnapPoints()

    for _, position in pairs(slumberPoints) do
        table.insert(snapPoints, {position})
    end
    serpent.setSnapPoints(snapPoints)

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
                if Global.call("isIslandBoard", {obj}) then
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

local function slumberPresence(serpent)
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
    local spiritColor = Global.call("getSpiritColor", {name = spiritName})
    if spiritColor == nil then
        broadcastToAll("Unable to find " .. spiritName .. "!", Color.Red)
        return
    end
    local serpent = Global.call("getSpirit", {name = spiritName})

    local slumberCount = slumberPresence(serpent)
    local islandCount = presenceOnIsland(spiritColor)
    local maxPresence = slumberTrack[math.min(slumberCount, #slumberTrack)]
    serpent.UI.setValue("presence", "(" .. islandCount .. "/" .. maxPresence .. ")")
end
