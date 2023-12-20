function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
spiritName = "Thunderspeaker"

function doSetup(params)
    local color = params.color
    local spirit = Global.call("getSpirit", {name = spiritName})
    local zone = Global.getVar("selectedColors")[color].zone

    for _, card in pairs(Player[color].getHandObjects(1)) do
        if card.getName() == "Manifestation of Power and Glory" then
            card.destruct()
            local newCard = Global.call("getPowerCard", {guid="7b0064", major=false})
            if newCard then
                newCard.deal(1, color)
            end
            break
        end
    end

    for _,object in pairs(zone.getObjects()) do
        if object.hasTag("Presence") then
            local isOnBoard = false
            local hits = Physics.cast({
                origin = object.getPosition(),
                direction = Vector(0,-1,0),
                max_distance = 1,
            })
            for _, hit in pairs(hits) do
                local obj = hit.hit_object
                if obj == spirit then
                    isOnBoard = true
                    break
                end
            end
            if not isOnBoard then
                object.destruct()
                break
            end
        end
    end

    local zOffset = 2.6
    local spos = spirit.getPosition()
    local dahan = Global.getVar("dahanBag").takeObject({
        position = spos + Vector(0,0.05,10+zOffset),
    })

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
