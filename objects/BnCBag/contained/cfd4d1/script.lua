function onLoad()
    self.createButton({
        click_function = "returnFear",
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
function returnFear(card)
    Global.call("addFearCard", {})
    self.clearButtons()
end
