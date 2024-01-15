difficulty=7
fearCards = {1,1,1}
postSetup = true
postSetupComplete = false

function PostSetup(params)
    local ScenarioBag = getObjectFromGUID("ScenarioBag")
    ScenarioBag.takeObject({
        guid = "08bafe",
        position = {-42.14, 0.82, 35.97},
        rotation = {0,90,0},
        smooth = false,
    })
    postSetupComplete = true
end
