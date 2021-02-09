difficulty=3

requirements = true
boardSetup = true
postSetup = true
postSetupComplete = false

boardLayouts = {
    { -- 1 Board
        { pos = Vector(2.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
    },
    { -- 2 Board
        { pos = Vector(2.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(20.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
    },
    { -- 3 Board
        { pos = Vector(2.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(20.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(38.22, 1.08, 9.58), rot = Vector(0.00, 240.69, 0.00) },
    },
    { -- 4 Board
        { pos = Vector(2.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(20.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(38.22, 1.08, 9.58), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(-15.30, 1.08, 10.72), rot = Vector(0.00, 240.69, 0.00) },
    },
    { -- 5 Board
        { pos = Vector(2.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(20.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(38.22, 1.08, 9.58), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(-15.30, 1.08, 10.72), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(56.06, 1.08, 9.20), rot = Vector(0.00, 240.69, 0.00) },
    },
    { -- 6 Board
        { pos = Vector(2.54, 1.08, 10.34), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(20.38, 1.08, 9.96), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(38.22, 1.08, 9.58), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(-15.30, 1.08, 10.72), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(56.06, 1.08, 9.20), rot = Vector(0.00, 240.69, 0.00) },
        { pos = Vector(73.90, 1.08, 8.82), rot = Vector(0.00, 240.69, 0.00) },
    },
}

function Requirements(params)
    return not params.thematic
end
function BoardSetup(params)
    return boardLayout[params.boards]
end
function PostSetup()
    local scenarioBag = Global.getVar("scenarioBag")
    scenarioBag.takeObject({
        guid = "eb0571",
        position = self.getPosition() + vector(1.9, 0, 1.9),
        rotation = {0,180,0},
        callback_function = function(obj) obj.setLock(true) end,
    })
    postSetupComplete = true
end
