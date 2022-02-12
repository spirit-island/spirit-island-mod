difficulty=1
fearCards={1,0,0}

onObjectCollision=true
mapSetup=true
hasBroadcast=true

function onLoad()
    if Global.getVar("gameStarted") then
        for _,obj in ipairs(getObjects()) do
            if Global.call("isIslandBoard", {obj=obj}) then
                obj.registerCollisions(false)
            end
        end
    end
end
function onObjectLeaveContainer(container, object)
    if Global.call("isIslandBoard", {obj=object}) then
        -- registerCollisions doesn't work on the frame an object leaves a bag
        Wait.frames(function()
            object.registerCollisions(false)
        end, 1)
    end
end
function onObjectCollisionEnter(params)
    if Global.call("isIslandBoard", {obj=params.hit_object}) then
        if params.collision_info.collision_object.type == "Generic" then
            if params.collision_info.collision_object.getVar("elements") ~= nil then
                params.collision_info.collision_object.addTag("Invocation Element")
            end
        end
    end
end
function onObjectCollisionExit(params)
    if Global.call("isIslandBoard", {obj=params.hit_object}) then
        if params.collision_info.collision_object.type == "Generic" then
            if params.collision_info.collision_object.getVar("elements") ~= nil then
                params.collision_info.collision_object.removeTag("Invocation Element")
            end
        end
    end
end

function MapSetup(params)
    if not params.extra then
        table.insert(params.pieces[6],"Town")
    end
    return params.pieces
end

function Broadcast(params)
    return "Elemental Invocation - Before Setup don't forget to Accelerate the Invader Deck."
end
