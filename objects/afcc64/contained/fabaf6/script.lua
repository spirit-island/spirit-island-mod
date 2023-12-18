spiritName = "Sharp Fangs Behind the Leaves"

function doSetup(params)
    local color = params.color
    local zone = Global.getVar("selectedColors")[color].zone

    -- Delete the initial beast
    for _,object in pairs(zone.getObjects()) do
        if object.hasTag("Beasts") then
            object.destruct()
            break
        end
    end

    return true
end
