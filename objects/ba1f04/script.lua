function onCollisionEnter(collision_info)
    if collision_info.collision_object.type == "Generic" and (collision_info.collision_object.getName() == "Defence" or string.match(collision_info.collision_object.getName(), "^%a*'s Defence")) then
        destroyObject(collision_info.collision_object)
        return
    end
end