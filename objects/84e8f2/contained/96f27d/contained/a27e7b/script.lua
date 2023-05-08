function onLoad()
    self.createButton({
        click_function = "noHeal",
        function_owner = self,
        label          = "Disable Heal",
        position       = Vector(0,0.3,1.43),
        width          = 950,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150
    })
end
function noHeal(card)
    Global.setVar("noHealInvader", true)
    card.clearButtons()
end
