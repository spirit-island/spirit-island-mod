difficulty=3

postSetup=true
postSetupComplete=false

function PostSetup()
    local scenarioBag = Global.getVar("scenarioBag")
    scenarioBag.takeObject({
        guid = "0841e7",
        position = {-45.24, 0.84, 36.64},
        rotation = {0,180,0},
        smooth = false,
    })
    postSetupComplete = true
end