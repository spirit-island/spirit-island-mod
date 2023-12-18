function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
spiritName = "Vital Strength of the Earth"

function doSetup(params)
    local color = params.color
    for _, card in pairs(Player[color].getHandObjects(1)) do
        if card.getName() == "A Year of Perfect Stillness" then
            card.destruct()
            local newCard = Global.call("getPowerCard", {guid="d3861b", major=false})
            if newCard then
                newCard.deal(1, color)
            end
            break
        end
    end

    return true
end
