difficulty=2
postSetup=true
postSetupComplete=false
customVictory = true

tokensSetup = false
fearSetup = false

function PostSetup()
    local scenarioBag = Global.getVar("scenarioBag")
    local bag = scenarioBag.takeObject({
        guid = "8d6e46",
        position = {-42.14, 0.71, 35.97},
        rotation = {0,180,0},
        smooth = false,
        callback_function = removeTokens,
    })
    bag.setLock(true)

    local fearDeck = getObjectFromGUID(Global.getVar("fearDeckSetupZone")).getObjects()[1]
    if fearDeck ~= nil then
        local handZone = Player["Black"].getHandTransform(1)
        if fearDeck.type == "Deck" then
            for i=1,#fearDeck.getObjects() do
                fearDeck.takeObject({
                    position = handZone.position + Vector(-5 - (0.75 * i), 0, 0),
                    smooth = false,
                })
            end
            Wait.condition(function() fearSetup = true end, function() return fearDeck == nil end)
        elseif fearDeck.type == "Card" then
            fearDeck.setPosition(handZone.position + Vector(-5, 0, 0))
            fearSetup = true
        end
    else
        fearSetup = true
    end

    Wait.condition(function() postSetupComplete = true end, function() return tokensSetup and fearSetup end)
end
function removeTokens(obj)
    -- Remove 8 numbered tokens
    for _ = 1, 8 do
        obj.takeObject({}).destruct()
    end
    local diff = obj.getQuantity() - (Global.getVar("numBoards") * 4)
    for _ = 1, diff do
        obj.takeObject({}).destruct()
    end
    tokensSetup = true
end
