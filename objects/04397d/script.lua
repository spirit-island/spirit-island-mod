difficulty=0
boardSetup = true
postSetup = true
postSetupComplete = false
hasBroadcast = true
customLoss = true

function BoardSetup(params)
    local boardLayouts = Global.getTable("boardLayouts")
    if params.boards == 1 then
        return boardLayouts[params.boards]["Balanced"]
    elseif params.boards == 2 then
        return boardLayouts[params.boards]["Opposite Shores"]
    elseif params.boards == 3 then
        return boardLayouts[params.boards]["Balanced"]
    elseif params.boards == 4 then
        return boardLayouts[params.boards]["Balanced"]
    elseif params.boards == 5 then
        return boardLayouts[params.boards]["Meeple"]
    elseif params.boards == 6 then
        return boardLayouts[params.boards]["Star"]
    else
        broadcastToAll("Board count "..params.boards.." is currently unsupported, defaulting to balanced", Color.Red)
        return boardLayouts[params.boards]["Balanced"]
    end
end

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
    for color,_ in pairs(Global.getTable("selectedColors")) do
        minorPowerDeck.deal(1, color)
        majorPowerDeck.deal(1, color)
    end

    postSetupComplete = true
end

function Broadcast(params)
    return "Guard the Isle's Heart - After all other setup: remove all Towns, in each inner land, add 1 Explorer and 1 Presence from the spirit starting on that board, and each spirit also draws 1 Minor and 1 Major Power"
end
