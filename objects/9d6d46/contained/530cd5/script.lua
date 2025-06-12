function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
spiritName = "Lure of the Deep Wilderness"

function doSetup(params)
    local color = params.color
    local spirit = params.spiritPanel
    local zone = Global.getTable("selectedColors")[color].zone

    local removed = 0
    local toRemove = 3
    for _,object in pairs(zone.getObjects()) do
        if object.hasTag("Presence") and object.getName() ~= "Incarna" then
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
                removed = removed + 1
            end
            if removed == toRemove then
                break
            end
        end
    end

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
