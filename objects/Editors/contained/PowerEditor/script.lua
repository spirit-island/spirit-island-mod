types = {"Minor", "Major", "Unique"}
speeds = {"Fast", "Slow"}

local rescan

function onLoad()
    self.createButton({
        click_function = "nullFunc",
        label = "Power Card\nEditor",
        font_color = {1,1,1},
        position = {0,1,0.8},
        width = 0,
        height = 0,
    })
    Wait.time(scan, 0.5, -1)
    rescan = false
end

function scan()
    local objs = upCast(self, 0.4, 0.1, {"Card"})
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
        local obj = objs[1]
        local energy = 0
        if obj.getVar("energy") ~= nil then
            energy = obj.getVar("energy")
        end
        local elements = "00000000"
        if obj.getVar("elements") ~= nil then
            elements = obj.getVar("elements")
        end
        local type = ""
        for _,tag in pairs(types) do
            if obj.hasTag(tag) then
                type = tag
                break
            end
        end
        local speed = ""
        for _,tag in pairs(speeds) do
            if obj.hasTag(tag) then
                speed = tag
                break
            end
        end
        createButtons(obj,energy,elements,type,speed)
    end
end

elementNames = {
    "Sun",
    "Moon",
    "Fire",
    "Air",
    "Water",
    "Earth",
    "Plant",
    "Animal",
}
elementColors = {
    "f9d81b",
    "dedac1",
    "f58546",
    "9460b3",
    "2b71b9",
    "6b5f5f",
    "3db23f",
    "d8232c",
}

function clearButtons()
    local buttons = self.getButtons()
    for i=2,#buttons do
        self.removeButton(buttons[i].index)
    end
end

