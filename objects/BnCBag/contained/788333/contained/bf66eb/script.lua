blight=2

function onLoad()
    self.createButton({
        click_function = "drawMinors",
        function_owner = self,
        label          = "Draw Minors",
        position       = Vector(0,0.5,1.33),
        width          = 1700,
        scale          = Vector(0.65,1,0.65),
        height         = 320,
        font_size      = 300,
    })
end
function drawMinors(_, player_color)
    local numSpirits = Global.getVar("numPlayers")
    Global.call("startDraftPowerCards", {
        owner              = self.getName(),
        major              = false,
        count              = numSpirits + 1,
        pickCount          = numSpirits,
        ignoreProgression  = true,
        location           = self.getPosition() + Vector(0,5,0),
        alignment          = "left",
        pickBroadcast      = "Lock this Power Card in your play area to make it cost no Energy and not get discarded during Time Passes"
    })
    self.clearButtons()
end
