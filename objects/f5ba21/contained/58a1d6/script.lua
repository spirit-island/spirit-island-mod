function onLoad()
    Wait.frames(function() self.registerCollisions(false) end, 1)
end

function onCollisionEnter(collision_info)
    -- HACK: Temporary fix until TTS bug resolved https://tabletopsimulator.nolt.io/1255
    if collision_info == nil then
        return
    end
    if Global.call("isPowerCard", {card=collision_info.collision_object}) then
        if self.is_face_down then
            collision_info.collision_object.addTag("Temporary Slow")
        else
            collision_info.collision_object.addTag("Temporary Fast")
        end
    end
end
function onCollisionExit(collision_info)
    -- HACK: Temporary fix until TTS bug resolved https://tabletopsimulator.nolt.io/1255
    if collision_info == nil then
        return
    end
    if Global.call("isPowerCard", {card=collision_info.collision_object}) then
        if self.is_face_down then
            collision_info.collision_object.removeTag("Temporary Slow")
        else
            collision_info.collision_object.removeTag("Temporary Fast")
        end
    end
end
