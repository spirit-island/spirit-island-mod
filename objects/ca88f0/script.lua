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
        callback_function = removeTokens,
    })
    bag.setLock(true)
end
function removeTokens(obj)
    local count = 8
    local numBoards = Global.getVar("numBoards")
    for _ = 1, count - (numBoards + 1) do
        local num = math.random(1, count)
        obj.takeObject({index = obj.getQuantity() - num}).destruct()
        count = count - 1
    end
    for _ = 1, obj.getQuantity() - count - (3 * numBoards - 1) do
        obj.takeObject({index = 0}).destruct()
    end
    obj.shuffle()
    postSetupComplete = true
end