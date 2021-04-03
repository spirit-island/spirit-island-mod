function onCollisionEnter(collision_info)
    if collision_info.collision_object.type == "Generic" and collision_info.collision_object.hasTag("Destroy") then
        destroyObject(collision_info.collision_object)
        return
    end
end