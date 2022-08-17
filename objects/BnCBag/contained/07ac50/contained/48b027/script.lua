elements="11001100"
energy=9
function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
end
-- card loading end
function onObjectSpawn(obj)
    if obj == self then
        PickPower()
    end
end
function PickPower()
    self.createButton({
        click_function = "destroyBoard",
        function_owner = self,
        label          = "Destroy Board",
        position       = Vector(0,0.3,1.43),
        width          = 1100,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150
    })
end
function destroyBoard(card, color)
    local gravity = Physics.getGravity()
    if gravity.x == 0 and gravity.y == 0 and gravity.z == 0 then
        broadcastToAll("Gravity is currently disabled but is required, please enable and try again.", Color.Red)
        return
    end

    local hits = Physics.cast({
        origin = card.getPosition(),
        direction = Vector(0,-1,0),
        max_distance = 5,
        --debug = true,
    })
    local board = nil
    for _,v in pairs(hits) do
        if v.hit_object ~= card and Global.call("isIslandBoard", {obj=v.hit_object}) then
            board = v.hit_object
            break
        end
    end
    if board == nil then
        broadcastToAll("Unable to detect island board, make sure Cast Down into the Briny Deep is on top of an island board.", Color.Red)
        return
    end

    -- Return cast down to player's play area
    local selectedColors = Global.getTable("selectedColors")
    if selectedColors == nil or selectedColors[color] == nil or selectedColors[color].zone == nil then
        broadcastToAll("Unable to detect player play area, make sure Cast Down into the Briny Deep button is being pressed by a player.", Color.Red)
        return
    end
    self.setPosition(selectedColors[color].zone.getPosition() + Vector(-5, 1, -4))

    board.registerCollisions(false)
    Global.setVar("castDown", board.getName())
    Global.setVar("castDownColor", color)
    board.setPosition(board.getPosition() + Vector(0, -0.05, 0))
    Global.setVar("castDownTimer", Wait.time(castDownCallback, 0.5))
end
function castDownCallback()
    Global.setVar("castDown", nil)
    Global.setVar("castDownTimer", nil)
    Global.setVar("castDownColor", nil)
    broadcastToAll("Physics is required to be \"Full\", please change your setting and try again.", Color.Red)
end
