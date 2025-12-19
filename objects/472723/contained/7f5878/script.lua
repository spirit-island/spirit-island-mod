spiritName = "Grinning Trickster Stirs Up Trouble"

function onLoad()
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
end

function doSetup(params)
    local trickster = params.spiritPanel

    trickster.createButton({
        click_function = "drawOneMinor",
        function_owner = self,
        label          = "Draw 1 Minor",
        tooltip        = "Draw the top Card of the Minor Power Deck",
        position       = {0.83,0.23,0.87},
        rotation       = {0,0,0},
        width          = 530,
        scale          = Vector(0.5,1,0.5),
        height         = 35,
        font_size      = 80,
    })

    self.locked = true
    self.interactable = false
    local position = self.getPosition()
    position.y = -2
    self.setPosition(position)
end

function drawOneMinor(obj, player_color, alt_click)
    processPowerCards({
        player_color = player_color,
        powerType    = "minor",
        count        = 1
    })
end
