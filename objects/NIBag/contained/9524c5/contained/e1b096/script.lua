elements="00111001"
energy=4
function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        self.setTable("thresholds", loaded_data.thresholds)
    end
    PickPower()
end
-- card loading end
function PickPower()
    self.createButton({
        click_function = "removeFearCard",
        function_owner = self,
        label          = "Remove Fear Card",
        position       = Vector(0,0.3,1.43),
        width          = 1300,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150
    })
end
function removeFearCard(card)
    Global.getVar("aidBoard").call("fearCard", { earned = false })
end
