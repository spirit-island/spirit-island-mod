difficulty=2

postSetup=true
postSetupComplete=false
fearSetup=true
fearSetupComplete=false

function PostSetup()
    local scenarioBag = Global.getVar("scenarioBag")
    scenarioBag.takeObject({
        guid = "0841e7",
        position = {-45.24, 0.84, 36.64},
        rotation = {0,180,0},
        smooth = false,
        callback_function = removeTokens,
    })
end
function removeTokens(obj)
    local diff = obj.getQuantity() - (Global.getVar("numBoards") * 4)
    for _ = 1, diff do
        obj.takeObject({}).destruct()
    end
    postSetupComplete = true
end

function FearSetup(params)
    local fearDeck = getObjectFromGUID(Global.getVar("fearDeckSetupZone")).getObjects()[1]
    params.deck.putObject(fearDeck)
    Wait.condition(function() fearSetupComplete = true end, function() return fearDeck == nil end)
end
