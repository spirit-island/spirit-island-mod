function onObjectSpawn(obj)
    if obj == self then
        local scale = flipVector(Vector(obj.getScale()))
        obj.createButton({
            click_function = "returnCard",
            function_owner = self,
            label          = "Return to Deck",
            position       = Vector(0,0.3,1.43),
            width          = 1100,
            scale          = scale,
            height         = 160,
            font_size      = 150,
            tooltip = "Return back to the Event Deck under top 2 cards"
        })
    end
end
function flipVector(vec)
    vec.x = 1/vec.x
    vec.y = 1/vec.y
    vec.z = 1/vec.z
    return vec
end
function returnCard(card)
    local zone = getObjectFromGUID(Global.getVar("eventDeckZone"))
    local eventDeck = zone.getObjects()[1]
    if eventDeck ~= nil then
        eventDeck.takeObject({
            position = eventDeck.getPosition() + Vector(0,2,0)
        })
        eventDeck.takeObject({
            position = eventDeck.getPosition() + Vector(0,2,0)
        })
    end
    card.setRotationSmooth(Vector(0,180,180), false, true)
    card.setPositionSmooth(zone.getPosition() + Vector(0,0.1,0), false, true)
end