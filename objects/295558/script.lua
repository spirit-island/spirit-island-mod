function onCollisionEnter(collision_info)
    if string.sub(collision_info.collision_object.getName(),-7) == "Defence" then
        destroyObject(collision_info.collision_object)
    end
end