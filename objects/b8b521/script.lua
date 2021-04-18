difficulty=1
fearCards={1,0,0}

onObjectCollision=true
invaderDeckSetup=true
mapSetup=true

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

function InvaderDeckSetup(params)
    local found = false
    local stageTwo = -1
    local stageThree = -1
    for i, stage in pairs(params.deck) do
        if stage == 1 then
            table.remove(params.deck,i)
            found = true
            break
        elseif stage == 2 or stage == "C" then
            if stageTwo == -1 then
                stageTwo = i
            end
        elseif stage == 3 then
            if stageThree == -1 then
                stageThree = i
            end
        end
    end
    if not found then
        if stageTwo ~= -1 then
            table.remove(params.deck,stageTwo)
        else
            table.remove(params.deck,stageThree)
        end
    end
    return params.deck
end

function MapSetup(params)
    if not params.extra then
        table.insert(params.pieces[6],"Town")
    end
    return params.pieces
end