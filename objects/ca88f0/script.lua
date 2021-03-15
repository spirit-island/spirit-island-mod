difficulty=1
broadcast="Remember, place 4 Scenario Markers on each board in lands without Dahan - Powers Long Forgotten"

postSetup=true
postSetupComplete=false

function PostSetup()
    local scenarioBag = Global.getVar("scenarioBag")
    local bag = scenarioBag.takeObject({
        guid = "8d6e46",
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

    -- Destroy all items besides 1-8 tokens, and shuffle to randomize
    scenarioBag.takeObject({guid = "8c41b6"}).destruct()
    scenarioBag.takeObject({guid = "195b49"}).destruct()
    scenarioBag.takeObject({guid = "889880"}).destruct()
    scenarioBag.takeObject({guid = "eb0571"}).destruct()
    scenarioBag.takeObject({guid = "8d6e45"}).destruct()
    scenarioBag.shuffle()

    local numBoards = Global.getVar("numBoards")
    for _ = 1, numBoards + 1 do
        bag.putObject(scenarioBag.takeObject({
            rotation = {0,180,180},
            smooth = false,
        }))
    end

    Wait.condition(function() bag.shuffle() postSetupComplete = true end, function() return #bag.getObjects() == numBoards * 4 end)
end
function removeTokens(stack)
    local bag = getObjectFromGUID("8d6e46")
    local numBoards = Global.getVar("numBoards")
    for _ = 1, 3 * numBoards - 1 do
        bag.putObject(stack.takeObject())
    end
    stack.destruct()
end
