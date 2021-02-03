sourceSpiritID = "21f561"
spiritsScanned = {}

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
    Wait.time(globalUpdate, 10, -1)
    rescan = false
end

function globalUpdate()
    local sScript = getObjectFromGUID(sourceSpiritID).getLuaScript()
    local sStrPos = string.find(sScript,"\n")
    local sSub = string.sub(sScript,1,sStrPos-10)

    for _,v in pairs (getAllObjects()) do
        if v.getGUID() ~= sourceSpiritID then
            if v.type == "Tile" then
                if v.name == "Custom_Tile" then
                    local aScript = v.getLuaScript()
                    if aScript ~= nil then
                        local aStrPos = string.find(aScript,"\n")
                        if aStrPos ~= nil and sStrPos ~= nil then
                            local aSub = string.sub(aScript,1,sStrPos-10)
                            if aSub == sSub then
                                if aScript ~= sScript then
                                    if not spiritsScanned[v.guid] then
                                        spiritsScanned[v.guid] = true
                                        v.setLuaScript(sScript)
                                        v = v.reload()
                                        v.highlightOn("Brown",10)
                                        broadcastToAll(v.getName().." has been updated to the current version!")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
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
        obje = objs[1]
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
    obj.setLuaScript(getObjectFromGUID(sourceSpiritID).getLuaScript())
    obj.reload()
    rescan = true
    scan()
end

function upCastPosSizRot(oPos,size,rot,dist,multi,tags)
    local rot = rot or {0,0,0}
    local dist = dist or 1
    local offset = offset or 0
    local multi = multi or 1
    local tags = tags or {}
    local oBounds = size
    local oRot = rot
    local orig = {oPos[1],oPos[2],oPos[3]}
    local siz = {oBounds[1]*multi,dist,oBounds[3]*multi}
    local orient = {oRot[1],oRot[2],oRot[3]}
    local hits = Physics.cast({
        origin       = orig,
        direction    = {0,1,0},
        type         = 3,
        size         = siz,
        orientation  = orient,
        max_distance = 0,
        --debug        = true,
    })
    local hitObjects = {}
    for i,v in pairs(hits) do
        if v.hit_object ~= obj then
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
    end
    return hitObjects
end