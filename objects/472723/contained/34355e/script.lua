elements="00110000"
energy=1

function onLoad()
    Color.Add("SoftGreen", Color.new(0.75,1,0.67))
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
    Color.Add("SoftRed", Color.new(1,0.59,0.59))
    self.createButton({
        click_function = "discardOneMinor",
        function_owner = self,
        label          = "Discard 1 Minor",
        position       = Vector(0.2,0.3,1.43),
        width          = 1050,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150,
        tooltip = "Discard the top card of the Minor Power deck"
    })
end

function discardOneMinor(obj, player_color, alt_click)
    if not Global.getVar("gameStarted") then
        Player[player_color].broadcast("The game has not started yet", Color.Red)
        return
    end

    local deckZones = { getObjectFromGUID(Global.getVar("minorPowerZone")) }
    local discardZones = { getObjectFromGUID(Global.getVar("minorPowerDiscardZone")) }
    local numPlaytestMinors = Global.getVar("playtestMinorPowers")

    -- Adding the playtest deck to the pool of possibilities if it is being used
    if numPlaytestMinors > 0 then
        table.insert(deckZones, getObjectFromGUID(Global.getVar("playtestMinorPowerZone")))
        table.insert(discardZones, getObjectFromGUID(Global.getVar("playtestMinorPowerDiscardZone")))
    end

    -- Randomising which deck to draw from
    -- Depends on what proportion of the draft is playtest
    local choice = 1
    if numPlaytestMinors > 0 and math.random() < numPlaytestMinors / 4 then
        choice = 2
    end

    if tryDiscard(deckZones[choice], discardZones[choice], player_color) then return end
    if tryDiscard(deckZones[3 - choice], discardZones[3 - choice], player_color) then return end

    Player[player_color].broadcast("There are no Minor Powers to discard", Color.SoftYellow)
end

function tryDiscard(deckZone, discardZone, player_color)
    local deck = deckZone.getObjects()[1]
    local discard = discardZone.getObjects()[1]

    if deck then
        discardCard(deck, discardZone, player_color)
        return true
    elseif discard then
        discard.setPositionSmooth(deckZone.getPosition(), false, true)
        discard.setRotationSmooth(Vector(0, 180, 180), false, true)
        discard.shuffle()
        -- Wait so that the deck is the face-down when drawn from
        Wait.time(function() discardCard(discard, discardZone, player_color) end, 1)
        return true
    end
    return false
end

function discardCard(deck, discardZone, player_color)
    if deck.type == "Card" then
        deck.flip()
        deck.setPosition(discardZone.getPosition() + Vector(0,3,0))
        broadcastFire(deck, player_color)
    else
        deck.takeObject({
            position = discardZone.getPosition() + Vector(0,3,0),
            flip = true,
            smooth = true,
            callback_function = function(card)
                broadcastFire(card, player_color)
            end
        })
    end
end

function broadcastFire(card, player_color)
    local name = card.getName()
    local elems = card.getVar("elements")
    local hadFire = elems and tonumber(elems:sub(3,3)) > 0
    if hadFire then
        Player[player_color].broadcast("Discarded "..name.." which had Fire", Color.SoftGreen)
    else
        Player[player_color].broadcast("Discarded "..name.." which did not have Fire", Color.SoftRed)
    end
end