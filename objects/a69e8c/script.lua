difficulty=3

postSetup=true
postSetupComplete=false

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
end
function removeTokens(obj)
    -- Remove 8 numbered tokens
    for _ = 1, 8 do
        obj.takeObject({}).destruct()
    end
    postSetupComplete = true
end
