function doSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing this button!", Color.Red)
        return
    elseif color ~= Global.call("getSpiritColor", {name = "Fractured Days Split the Sky"}) then
        Player[color].broadcast("You have not picked Fractured Days Split the Sky!", Color.Red)
        return
    end

    local handZone = Player[color].getHandTransform(2)
    local newHandZone = {
        position = handZone.position,
        rotation = handZone.rotation,
        scale = handZone.scale,
    }
    newHandZone.position.z = newHandZone.position.z - 5.5
    Player[color].setHandTransform(newHandZone, 3)

    local count = 4
    if Global.getVar("numPlayers") <= 2 then
        count = 6
    end
    if Global.getVar("numBoards") == 1 then
        Player[color].broadcast("Don't forget to gain 1 Time", "Blue")
    end

    local playtestPowers = Global.getVar("playtestMinorPowers")
    local playtestCount = playtestPowers
    if count == 6 then
        if playtestPowers == 1 then
            playtestCount = 2
        elseif playtestPowers == 2 then
            playtestCount = 3
        end
    end
    local minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
    minorPowerDeck.deal(count - playtestCount, color, 3)
    if playtestCount > 0 then
        minorPowerDeck = getObjectFromGUID(Global.getVar("playtestMinorPowerZone")).getObjects()[1]
        minorPowerDeck.deal(playtestCount, color, 3)
    end

    playtestPowers = Global.getVar("playtestMajorPowers")
    playtestCount = playtestPowers
    if count == 6 then
        if playtestPowers == 1 then
            playtestCount = 2
        elseif playtestPowers == 2 then
            playtestCount = 3
        end
    end
    local majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
    majorPowerDeck.deal(count - playtestCount, color, 3)
    if playtestCount > 0 then
        majorPowerDeck = getObjectFromGUID(Global.getVar("playtestMajorPowerZone")).getObjects()[1]
        majorPowerDeck.deal(playtestCount, color, 3)
    end

    self.destruct()
end
