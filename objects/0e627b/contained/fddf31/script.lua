function doSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing this button!", Color.Red)
        return false
    elseif color ~= Global.call("getSpiritColor", {name = "Fractured Days Split the Sky"}) then
        Player[color].broadcast("You have not picked Fractured Days Split the Sky!", Color.Red)
        return false
    end

    local position = Player[color].getHandTransform(2).position
    position.z = position.z - 5.5
    Global.call("SpawnHand", {color = color, position = position})

    Wait.frames(function()
        local count
        if Global.getVar("SetupChecker").getVar("exploratoryFractured") then
            count = 7 - Global.getVar("numPlayers")
            if count < 1 then
                count = 1
            end
        elseif Global.getVar("numPlayers") <= 2 then
            count = 6
        else
            count = 4
        end
        if Global.getVar("numBoards") == 1 then
            Player[color].broadcast("Don't forget to gain 1 Time", "Blue")
        end

        local playtestCount = Global.call("getPlaytestCount", {count = count, major = false})
        local minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
        minorPowerDeck.deal(count - playtestCount, color, 3)
        if playtestCount > 0 then
            minorPowerDeck = getObjectFromGUID(Global.getVar("playtestMinorPowerZone")).getObjects()[1]
            minorPowerDeck.deal(playtestCount, color, 3)
        end

        playtestCount = Global.call("getPlaytestCount", {count = count, major = true})
        local majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
        majorPowerDeck.deal(count - playtestCount, color, 3)
        if playtestCount > 0 then
            majorPowerDeck = getObjectFromGUID(Global.getVar("playtestMajorPowerZone")).getObjects()[1]
            majorPowerDeck.deal(playtestCount, color, 3)
        end

        self.destruct()
    end, 1)
    return true
end
