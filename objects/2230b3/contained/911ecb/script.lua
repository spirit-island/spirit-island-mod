spiritName = "Covets Gleaming Shards of Earth"

function doSetup(params)
    local pos = params.spiritPanel.getPosition()

    local hoard = nil
    for _,obj in pairs(self.getObjects()) do
        if obj.name == "The Gleaming Hoard" then
            hoard = self.takeObject({guid = obj.guid, position = pos + Vector(0,0,-11), smooth = false})
            break
        end
    end
    if not hoard then
        return false
    end
    hoard.setLock(true)

    -- Shift the hand zones down to make room for hoard board
    for i=Player[params.color].getHandCount(), 1, -1 do
        for _,obj in pairs(Player[params.color].getHandObjects(i)) do
            obj.setPositionSmooth(obj.getPosition() + Vector(0,0,-7), false, false)
        end
    end
    for _,obj in pairs(getObjects()) do
        if obj.type == "Hand" then
            if (obj.getData().FogColor == params.color) then
                obj.setPosition(obj.getPosition() + Vector(0,0,-7))
            end
        end
    end

    -- Scale scripting zone to cover hoard board
    local zone = Global.getTable("selectedColors")[params.color].zone
    zone.setPosition(zone.getPosition() + Vector(0, 0, -5))
    zone.setScale(zone.getScale() + Vector(0, 0, 10))

    -- Wait for hoard board to finish loading before putting treasure markers on top of it
    Wait.condition(function()
        local snapPoints = hoard.getSnapPoints()
        for i,_ in pairs(self.getObjects()) do
            self.takeObject({position = hoard.positionToWorld(snapPoints[i].position) + Vector(0,0.1,0)})
        end

        self.destruct()
    end, function() return not hoard.loading_custom end)
    return true
end
