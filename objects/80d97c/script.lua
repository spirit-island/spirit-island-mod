function onCollisionEnter(collision_info)
    if collision_info.collision_object.type == "Generic" and string.match(collision_info.collision_object.getName(), "^%a*'s Isolate") then
        destroyObject(collision_info.collision_object)
        return
    end
end