difficulty=3

requirements = true
boardSetup = true
postSetup = true
postSetupComplete = false
automatedVictoryDefeat = true

boardLayouts = {
    { -- 1 Board
        { pos = Vector(-12.74, 1.05, 14.14), rot = Vector(0.00, 180.00, 0.00) },
    },
    { -- 2 Board
        { pos = Vector(-2.61, 1.05, 31.52), rot = Vector(0.00, 180.00, 0.00) },
        { pos = Vector(-12.74, 1.05, 14.14), rot = Vector(0.00, 180.00, 0.00) },
    },
    { -- 3 Board
        { pos = Vector(23.79, 1.05, 11.34), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(3.66, 1.05, 11.42), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(-16.46, 1.05, 11.50), rot = Vector(0.00, 240.00, 0.00) },
    },
    { -- 4 Board
        { pos = Vector(43.93, 1.05, 11.30), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(23.79, 1.05, 11.34), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(3.66, 1.05, 11.42), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(-16.46, 1.05, 11.50), rot = Vector(0.00, 240.00, 0.00) },
    },
    { -- 5 Board
        { pos = Vector(64.04, 1.05, 11.27), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(43.93, 1.05, 11.30), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(23.79, 1.05, 11.34), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(3.66, 1.05, 11.42), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(-16.46, 1.05, 11.50), rot = Vector(0.00, 240.00, 0.00) },
    },
    { -- 6 Board
        { pos = Vector(80.49, 1.05, 10.75), rot = Vector(0.20, 240.00, 0.00) },
        { pos = Vector(60.39, 1.05, 10.80), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(40.29, 1.05, 10.83), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(20.15, 1.05, 10.87), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(0.01, 1.05, 10.95), rot = Vector(0.00, 240.00, 0.00) },
        { pos = Vector(-20.11, 1.05, 11.04), rot = Vector(0.00, 240.00, 0.00) },
    },
    { -- 7 Board
        { pos = Vector(93.31, 1.05, 52.36), rot = Vector(0.00, 216.70, 0.00) },
        { pos = Vector(-17.66, 1.05, 4.88), rot = Vector(0.00, 216.70, 0.00) },
        { pos = Vector(0.85, 1.05, 12.77), rot = Vector(0.00, 216.70, 0.00) },
        { pos = Vector(19.37, 1.05, 20.66), rot = Vector(0.00, 216.70, 0.00) },
        { pos = Vector(37.89, 1.05, 28.59), rot = Vector(0.00, 216.70, 0.00) },
        { pos = Vector(56.37, 1.05, 36.51), rot = Vector(0.00, 216.70, 0.00) },
        { pos = Vector(74.84, 1.05, 44.42), rot = Vector(0.20, 216.70, 0.00) },
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
    end
end

function Requirements(params)
    return not params.thematic
end
function BoardSetup(params)
    if params.boards == 7 then
        -- use smaller sized boards for 7 board setup
        getObjectFromGUID("SetupChecker").setVar("optionalScaleBoard", false)
    end
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
    postSetupComplete = true
end
function updateCount(params)
    escaped = params.count
end

function AutomatedVictoryDefeat()
    if checkLossID ~= nil then
        Wait.stop(checkLossID)
        checkLossID = nil
    end
    checkLossID = Wait.time(checkLoss, 5, -1)
end
function checkLoss()
    if escaped > 3 * Global.call("getMapCount", {norm = true, them = true}) then
        Wait.stop(checkLossID)
        Global.call("Defeat", {scenario = self.getName()})
    end
end
