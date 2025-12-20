blight=2
immediate=true
function onLoad()
    Wait.time(function() createButtons() end, 0.5)
end
-- card loading end

function createButtons()
    self.createButton({
        click_function = "drawMajors",
        function_owner = self,
        label          = "Draw Majors",
        position       = Vector(0,0.5,1.33),
        width          = 1700,
        scale          = Vector(0.65,1,0.65),
        height         = 320,
        font_size      = 300,
    })
end
function drawMajors(_, player_color)
    local numSpirits = Global.getVar("numPlayers")
    Global.call("startDraftPowerCards", {
        owner              = self.getName(),
        major              = true,
        count              = numSpirits + 2,
        pickCount          = numSpirits,
        ignoreProgression  = true,
        location           = self.getPosition() + Vector(0,5,0),
        alignment          = "left",
        pickBroadcast      = "Remember to Gain 2 Energy"
    })
    self.clearButtons()
end
