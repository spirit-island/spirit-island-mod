spiritName = "Shadows Flicker Like Flame"

function doSetup(params)
    local color = params.color

    local newCard = Global.call("getPowerCard", {guid="ca6b34", major=false})
    if newCard then
        newCard.deal(1, color)
    end

    return true
end