function createButtons(card, cardEnergy, cardElements, type, speed)
    local zPadding = 0.1
    local zOffset = 9.25
    clearButtons()
    for i = 1,8 do
        self.createButton({
            click_function = "button"..i,
            function_owner = self,
            label          = "-",
            position       = {0.92,0.1,i*zPadding-(zOffset*zPadding/2)},
            scale          = {0.1,0.1,0.1},
            width          = 400,
            height         = 400,
            font_size      = 360,
            color          = hexToDec(elementColors[i])
        })
        local func = function() editElement(card,cardElements,-i,cardEnergy) end
        self.setVar("button"..i,func)
    end
    for i = 1,8 do
        self.createButton({
            click_function = "button"..i+8,
            function_owner = self,
            label          = "+",
            position       = {1.18,0.1,i*zPadding-(zOffset*zPadding/2)},
            scale          = {0.1,0.1,0.1},
            width          = 400,
            height         = 400,
            font_size      = 360,
            color          = hexToDec(elementColors[i])
        })
        local func = function() editElement(card,cardElements,i,cardEnergy) end
        self.setVar("button"..i+8,func)
    end
    for i = 1,8 do
        self.createButton({
            click_function = "nullFunc",
            label          = elementNames[i],
            position       = {0.7,0.1,i*zPadding-(zOffset*zPadding/2)},
            scale          = {0.1,0.1,0.1},
            width          = 1600,
            height         = 400,
            font_size      = 360,
            color          = hexToDec(elementColors[i])
        })
    end
    for i = 1,8 do
        self.createButton({
            click_function = "nullFunc",
            label          = string.sub(cardElements,i,i),
            position       = {1.05,0.1,i*zPadding-(zOffset*zPadding/2)},
            scale          = {0.1,0.1,0.1},
            width          = 800,
            height         = 400,
            font_size      = 360,
            color          = hexToDec(elementColors[i])
        })
    end
    self.createButton({
        click_function = "nullFunc",
        label          = "Energy",
        position       = {0.7,0.1,-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 1600,
        height         = 400,
        font_size      = 360,
    })
    self.createButton({
        click_function = "button17",
        function_owner = self,
        label          = "-",
        position       = {0.92,0.1,-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 360,
    })
    local func = function() editEnergy(card,cardEnergy,-1,cardElements) end
    self.setVar("button17",func)
    self.createButton({
        click_function = "nullFunc",
        label          = cardEnergy,
        position       = {1.05,0.1,-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 800,
        height         = 400,
        font_size      = 360,
    })
    self.createButton({
        click_function = "button18",
        function_owner = self,
        label          = "+",
        position       = {1.18,0.1,-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 360,
    })
    func = function() editEnergy(card,cardEnergy,1,cardElements) end
    self.setVar("button18",func)

    self.createButton({
        click_function = "nullFunc",
        label          = "Tag",
        position       = {0.615,0.1,9*zPadding-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 800,
        height         = 400,
        font_size      = 360,
    })
    self.createButton({
        click_function = "button19",
        function_owner = self,
        label          = "<",
        position       = {0.75,0.1,9*zPadding-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 360,
    })
    func = function() editTag(card,-1,types) end
    self.setVar("button19",func)
    self.createButton({
        click_function = "nullFunc",
        label          = type,
        position       = {0.965,0.1,9*zPadding-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 1600,
        height         = 400,
        font_size      = 360,
    })
    self.createButton({
        click_function = "button20",
        function_owner = self,
        label          = ">",
        position       = {1.18,0.1,9*zPadding-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 360,
    })
    func = function() editTag(card,1,types) end
    self.setVar("button20",func)

    self.createButton({
        click_function = "nullFunc",
        label          = "Speed",
        position       = {0.648,0.1,10*zPadding-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 1100,
        height         = 400,
        font_size      = 360,
    })
    self.createButton({
        click_function = "button21",
        function_owner = self,
        label          = "<",
        position       = {0.81,0.1,10*zPadding-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 360,
    })
    func = function() editTag(card,-1,speeds) end
    self.setVar("button21",func)
    self.createButton({
        click_function = "nullFunc",
        label          = speed,
        position       = {0.995,0.1,10*zPadding-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 1300,
        height         = 400,
        font_size      = 360,
    })
    self.createButton({
        click_function = "button22",
        function_owner = self,
        label          = ">",
        position       = {1.18,0.1,10*zPadding-(zOffset*zPadding/2)},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 360,
    })
    func = function() editTag(card,1,speeds) end
    self.setVar("button22",func)
end

function hexToDec(inp)
    inp = string.lower(inp)
    local colors = {}
    colors["R"] = string.sub(inp,1,1)
    colors["r"] = string.sub(inp,2,2)
    colors["G"] = string.sub(inp,3,3)
    colors["g"] = string.sub(inp,4,4)
    colors["B"] = string.sub(inp,5,5)
    colors["b"] = string.sub(inp,6,6)
    for i,c in pairs (colors) do
        if c == "a" then colors[i] = 10 end
        if c == "b" then colors[i] = 11 end
        if c == "c" then colors[i] = 12 end
        if c == "d" then colors[i] = 13 end
        if c == "e" then colors[i] = 14 end
        if c == "f" then colors[i] = 15 end
    end
    local red = colors["R"]*16+colors["r"]
    local green = colors["G"]*16+colors["g"]
    local blue = colors["B"]*16+colors["b"]
    return {red/255,green/255,blue/255}
end

local function updateCard(obj, energy, elements)
    obj.setVar("energy", energy)
    obj.setVar("elements", elements)
    local scriptString = "elements=\"" .. elements .. "\"\nenergy=" .. energy .. "\n"
    obj.setLuaScript(scriptString)
    obj.reload()
    rescan = true
    scan()
end

function editEnergy(obj,cardEnergy,energy,elements)
    hexToDec(elementColors[1])

    energy = math.max(0,cardEnergy+energy)
    updateCard(obj, energy, elements)
end

function editElement(obj,elements,e,cardEnergy)
    local function elemStrToArr(elemStr)
        local outArr = {}
        for i = 1, string.len(elemStr) do
            table.insert(outArr,(math.floor(string.sub(elemStr, i, i))))
        end
        return outArr
    end

    elements = elemStrToArr(elements)
    local elementsOut = ""
    local j = math.abs(e)
    if e > 0 then e = 1 else e = -1 end
    for i = 1,8 do
        local currentElement = elements[i]
        if j == i then
            elementsOut = elementsOut..math.min(9,math.max(0,currentElement+e))
        else
            elementsOut = elementsOut..currentElement
        end
    end
    updateCard(obj, cardEnergy, elementsOut)
end

function editTag(obj, modifier, tags)
    local index = 0
    for i,tag in pairs(tags) do
        if obj.hasTag(tag) then
            index = i
            break
        end
    end
    index = (index + modifier) % (#tags + 1)
    for i,tag in pairs(tags) do
        if i == index then
            obj.addTag(tag)
        else
            obj.removeTag(tag)
        end
    end
    rescan = true
    scan()
end

function upCast(obj,dist,offset,types)
    dist = dist or 1
    offset = offset or 0
    types = types or {}
    local hits = Physics.cast({
        origin       = obj.getPosition() + Vector(0,offset,0),
        direction    = Vector(0,1,0),
        type         = 3,
        size         = obj.getBoundsNormalized().size,
        orientation  = obj.getRotation(),
        max_distance = dist,
        --debug        = true,
    })
    local hitObjects = {}
    for _,v in pairs(hits) do
        if types ~= {} then
            local matchesType = false
            for _,t in pairs(types) do
                if v.hit_object.type == t then matchesType = true end
            end
            if matchesType then
                table.insert(hitObjects,v.hit_object)
            end
        else
            table.insert(hitObjects,v.hit_object)
        end
    end
    return hitObjects
end