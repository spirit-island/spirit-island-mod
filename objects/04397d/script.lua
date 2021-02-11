difficulty=0
broadcast="After all other setup: remove all Towns, in each inner land, add 1 Explorer and 1 Presence from the spirit\nstarting on that board, and each spirit also draws 1 Minor and 1 Major Power - Guard the Isle's Heart"

postSetup = true
postSetupComplete = false

function PostSetup(params)
    local minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
    local majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
    for color,_ in pairs(Global.getVar("selectedColors")) do
        local card = minorPowerDeck.takeObject({flip = true})
        card.setPosition(Player[color].getHandTransform(1).position + Vector(10,0,0))
        card = majorPowerDeck.takeObject({flip = true})
        card.setPosition(Player[color].getHandTransform(1).position + Vector(10,0,0))
    end

    postSetupComplete = true
end