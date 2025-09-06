spiritName = "Covets Gleaming Shards of Earth"

function doSetup(params)
    local pos = params.spiritPanel.getPosition()

    local hoard = nil
    for _,obj in pairs(self.getObjects()) do
        if obj.name == "The Gleaming Hoard" then
            hoard = self.takeObject({
              guid = obj.guid,
              position = pos + Vector(0,0,-11),
              smooth = false,
              rotation = Vector(0,180,0)
            })
            break
        end
    end
    if not hoard then
        return false
    end
    hoard.setLock(true)

    -- Shift the hand zones down to make room for hoard board
    for i=Player[params.color].getHandCount(), 1, -1 do
        for _,obj in pairs(Player[params.color].getHandObjects(i)) do
            obj.setPositionSmooth(obj.getPosition() + Vector(0,0,-7), false, false)
        end
    end
    for _,obj in pairs(getObjects()) do
        if obj.type == "Hand" then
            if (obj.getData().FogColor == params.color) then
                obj.setPosition(obj.getPosition() + Vector(0,0,-7))
            end
        end
    end

    -- Scale scripting zone to cover hoard board
    local zone = Global.getTable("selectedColors")[params.color].zone
    zone.setPosition(zone.getPosition() + Vector(0, 0, -5))
    zone.setScale(zone.getScale() + Vector(0, 0, 10))

    -- Wait for hoard board to finish loading before putting treasure markers on top of it
    Wait.condition(function()
        local snapPoints = hoard.getSnapPoints()
        for i,_ in pairs(self.getObjects()) do
            self.takeObject({
                position = hoard.positionToWorld(snapPoints[i].position) + Vector(0,0.1,0)
            })
        end

        hoard.createButton({
            click_function = "drawOneMinor",
            function_owner = self,
            label          = "Draw 1 Minor",
            tooltip        = "Draw the top Card of the Minor Power Deck",
            position       = {-0.7,0.23,0.04},
            rotation       = {0,0,0},
            width          = 530,
            scale          = Vector(0.5,1,0.5),
            height         = 35,
            font_size      = 80,
        })

        self.locked = true
        self.interactable = false
        local position = self.getPosition()
        position.y = -2
        self.setPosition(position)

    end, function() return not hoard.loading_custom end)
    return true
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
