elements="10001101"
energy=2
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
        click_function = "grabReminder",
        function_owner = self,
        label          = "Grab Reminder",
        position       = Vector(0,0.3,1.43),
        width          = 1100,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150
    })
end
function grabReminder(card)
    getObjectFromGUID("JEBag").takeObject({
        guid = "6ff60a",
        position = card.getPosition() + Vector(0, 1, 0),
        rotation = Vector(0, 180, 0)
    })
    Global.call("removeButtons", {obj = card, click_function = "grabReminder", function_owner = self})
end
