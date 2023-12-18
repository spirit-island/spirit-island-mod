difficulty=2
postSetup = true
postSetupComplete = false

function PostSetup(params)
    local NIBag = getObjectFromGUID("NIBag")
    NIBag.takeObject({
        guid = "46d07e",
        position = {-42.14, 0.82, 35.97},
        rotation = {0,90,0},
        smooth = false,
    })
    postSetupComplete = true
end
