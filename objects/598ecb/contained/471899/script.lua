function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
spiritName = "A Spread of Rampant Green"

function doSetup(params)
    local color = params.color
    for _, card in pairs(Player[color].getHandObjects(1)) do
        if card.getName() == "Gift of Proliferation" then
            card.destruct()
            break
        end
    end
    return true
end

function onDestroy()
    for _, obj in pairs(getAllObjects()) do
        if obj.getName() == "Belligerent and Aggressive Crops" and obj.getDescription() == spiritName then
            obj.destruct()
            break
        end
    end
end
