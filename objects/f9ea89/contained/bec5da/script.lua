function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
spiritName = "River Surges in Sunlight"

function doSetup(params)
    local color = params.color
    for _, card in pairs(Player[color].getHandObjects(1)) do
        if card.guid == "22b2f3" then
            card.destruct()
            Global.call("giveEnergy", {color=color, energy=1, ignoreDebt=false})
            break
        end
    end
    return true
end
