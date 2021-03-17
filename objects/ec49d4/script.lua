difficulty=2

postSetup=true
postSetupComplete=false

function PostSetup()
    local scenarioBag = Global.getVar("scenarioBag")
    local bag = scenarioBag.takeObject({
        guid = "baeea1",
        position = {-44.08, 0.71, 34.11},
        rotation = {0,0,0},
        smooth = false,
        callback_function = function(obj) obj.setLock(true) end,
    })
    bag.shuffle()
    postSetupComplete = true
end