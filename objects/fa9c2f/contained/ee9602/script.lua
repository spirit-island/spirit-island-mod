spiritName = "Bringer of Dreams and Nightmares"

function doSetup(params)
    local color = params.color
    for _, card in pairs(Player[color].getHandObjects(1)) do
        if card.getName() == "Dreams of the Dahan" then
            card.destruct()
            local newCard = Global.call("getPowerCard", {guid="23ed34", major=false})
            if newCard then
                newCard.deal(1, color)
            end
            Global.call("giveEnergy", {color=color, energy=1, ignoreDebt=false})
            break
        end
    end
    return true
end
