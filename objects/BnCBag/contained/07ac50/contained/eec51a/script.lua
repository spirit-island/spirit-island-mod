elements="11111111"
energy=4
function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
    CreateButton()
end
-- card loading end

function CreateButton()
    self.createButton({
        click_function = "drawMajors",
        function_owner = self,
        label          = "Draw 2 Majors",
        position       = Vector(0.19,0.3,1.43),
        width          = 1050,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150
    })
end
function drawMajors(_, player_color)
    Global.call("startDraftPowerCards", {player = Player[player_color], major = true, count = 2})
end
