difficulty=3

fearSetup=true
fearSetupComplete=false

function FearSetup(params)
    params.deck.takeObject({
        guid = "969897",
        position = {-46.18, 0.82, 35.58},
        rotation = {0,180,180},
    })
    params.deck.takeObject({
        guid = "f96a71",
        position = {-41.70, 0.82, 35.58},
        rotation = {0,180,180},
    })
    local fearDeck = getObjectFromGUID(Global.getVar("fearDeckSetupZone")).getObjects()[1]
    params.deck.putObject(fearDeck)
    Wait.condition(function() fearSetupComplete = true end, function() return fearDeck == nil end)
end