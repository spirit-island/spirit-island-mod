function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end

function hasBoundlessAvarice()
    local snaps = self.getSnapPoints()
    local hits = Physics.cast({
        origin = self.positionToWorld(snaps[21].position),
        direction = Vector(0, 1, 0),
        max_distance = 1,
        type = 1, --ray
        -- debug = true
    })
    for _, hit in pairs(hits) do
        if hit.hit_object.getName() == "Treasure Marker" then
            return true
        end
    end
    return false
end

function isThisPlayer(color)
    local selected = Global.getTable("selectedColors")[color]
    if not selected then return false end

    -- Go through all the zones this object is in to see if one is the relevant player's zone
    for _,zone in ipairs(self.getZones()) do
        if zone == selected.zone then
            return true
        end
    end
    return false
end

function modifyCardGain(params)
    if params.major and hasBoundlessAvarice() and isThisPlayer(params.color) then
        return params.count + 2
    else
        return params.count
    end
end
