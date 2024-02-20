function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
spiritName = "Lightning's Swift Strike"

function doSetup(params)
    local color = params.color
    for _, card in pairs(Player[color].getHandObjects(1)) do
        if card.getName() == "Raging Storm" then
            card.destruct()
            break
        end
    end
    return true
end

function onDestroy()
    for _, obj in pairs(getAllObjects()) do
        if obj.getName() == "Smite the Land with Fulmination" and obj.getDescription() == spiritName then
            obj.destruct()
            break
        end
    end
end
