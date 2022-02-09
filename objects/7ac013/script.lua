difficulty=3

postSetup=true
postSetupComplete=false

function PostSetup()
    local deck = Player["White"].getHandObjects(1)
    local dividersSetup = 0
    for _, obj in pairs(deck) do
        if obj.getName() == "Terror II" then
            obj.setPosition(Vector(-46.18, 0.82, 35.58))
            obj.setRotation(Vector(0, 180, 0))
            dividersSetup = dividersSetup + 1
        elseif obj.getName() == "Terror III" then
            obj.setPosition(Vector(-41.70, 0.82, 35.58))
            obj.setRotation(Vector(0, 180, 0))
            dividersSetup = dividersSetup + 1
        end
        if dividersSetup == 2 then
            break
        end
    end

    local fearDeck = getObjectFromGUID(Global.getVar("fearDeckSetupZone")).getObjects()[1]
    if fearDeck ~= nil then
        local handZone = Player["White"].getHandTransform(1)
        if fearDeck.type == "Deck" then
            for i=1,#fearDeck.getObjects() do
                fearDeck.takeObject({
                    position = handZone.position + Vector(-5 - (0.75 * i), 0, 0),
                    smooth = false,
                })
            end
            Wait.condition(function() postSetupComplete = true end, function() return fearDeck == nil end)
        elseif fearDeck.type == "Card" then
            fearDeck.setPosition(handZone.position + Vector(-5, 0, 0))
            postSetupComplete = true
        end
    else
        postSetupComplete = true
    end
end
