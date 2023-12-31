spiritName = "Shadows Flicker Like Flame"
elements={0,0,1,0,0,0,0,0}

function modifyElements(params)
    if params.color == Global.call("getSpiritColor", {name = spiritName}) then
        local darkFire = params.elements[2] + params.elements[3]
        params.elements[2] = darkFire
        params.elements[3] = darkFire
    end
    return params.elements
end

function modifyThresholds(params)
    return modifyElements({color = params.color, elements = params.elements})
end

function doSetup(params)
    local color = params.color

    local newCard = Global.call("getPowerCard", {guid="ca6b34", major=false})
    if newCard then
        newCard.deal(1, color)
    end

    return true
end
