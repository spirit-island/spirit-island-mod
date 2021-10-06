local tricksterGUID = "14aabe"

function doSetup(params)
    local color = params.color
    if not Global.getVar("gameStarted") then
        Player[color].broadcast("Please wait for the game to start before pressing this button!", Color.Red)
        return
    end

    local zone = getObjectFromGUID(Global.getVar("elementScanZones")[color])
    local objs = zone.getObjects()
    local found = false
    local trickster = nil
    for _,obj in pairs(objs) do
        if obj.guid == tricksterGUID then
            found = true
            trickster = obj
            break
       end
    end
    if not found then
        Player[color].broadcast("You have not picked Grinning Trickster Stirs Up Trouble!", Color.Red)
        return
    end

    trickster.createButton({
        function_owner = self,
        click_function = "drawOneMinor",
        label          = "Draw 1 Minor",
        tooltip        = "Draw 1 Minor Power to your hand.\n----------\n\z
                          This is helpful for Overenthusiastic Arson and \z
                          Let's See What Happens. You can \"Forget\" the card \z
                          after you are done with it.",
        position       = {0.93,0.2,0.87},
        rotation       = {0,0,0},
        width          = 700,
        scale          = Vector(0.5,1,0.5),
        height         = 40,
        font_size      = 90,
    })

    self.interactable = false
end

function drawOneMinor(target_obj, source_color)
    if not Global.getVar("gameStarted") then
        return
    end

    local color = getPlayerColor()
    if color == nil or (color ~= source_color and Player[color].seated) then
        return
    end

    local minorPowerDeckZone
    local minorPowerDiscard
    local isPlaytest
    local probabilityOfNormalPower = 1 - Global.getVar("playtestMinorPowers")/4
    if math.random() < probabilityOfNormalPower then
        minorPowerDeckZone = getObjectFromGUID(Global.getVar("minorPowerZone"))
        minorPowerDiscard = getObjectFromGUID(Global.getVar("minorPowerDiscardZone")).getObjects()[1]
        isPlaytest = false
    else
        minorPowerDeckZone = getObjectFromGUID(Global.getVar("playtestMinorPowerZone"))
        minorPowerDiscard = getObjectFromGUID(Global.getVar("playtestMinorPowerDiscardZone")).getObjects()[1]
        isPlaytest = true
    end

    local minorPowerDeck = minorPowerDeckZone.getObjects()[1]
    if minorPowerDeck == nil then  -- no Minor Powers left in the deck
        if minorPowerDiscard == nil then  -- no Minor Powers discarded either, somehow
            -- NOTE: If you are playtesting a Power expansion with a separate Minor
            -- Power deck and there are somehow no cards in the chosen Minor Power
            -- discard or deck, this function will simply not draw a card, even if
            -- a card could be drawn from the other set of Powers.
            return
        end
        minorPowerDiscard.setPositionSmooth(minorPowerDeckZone.getPosition(), false, true)
        minorPowerDiscard.setRotationSmooth(Vector(0, 180, 180), false, true)
        minorPowerDeck = minorPowerDiscard
        minorPowerDeck.shuffle()
    end

    local gainedCardGUID
    if minorPowerDeck.type == "Card" then
        gainedCardGUID = minorPowerDeck.guid
    elseif minorPowerDeck.type == "Deck" then
        gainedCardGUID = minorPowerDeck.getObjects()[1].guid
    end
    
    Wait.condition(
        function() minorPowerDeck.deal(1, color, 1) end,
        function() return not minorPowerDeck.isSmoothMoving() end)

    if isPlaytest then
        Wait.condition(
            function() getObjectFromGUID(gainedCardGUID).addTag("Playtest") end,
            function() return getObjectFromGUID(gainedCardGUID) ~= nil end,
            2.0)  -- Give up after 2s if the expected card isn't gained for
                  -- whatever reason.
    end
end

function getPlayerColor()
    local zoneGuids = {}
    for color,guid in pairs(Global.getTable("elementScanZones")) do
        zoneGuids[guid] = color
    end
    for _,zone in pairs(getObjectFromGUID(tricksterGUID).getZones()) do
        if zoneGuids[zone.guid] then
            return zoneGuids[zone.guid]
        end
    end
    return ""
end