function onObjectSpawn(obj)
    if obj == self then
        obj.createButton({
            click_function = "returnFear",
            function_owner = self,
            label          = "Return Fear Card",
            position       = Vector(0,0.3,0.3),
            width          = 1200,
            scale          = Vector(0.65,1,0.65),
            height         = 160,
            font_size      = 150,
            tooltip = "Return top Fear Card"
        })
    end
end
function returnFear(card)
    Global.getVar("aidBoard").call("fearCard", { earned = false })
    self.clearButtons()
end