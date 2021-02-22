sourceSpiritID = "21f561"

local rescan

function onLoad()
    self.createButton({
        click_function = "nullFunc",
        label = "Spirit Board\nValidator",
        font_color = {1,1,1},
        position = {0,1,0.65},
        scale = {0.3,0.3,0.5},
        width = 0,
        height = 0,
    })
    Wait.time(scan, 0.5, -1)
    rescan = false
end

function scan()
    local objs = upCastPosSizRot(
        {self.getPosition().x,self.getPosition().y+0.2,self.getPosition().z},
        {0,1,0},
        {0,0,0},
        0.4,
        0.2,
        {"Tile"}
    )
    if #objs == 0 then
        clearButtons()
        return
    end
    if #objs > 1 then
        clearButtons()
        return
    end
    if rescan or #self.getButtons() == 1 then
        rescan = false
        local obje = objs[1]
        createButtons(obje)
    end
end

function clearButtons()
    local buttons = self.getButtons()
    for i=2,#buttons do
        self.removeButton(buttons[i].index)
    end
end

function createButtons(obj)
    if getObjectFromGUID(sourceSpiritID).getLuaScript() == obj.getLuaScript() then
        if not obj.hasTag("Spirit") then
            obj.addTag("Spirit")
        end
        self.createButton({
            click_function = "nullFunc",
            label          = "Spirit Validated",
            position       = {0,0.1,-0.6},
            scale          = {0.1,0.1,0.1},
            width          = 4800,
            height         = 800,
            font_size      = 600,
        })
    else
        self.createButton({
            click_function = "button1",
            function_owner = self,
            label          = "Make Me A Spirit!",
            position       = {0,0.1,-0.6},
            scale          = {0.1,0.1,0.1},
            width          = 4800,
            height         = 800,
            font_size      = 600,
        })
    end

    local func = function() makeSpirit(obj) end
    self.setVar("button1",func)
end

function makeSpirit(obj)
    obj.addTag("Spirit")
    obj.setLuaScript(getObjectFromGUID(sourceSpiritID).getLuaScript())
    obj.reload()
    rescan = true
    scan()
end

function upCastPosSizRot(oPos,size,rot,dist,multi,tags)
    local rot = rot or Vector(0,0,0)
    local dist = dist or 1
    local multi = multi or 1
    local tags = tags or {}
    local oBounds = size
    local oRot = rot
    local orig = Vector(oPos[1],oPos[2],oPos[3])
    local siz = Vector(oBounds[1]*multi,dist,oBounds[3]*multi)
    local orient = Vector(oRot[1],oRot[2],oRot[3])
    local hits = Physics.cast({
        origin       = orig,
        direction    = Vector(0,1,0),
        type         = 3,
        size         = siz,
        orientation  = orient,
        max_distance = 0,
        --debug        = true,
    })
    local hitObjects = {}
    for _,v in pairs(hits) do
        if tags ~= {} then
            local matchesTag = false
            for _,t in pairs(tags) do
                if v.hit_object.type == t then matchesTag = true end
            end
            if matchesTag then
                table.insert(hitObjects,v.hit_object)
            end
        else
            table.insert(hitObjects,v.hit_object)
        end
    end
    return hitObjects
end
