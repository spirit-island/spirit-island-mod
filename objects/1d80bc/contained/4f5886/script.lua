spiritName = "Wounded Waters Bleeding"

local startingEnergy = 4

local markerPoints = {
    Vector(-0.901253, 0.2, -0.5438905),
    Vector(-0.9637658, 0.2, -0.710127652),
    Vector(-1.12030506, 0.2, -0.78888005),
    Vector(-1.27356112, 0.2, -0.710231543),
    Vector(-1.34716439, 0.2, -0.5482518),
}

local healingMarkerPoints = {
    Vector(4.92,0.2,2.97),
    Vector(5.26,0.2,3.88),
    Vector(6.12,0.2,4.31),
    Vector(6.95,0.2,3.88),
    Vector(7.36,0.2,2.99)
}

function doSetup(params)
    local color = params.color
    local panel = params.spiritPanel

    -- Starting energy
    Global.call("giveEnergy", {color=color, energy=startingEnergy, ignoreDebt=false})

    -- Healing track snap points
    local snapPoints = panel.getSnapPoints()
    for _, position in pairs(markerPoints) do
        table.insert(snapPoints, {position = position})
    end
    panel.setSnapPoints(snapPoints)

    -- Special elements and healing markers
    local pos = panel.getPosition()
    for _,obj in pairs(self.getObjects()) do
        if obj.name == "Healing Markers" then
            local healBag = self.takeObject({guid = obj.guid})
            for i = 1, #healingMarkerPoints do
                healBag.takeObject({position = pos + healingMarkerPoints[i]}).setLock(true)
            end
            healBag.destruct()
        end
    end

    -- Healing cards hand
    local position = Player[color].getHandTransform(2).position
    position.z = position.z - 5.5
    Global.call("SpawnHand", {color = color, position = position})

    local hand = Player[color].getHandObjects(1)
    Wait.frames(function()
        if hand ~= {} then
            for _,card in pairs(hand) do
                if card.hasTag("Healing") then
                    card.deal(1, color, 3)
                end
            end
        end

        self.destruct()
    end, 1)

    return true
end
