elements="00110000"
energy=1

function onLoad()
    Color.Add("SoftGreen", Color.new(0.75,1,0.67))
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
    Color.Add("SoftRed", Color.new(1,0.59,0.59))
    self.createButton({
        click_function = "discardOneMinor",
        function_owner = self,
        label          = "Discard 1 Minor",
        position       = Vector(0.2,0.3,1.43),
        width          = 1050,
        scale          = Vector(0.65,1,0.65),
        height         = 160,
        font_size      = 150,
        tooltip = "Discard the top card of the Minor Power deck"
    })
end

function discardOneMinor(obj, player_color, alt_click)
    processPowerCards({
        player_color = player_color,
        powerType    = "minor",
        count        = 1,
        doDiscard    = true,
        callbackFn   = broadcastFire,
        callbackObj  = self
    })
end

function broadcastFire(params)
    local player_color = params[1]
    local card = params[2][1]
    local elems = card.getVar("elements")
    local hadFire = elems and tonumber(elems:sub(3,3)) > 0
    if hadFire then
        Player[player_color].broadcast("The discarded card had Fire", Color.SoftGreen)
    else
        Player[player_color].broadcast("The discarded card did not have Fire", Color.SoftRed)
    end
end
