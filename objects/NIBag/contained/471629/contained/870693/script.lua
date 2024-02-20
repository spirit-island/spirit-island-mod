function onLoad()
    self.createButton({
        click_function = "spawnOmen",
        function_owner = self,
        label          = "Spawn Omen Token",
        position       = Vector(0,0.3,0.38),
        width          = 1200,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 120,
        tooltip = "Spawn Omen Token"
    })
end
function spawnOmen()
    local omenToken = getObjectFromGUID("cfeeba")
    local omen = omenToken.clone({
        position = self.getPosition() + Vector(0,2,0)
    })
    omen.setLock(false)
    omen.removeTag("Uninteractable")
end
