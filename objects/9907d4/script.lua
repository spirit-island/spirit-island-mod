function onCollisionEnter(collision_info)
    if collision_info.collision_object.type == "Tile" and (collision_info.collision_object.getVar("elements") ~= nil or collision_info.collision_object.hasTag("Any") or collision_info.collision_object.hasTag("Element Marker")) then
        destroyObject(collision_info.collision_object)
        return
    end
end