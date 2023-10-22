function onLoad()
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
        guid = "d986c8",
        position = card.getPosition() + Vector(0, 1, 0),
        rotation = Vector(0, 180, 0)
    })
    Global.call("removeButtons", {obj = card, click_function = "grabReminder", function_owner = self})
end
