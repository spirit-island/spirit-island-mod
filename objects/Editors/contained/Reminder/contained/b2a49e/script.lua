-- Gets the object (spirit or power card) beneath the reminder token
function getObject()
    local hits = Physics.cast({
        origin = self.getBounds().center,
        direction = Vector(0,-1,0),
        max_distance = 2,
    })
    for _,v in pairs(hits) do
        local obj = v.hit_object
        if obj.hasTag("Spirit") or obj.type == "Card" then
            return obj
        end
    end
    return nil
end

-- Gets a set of parameters for image location suitable to be saved to script state
-- These are agnostic of the actual image on the object, and of the mask size
function getImageLocation(params)
    local obj = params.obj
    if obj == nil then
        return nil
    end

    local location = {}

    if obj.type == "Card" then
        location.field = "FaceURL"
    elseif obj.is_face_down then
        location.field = "ImageSecondaryURL"
    else
        location.field = "ImageURL"
    end

    local selfPos = self.getPosition()
    local objPos = obj.getPosition()
    local selfBounds = self.getBounds()
    local objBounds = obj.getBounds()
    local selfSize = selfBounds.size.x -- We're not quite square, so only use our width

    location.width = objBounds.size.x / selfSize
    location.height = objBounds.size.z / selfSize

    location.x = (objPos.x - selfPos.x) / objBounds.size.x * location.width
    location.y = (objPos.z - selfPos.z) / objBounds.size.z * location.height

    return location
end

-- Sets this object's position and size above a given object such that getImageLocation() would return a given location.
-- We can't do this with takeObject(), as that can't set size.
-- So we might as well do this here, so that the code sits next to getImageLocation().
function setToLocation(params)
    local obj = params.obj
    if obj == nil then
        return
    end

    local location = params.location
    if location == nil then
        location = getDefaultLocation({obj = obj})
    end
    if location == nil then
        return
    end

    local objPos = obj.getPosition()
    local selfBounds = self.getBounds()
    local objBounds = obj.getBounds()
    local selfSize = selfBounds.size.x

    local desiredX = objPos.x - location.x * objBounds.size.x / location.width
    local desiredZ = objPos.z - location.y * objBounds.size.z / location.height
    local desiredY = objPos.y + 1
    self.setPosition(Vector(desiredX, desiredY, desiredZ))

    local desiredSize = objBounds.size.x / location.width
    self.setScale(self.getScale():scale(desiredSize / selfSize))
end

-- TODO: Shunt getDefaultLocation() and getImageAttributes() up to global so they can be used there.

function getDefaultLocation(params)
    local obj = params.obj
    if obj == nil then
        return nil
    end

    if obj.type == "Card" then
        return {
            field = "FaceURL",
            x = -0.17,
            y = -0.45,
            width = 1.85,
            height = 2.59,
        }
    elseif obj.hasTag("Spirit") then
        return {
            field = "ImageSecondaryURL",
            x = 0.63,
            y = -0.23,
            width = 2.40,
            height = 1.60,
        }
    else
        return nil
    end
end

-- Gets the image attributes to be set in the UI
function getImageAttributes(params)
    local objSize = 200 -- The height/width of UI panel to be the same size as the object

    local obj = params.obj
    if obj == nil then
        return {image = ""}
    end

    local location = params.location
    if location == nil then
        location = getDefaultLocation({obj = obj})
    end

    local imageURL = ""
    local data = obj.getData()
    if obj.type == "Card" then
        if data.CustomDeck then
            for _,d in pairs(data.CustomDeck) do
                if d.NumWidth == 1 and d.NumHeight == 1 then
                    imageURL = d[location.field]
                end
            end
        end
    else
        imageURL = data.CustomImage[location.field]
    end

    return {
        image = imageURL,
        position = tostring(location.x * objSize).." "..tostring(location.y * objSize).." 0",
        width = tostring(location.width * objSize),
        height = tostring(location.height * objSize),
    }
end

function updateImage()
    local obj = getObject()
    local location = getImageLocation({obj = obj})
    local attributes = getImageAttributes({obj = obj, location = location})
    self.UI.setAttributes("image", attributes)
end

function onLoad()
    Wait.time(updateImage, 0.1, -1)
end
