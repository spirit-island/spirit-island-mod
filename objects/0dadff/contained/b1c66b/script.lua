function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
spiritName = "Shifting Memory of Ages"

-- Checks whether a player is the player using this aspect
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
    if isThisPlayer(params.color) then
        return math.max(params.count - 2, 2)
    else
        return params.count
    end
end
