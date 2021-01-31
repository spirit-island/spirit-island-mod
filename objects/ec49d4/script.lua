difficulty=2

postSetup=true
postSetupComplete=false

function PostSetup()
    local scenarioBag = Global.getVar("scenarioBag")
    local bag = scenarioBag.takeObject({
        guid = "8d6e45",
        position = {-44.08, 0.71, 34.11},
        rotation = {0,0,0},
        smooth = false,
        callback_function = function(obj) obj.setLock(true) end,
    })

    scenarioBag.takeObject({
        guid = "0841e7",
        position = {-45.24, 3.34, 36.64},
        rotation = {0,180,180},
        smooth = false,
        callback_function = removeTokens,
    })

    bag.putObject(scenarioBag.takeObject({
        guid = "8c41b6",
        rotation = {0,180,180},
        smooth = false,
    }))
    bag.putObject(scenarioBag.takeObject({
        guid = "195b49",
        rotation = {0,180,180},
        smooth = false,
    }))
    bag.putObject(scenarioBag.takeObject({
        guid = "889880",
        rotation = {0,180,180},
        smooth = false,
    }))
    bag.putObject(scenarioBag.takeObject({
        guid = "5bd914",
        rotation = {0,180,180},
        smooth = false,
    }))
    bag.putObject(scenarioBag.takeObject({
        guid = "eae635",
        rotation = {0,180,180},
        smooth = false,
    }))
    bag.putObject(scenarioBag.takeObject({
        guid = "ab2c31",
        rotation = {0,180,180},
        smooth = false,
    }))

    Wait.condition(function() bag.shuffle() postSetupComplete = true end, function() return #bag.getObjects() == 18 end)
end
function removeTokens(stack)
    local bag = getObjectFromGUID("8d6e45")
    for i=1,12 do
        bag.putObject(stack.takeObject())
    end
    stack.destruct()
end