spiritName = "Breath of Darkness Down Your Spine"

function doSetup(params)
    local spirit = Global.call("getSpirit", {name = spiritName})
    local pos = spirit.getPosition()

    for _,obj in pairs(self.getObjects()) do
        if obj.name == "The Endless Dark" then
            self.takeObject({guid = obj.guid, position = pos + Vector(-7,0.11,15)})
        end
    end

    Global.getVar("explorerBag").takeObject({position = pos + Vector(-7,0.18,15)})

    self.destruct()
    return true
end
