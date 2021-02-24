local Raycast = {}

function Raycast.upCast(obj, dist, offset, types)
    dist = dist or 1
    offset = offset or 0
    local hits = Physics.cast({
        origin       = obj.getPosition() + Vector(0, offset, 0),
        direction    = Vector(0, 1, 0),
        type         = 3, -- box
        size         = obj.getBoundsNormalized().size,
        orientation  = obj.getRotation(),
        max_distance = dist,
        --debug        = true,
    })
    local hitObjects = {}
    for _, v in pairs(hits) do
        if types ~= nil then
            local matchesType = false
            for _, t in pairs(types) do
                if v.hit_object.type == t then
                    matchesType = true
                end
            end
            if matchesType then
                table.insert(hitObjects, v.hit_object)
            end
        elseif v.hit_object ~= obj then
            table.insert(hitObjects, v.hit_object)
        end
    end
    return hitObjects
end

function Raycast.upCastRay(obj, dist)
    local hits = Physics.cast({
        origin       = obj.getBoundsNormalized().center,
        direction    = Vector(0, 1, 0),
        max_distance = dist,
        --debug = true,
    })
    local hitObjects = {}
    for _, v in pairs(hits) do
        if v.hit_object ~= obj and not obj.hasTag("Balanced") and not obj.hasTag("Thematic") then
            table.insert(hitObjects, v.hit_object)
        end
    end
    return hitObjects
end

function Raycast.upCastPosSizRot(pos, size, rot, dist, types)
    rot = rot or Vector(0, 0, 0)
    dist = dist or 1
    types = types or {}
    local hits = Physics.cast({
        origin       = pos,
        direction    = Vector(0, 1, 0),
        type         = 3, -- box
        size         = size,
        orientation  = rot,
        max_distance = dist,
        --debug        = true,
    })
    local hitObjects = {}
    for _, v in pairs(hits) do
        if types ~= {} then
            local matchesType = false
            for _, t in pairs(types) do
                if v.hit_object.type == t then
                    matchesType = true
                end
            end
            if matchesType then
                table.insert(hitObjects, v.hit_object)
            end
        else
            table.insert(hitObjects, v.hit_object)
        end
    end
    return hitObjects
end

return Raycast
