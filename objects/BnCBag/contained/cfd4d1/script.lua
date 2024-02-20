function onLoad()
    self.createButton({
        click_function = "addFearCard",
        function_owner = self,
        label          = "Add Fear Card",
        position       = Vector(0,0.3,1.43),
        width          = 1200,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150,
        tooltip = "Add Fear Card"
    })
end
function addFearCard(card)
    Global.call("addFearCard", {})
    Global.call("removeButtons", {obj = card, click_function = "addFearCard", function_owner = self})
end
