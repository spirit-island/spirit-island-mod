spiritName = "Shadows Flicker Like Flame"
elements={0,0,1,0,0,0,0,0}
setupComplete = false

local darkFireTokenName = "Dark Fire Element"
local darkFireTokenColor = Color(1,1,1)

function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        setupComplete = loaded_data.setupComplete
    end
end

function modifyElements(params)
    if not setupComplete then
        return params.elements
    end
    if params.color == Global.call("getSpiritColor", {name = spiritName}) then
        local darkFire = params.elements[2] + params.elements[3]
        params.elements[2] = darkFire
        params.elements[3] = darkFire
    end
    return params.elements
end

function modifyThresholds(params)
    if not setupComplete then
        return params.elements
    end
    return modifyElements({color = params.color, elements = params.elements})
end

-- Edits a Fire element bag to be Dark Fire
function makeDarkFire(bag)
    bag.setName(darkFireTokenName)
    bag.setColorTint(darkFireTokenColor)

    local data = bag.getData().ContainedObjects[1]
    data.Nickname = darkFireTokenName
    data.ColorDiffuse.r = darkFireTokenColor.r
    data.ColorDiffuse.g = darkFireTokenColor.g
    data.ColorDiffuse.b = darkFireTokenColor.b
    table.insert(data.Tags, "Moon")

    bag.reset()
    spawnObjectData({
        data = data,
        position = bag.getPosition() + Vector(0, 0, 1),
        rotation = Vector(0, 180, 0),
        callback_function = function(obj) bag.putObject(obj) end,
    })
end

function doSetup(params)
    local color = params.color

    local newCard = Global.call("getPowerCard", {guid="ca6b34", major=false})
    if newCard then
        newCard.deal(1, color)
    end

    -- Edit the elements bags to be only 7, with Moon and Fire merged into Dark Fire
    -- Get the selectedColors table
    local selectedColors = Global.getTable("selectedColors")
    local elements = selectedColors[color].elements
    -- Edit the element bags
    if elements[2] then
        -- We want to move the elements back to more even spacing
        -- We take the distance between two elements, and move each inwards by half that
        -- We only need to halve x (not y and z), as they're in a row
        local transform = elements[3].getPosition() - elements[2].getPosition()
        transform.x = transform.x / 2

        elements[1].setPosition(elements[1].getPosition() + transform)
        for i=3,8 do
            elements[i].setPosition(elements[i].getPosition() - transform)
        end

        -- We destruct Moon, and darken Fire
        elements[2].destruct()
        elements[2] = nil
        makeDarkFire(elements[3])
    end
    -- Put the selectedColors table back
    selectedColors[color].elements = elements
    Global.setTable("selectedColors", selectedColors)

    -- Editing selectedColors invalidates the "selected" variable used by countItems()
    -- So restart countItems() by rerunning setupPlayerArea()
    -- We've changed selectedColors for all players, so restart it for all players
    Global.call("updateAllPlayerAreas")

    return true
end
