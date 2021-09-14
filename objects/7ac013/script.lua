difficulty=3

fearSetup=true
fearSetupComplete=false

function FearSetup(params)
    local dividersSetup = 0
    for _, obj in pairs(params.deck) do
        if obj.guid == "969897" then
            obj.setPosition(Vector(-46.18, 0.82, 35.58))
            obj.setRotation(Vector(0, 180, 180))
            dividersSetup = dividersSetup + 1
        elseif obj.guid == "f96a71" then
            obj.setPosition(Vector(-41.70, 0.82, 35.58))
            obj.setRotation(Vector(0, 180, 180))
            dividersSetup = dividersSetup + 1
        end
        if dividersSetup == 2 then
            break
        end
    end

    local handZone = Player["White"].getHandTransform(1)
    local fearDeck = getObjectFromGUID(Global.getVar("fearDeckSetupZone")).getObjects()[1]
    if fearDeck ~= nil then
        if fearDeck.type == "Deck" then
            for _=1,#fearDeck.getObjects() do
                fearDeck.takeObject({
                    position = handZone.position + Vector(-5, 0, 0),
                    smooth = false,
                })
            end
            Wait.condition(function() fearSetupComplete = true end, function() return fearDeck == nil end)
        elseif fearDeck.type == "Card" then
            fearDeck.setPosition(handZone.position + Vector(-5, 0, 0))
            fearSetupComplete = true
        end
    else
        fearSetupComplete = true
    end
end
