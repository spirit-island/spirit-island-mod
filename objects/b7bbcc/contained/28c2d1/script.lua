elements="01000000"
energy=1
function onLoad()
    Wait.time(function() recreateCardButton() end, 0.5)
end
-- card loading end

function recreateCardButton()
    self.clearButtons()
    self.createButton({
            click_function = "drawMinors",
            function_owner = self,
            label          = "Draw 6 Minors",
            position       = Vector(0.2,0.3,1.43),
            width          = 1050,
            scale          = Vector(0.65,1,0.65),
            height         = 160,
            font_size      = 150,
        })
end
function drawMinors(_, player_color)
    Global.call("startDraftPowerCards", {
        player    = Player[player_color],
        major     = false,
        count     = 6,
        pickCount = 2
    })
    Wait.time(function() recreateCardButton() end, 0.5)
end