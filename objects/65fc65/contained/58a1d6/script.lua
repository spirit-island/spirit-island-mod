function onLoad()
    Wait.frames(function() self.registerCollisions(false) end, 1)
end

function onCollisionEnter(collision_info)
    if Global.call("isPowerCard", {card=collision_info.collision_object}) then
        if self.is_face_down then
            collision_info.collision_object.addTag("Temporary Slow")
        else
            collision_info.collision_object.addTag("Temporary Fast")
        end
    end
end
function onCollisionExit(collision_info)
    if Global.call("isPowerCard", {card=collision_info.collision_object}) then
        if self.is_face_down then
            collision_info.collision_object.removeTag("Temporary Slow")
        else
            collision_info.collision_object.removeTag("Temporary Fast")
        end
    end
end