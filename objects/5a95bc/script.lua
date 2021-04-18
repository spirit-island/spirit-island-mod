difficulty=3

requirements = true
boardSetup = true
postSetup = true
postSetupComplete = false

boardLayouts = {
    { -- 1 Board
        { pos = Vector(4.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
    },
    { -- 2 Board
        { pos = Vector(4.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(22.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
    },
    { -- 3 Board
        { pos = Vector(4.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(22.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(40.22, 1.08, 9.58), rot = Vector(0.00, 240.69, 0.00) },
    },
    { -- 4 Board
        { pos = Vector(4.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(22.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(40.22, 1.08, 9.58), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(-13.30, 1.08, 10.72), rot = Vector(0.00, 240.69, 0.00) },
    },
    { -- 5 Board
        { pos = Vector(4.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(22.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(40.22, 1.08, 9.58), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(-13.30, 1.08, 10.72), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(58.06, 1.08, 9.20), rot = Vector(0.00, 240.69, 0.00) },
    },
    { -- 6 Board
        { pos = Vector(4.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(22.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(40.22, 1.08, 9.58), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(-13.30, 1.08, 10.72), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(58.06, 1.08, 9.20), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(75.90, 1.08, 8.82), rot = Vector(0.00, 240.69, 0.00) },
    },
}
escaped = 0
checkLossID = 0

function onLoad()
    if Global.getVar("gameStarted") then
        local lossBag = getObjectFromGUID("eb0571")
        if lossBag ~= nil then
            lossBag.call("setCallback", {obj=self,func="updateCount"})
            updateCount({count=#lossBag.getObjects()})
        end
        checkLossID = Wait.time(checkLoss, 5, -1)
    end
end

function Requirements(params)
    return not params.thematic
end
function BoardSetup(params)
    return boardLayouts[params.boards]
end
function PostSetup()
    local scenarioBag = Global.getVar("scenarioBag")
    scenarioBag.takeObject({
        guid = "eb0571",
        position = self.getPosition() + Vector(1.9, 0, 1.9),
        rotation = {0,180,0},
        callback_function = function(obj)
            obj.setLock(true)
            obj.call("setCallback", {obj=self,func="updateCount"})
            updateCount({count=#obj.getObjects()})
        end,
    })
    checkLossID = Wait.time(checkLoss, 5, -1)
    postSetupComplete = true
end
function updateCount(params)
    escaped = params.count
end

function checkLoss()
    if escaped > 3 * Global.getVar("numBoards") then
        broadcastToAll("Invaders wins via Scenario Additional Loss Condition!", "Red")
        Wait.stop(checkLossID)
    end
end