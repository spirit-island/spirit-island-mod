cardInvaderType="L"
cardInvaderStage=2

function onObjectEnterZone(zone, object)
    if object ~= self then return end
    -- automatically lock the card when it enters the ravage zone
    local ravageZoneGUID = "2403e9"
    if zone.getGUID() == ravageZoneGUID then
        print("locking "..object.getName())
        -- a small wait, to allow it to settle onto the board before being locked
        Wait.time(function() self.setLock(true) end, 1)
    end
end
