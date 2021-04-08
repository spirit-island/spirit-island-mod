difficulty=0
broadcast="After all other setup: remove all Towns, in each inner land, add 1 Explorer and 1 Presence from the spirit\nstarting on that board, and each spirit also draws 1 Minor and 1 Major Power - Guard the Isle's Heart"

postSetup = true
postSetupComplete = false

function PostSetup(params)
    local minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
    local majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
    for color,_ in pairs(Global.getVar("selectedColors")) do
        minorPowerDeck.deal(1, color)
        majorPowerDeck.deal(1, color)
    end

    postSetupComplete = true
end