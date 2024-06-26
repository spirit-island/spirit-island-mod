spiritName = "Serpent Slumbering Beneath the Island"

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
    local setupComplete = false
    -- NB: setupComplete in the script state is set by the global script
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        setupComplete = loaded_data.setupComplete
    end

    if setupComplete then
        self.interactable = false
        updatePresence()
        Wait.time(updatePresence, 1, -1)
    end
end

function doSetup(params)
    local serpent = params.spiritPanel

    local snapPoints = serpent.getSnapPoints()
    for _, position in pairs(slumberPoints) do
        table.insert(snapPoints, {position = position})
    end
    serpent.setSnapPoints(snapPoints)

    self.clearButtons()
    self.locked = true
    self.interactable = false
    local position = self.getPosition()
    position.y = -2
    self.setPosition(position)

    updatePresence()
    Wait.time(updatePresence, 1, -1)
    return true
end

local function presenceOnIsland(color)
    local count = 0
    for _, presence in pairs(getObjectsWithTag("Presence")) do
        local presenceColor = string.sub(presence.getName(),1,-12)
        if presenceColor ~= color then
            presenceColor = Global.call("getSpiritColor", {name = presence.getDescription()})
        end
        if presenceColor == color and presence.getName() ~= "Incarna" then
            if presence.held_by_color then
                local quantity = presence.getQuantity()
                if quantity == -1 then
                    count = count + 1
                else
                    count = count + quantity
                end
            else
                local hits = Physics.cast({
                    origin = presence.getPosition(),
                    direction = Vector(0,-1,0),
                    max_distance = 1,
                })
                for _, hit in pairs(hits) do
                    local obj = hit.hit_object
                    if Global.call("isIsland", {obj=obj}) then
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
    end
    return count
end

local function slumberPresence(serpent)
    local count = 0
    for _, position in pairs(slumberPoints) do
        local hits = Physics.cast({
            origin = serpent.positionToWorld(position),
            direction = Vector(0, 1, 0),
            max_distance = 1,
            type = 1, --ray
        })
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
    if maxPresence < islandCount then
        serpent.UI.setAttribute("presence", "color", "Red")
    else
        serpent.UI.setAttribute("presence", "color", "Black")
    end
    serpent.UI.setValue("presence", "(" .. islandCount .. "/" .. maxPresence .. ")")
end
