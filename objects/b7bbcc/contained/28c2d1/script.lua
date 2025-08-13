elements="01000000"
energy=1
-- card loading end

function onLoad()
    self.createButton({
        click_function = "drawMinors",
        function_owner = self,
        label          = "Draw 6 Minors",
        position       = Vector(0.2,0.3,1.43),
        width          = 1050,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150,
        tooltip = "Make sure to right click the \"Pick Power\" button for your first choice"
    })
end
function drawMinors(_, player_color)
    Global.call("startDraftPowerCards", {player = Player[player_color], major = false, count = 6})
end
