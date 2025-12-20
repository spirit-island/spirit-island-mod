elements="01001010"
energy=2
function onLoad(saved_data)
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
    Wait.time(function() recreateButtons() end, 0.5)
end
-- card loading end

function recreateButtons()
    self.clearButtons()
    self.createButton({
        click_function = "drawMinors",
        function_owner = self,
        label          = "Gain Minors",
        position       = Vector(-0.53,0.3,1.43),
        width          = 800,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150,
    })

    self.createButton({
        click_function = "drawMajors",
        function_owner = self,
        label          = "Gain Majors",
        position       = Vector(0.53,0.3,1.43),
        width          = 800,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150,
    })
end
function drawMinors(_, player_color)
    Global.call("startDraftPowerCards", {
        player             = Player[player_color],
        major              = false,
        count              = 4,
        pickCount          = 2,
        ignoreProgression  = true,
    })
    Wait.time(function() recreateButtons() end, 0.5)
end
function drawMajors(_, player_color)
    Global.call("startDraftPowerCards", {
        player             = Player[player_color],
        major              = true,
        count              = 4,
        pickCount          = 2,
        ignoreProgression  = true,
        pickBroadcast      = "Remember to Forget a Power Card",
        pickBroadcastColor = Color.SoftYellow
    })
    Wait.time(function() recreateButtons() end, 0.5)
end
