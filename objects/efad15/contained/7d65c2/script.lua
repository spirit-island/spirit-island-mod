spiritName = "Serpent Slumbering Beneath the Island"

function doSetup(params)
    local color = params.color
    local spirit = Global.call("getSpirit", {name = spiritName})

    for _, card in pairs(Player[color].getHandObjects(1)) do
        if card.getName() == "Elemental Aegis" then
            card.destruct()
            local newCard = Global.call("getPowerCard", {guid="be4a8e", major=false})
            if newCard then
                newCard.deal(1, color)
            end
            break
        end
    end

    local spos = spirit.getPosition()
    local zOffset = 2.6

    local trackElements = spirit.getVar("trackElements")
    local firePos
    local firePresence
    for _,trackElement in pairs(trackElements) do
        if trackElement.elements == "00100000" then
            firePos = trackElement.position
        end
    end
    firePos = Vector(firePos.x, firePos.y, firePos.z)
    firePos = spirit.positionToWorld(firePos)

    local hits = Physics.cast({
        origin = firePos,
        direction = Vector(0,1,0),
        max_distance = 1,
    })
    for _, hit in pairs(hits) do
        local obj = hit.hit_object
        if obj.hasTag("Presence") then
            firePresence = obj
        end
    end

    firePresence.setPosition(spos + Vector(0,0.05,10+zOffset))

    return true
end

function onDestroy()
    for _, obj in pairs(getObjectsWithTag("Presence")) do
        if obj.getName() == "Incarna" and obj.getDescription() == spiritName then
            obj.destruct()
            break
        end
    end
end
