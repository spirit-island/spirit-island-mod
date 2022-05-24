function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
function doSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing this button!", Color.Red)
        return
    elseif color ~= Global.call("getSpiritColor", {name = "River Surges in Sunlight"}) then
        Player[color].broadcast("You have not picked River Surges in Sunlight!", Color.Red)
        return
    end

    for _, card in pairs(Player[color].getHandObjects(1)) do
        if card.guid == "22b2f3" then
            Global.call("ensureCardInPlay", {card=card})
            Wait.frames(function() Global.call("discardPowerCardFromPlay", {card = card, discardHeight = 1}) end, 1)
            Global.call("giveEnergy", {color=color, energy=1, ignoreDebt=false})
            break
        end
    end
end
