difficulty=1

preSetup=true
preSetupComplete=false
mapSetup=true
hasBroadcast = true

broadcast = nil

function PreSetup()
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
    preSetupComplete = true
end

function MapSetup(params)
    if not Global.call("isThematic") then
        for i=1,#params.pieces do
            local landHasDahan = false
            for _,v in pairs (params.pieces[i]) do
                if string.sub(v,1,5) == "Dahan" then
                    landHasDahan = true
                    break
                end
            end
            if not landHasDahan then
                table.insert(params.pieces[i],"Scenario Token")
            end
        end
    else
        -- some thematic boards have more than 4 valid lands
        broadcast = "\nRemember, place 4 Scenario Markers on each board in lands without Dahan"
    end
    return params.pieces
end

function Broadcast(params)
    local text = "Powers Long Forgotten - Add 2 to your score for each unused source of power"
    if broadcast then
        text = text..broadcast
    end
    return text
end
