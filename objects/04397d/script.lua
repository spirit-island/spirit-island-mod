difficulty=0
postSetup = true
postSetupComplete = false
hasBroadcast = true
customLoss = true

function PostSetup(params)
    local minorPowerDeck, majorPowerDeck
    if Global.getVar("playtestMinorPowers") > 0 then
        minorPowerDeck = getObjectFromGUID(Global.getVar("playtestMinorPowerZone")).getObjects()[1]
    else
        minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
    end
    if Global.getVar("playtestMajorPowers") > 0 then
        majorPowerDeck = getObjectFromGUID(Global.getVar("playtestMajorPowerZone")).getObjects()[1]
    else
        majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
    end
    for color,_ in pairs(Global.getVar("selectedColors")) do
        minorPowerDeck.deal(1, color)
        majorPowerDeck.deal(1, color)
    end

    postSetupComplete = true
end

function Broadcast(params)
    return "Guard the Isle's Heart - After all other setup: remove all Towns, in each inner land, add 1 Explorer and 1 Presence from the spirit starting on that board, and each spirit also draws 1 Minor and 1 Major Power"
end
