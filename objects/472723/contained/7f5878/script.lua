spiritName = "Grinning Trickster Stirs Up Trouble"

function onLoad()
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
end

function doSetup(params)
    local trickster = params.spiritPanel

    trickster.createButton({
        click_function = "drawOneMinor",
	    function_owner = self,
        label          = "Draw a Minor",
        tooltip        = "Draw the top Card of the Minor Power Deck",
        position       = {0.93,0.2,0.87},
        rotation       = {0,0,0},
        width          = 700,
        scale          = Vector(0.5,1,0.5),
        height         = 40,
        font_size      = 90,
    })

    self.locked = true
    self.interactable = false
    local position = self.getPosition()
    position.y = -2
    self.setPosition(position)
end

function drawOneMinor(obj, player_color, alt_click)
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

    if tryDeal(deckZones[choice], discardZones[choice], player_color) then return end
    if tryDeal(deckZones[3 - choice], discardZones[3 - choice], player_color) then return end

    Player[player_color].broadcast("There are no Minor Powers to draw", Color.SoftYellow)
end

function tryDeal(deckZone, discardZone, player_color)
    local deck = deckZone.getObjects()[1]
    local discard = discardZone.getObjects()[1]

    if deck then
        deck.deal(1, player_color, 1)
        return true
    elseif discard then
        discard.setPositionSmooth(deckZone.getPosition(), false, true)
        discard.setRotationSmooth(Vector(0, 180, 180), false, true)
        discard.shuffle()
        -- Wait so that the deck is the face-down when drawn from
        Wait.time(function()
            discard.deal(1, player_color, 1)
        end, 1)
        return true
    end
    return false
end
