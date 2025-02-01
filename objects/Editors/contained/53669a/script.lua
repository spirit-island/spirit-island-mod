local rescan

function onLoad()

    self.createButton({
        click_function = "nullFunc",
        label = "Place\nBlight\nCard\nHere",
        font_color = {1,1,1},
        position = {0,0.1,0},
        font_size = 300,
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
        local blight = 0
        if obj.getVar("blight") ~= nil then
            blight = obj.getVar("blight")
        end
        local immediate = false
        if obj.getVar("immediate") then
            immediate = true
        end
        local healthy = false
        if obj.getVar("healthy") then
            healthy = true
        end
        createButtons(obj,blight,immediate,healthy)
    end
end

function clearButtons()
    local buttons = self.getButtons()
    for i=2,#buttons do
        self.removeButton(buttons[i].index)
    end
end

function createButtons(card,cardBlight,cardImmediate,cardHealthy)
    local scale = {0.47, 0.47, 0.47}
    local zPadding = 0.4
    local zOffset = 9.8
    clearButtons()
    self.createButton({
        click_function = "nullFunc",
        label          = "Blight",
        position       = {2.5,0.1,-0.1*zPadding-(zOffset*zPadding/2)},
        scale          = scale,
        width          = 1600,
        height         = 400,
        font_size      = 360,
    })
    self.createButton({
        click_function = "button1",
        function_owner = self,
        label          = "-",
        position       = {3.525,0.1,-0.1*zPadding-(zOffset*zPadding/2)},
        scale          = scale,
        width          = 400,
        height         = 400,
        font_size      = 360,
    })
    local func = function() editBlight(card,cardBlight,-1,cardImmediate,cardHealthy) end
    self.setVar("button1",func)
    self.createButton({
        click_function = "nullFunc",
        label          = cardBlight,
        position       = {4.15,0.1,-0.1*zPadding-(zOffset*zPadding/2)},
        scale          = scale,
        width          = 800,
        height         = 400,
        font_size      = 360,
    })
    self.createButton({
        click_function = "button2",
        function_owner = self,
        label          = "+",
        position       = {4.775,0.1,-0.1*zPadding-(zOffset*zPadding/2)},
        scale          = scale,
        width          = 400,
        height         = 400,
        font_size      = 360,
    })
    func = function() editBlight(card,cardBlight,1,cardImmediate,cardHealthy) end
    self.setVar("button2",func)

    self.createButton({
        click_function = "nullFunc",
        label          = "Only\n\"Immediate\"\nEffects?",
        position       = {2.8,0.1,2.9*zPadding-(zOffset*zPadding/2)},
        scale          = scale,
        width          = 2200,
        height         = 1200,
        font_size      = 360,
    })
    local label = "No"
    if cardImmediate then
        label = "Yes"
    end
    self.createButton({
        click_function = "nullFunc",
        label          = label,
        position       = {4.225,0.1,1.9*zPadding-(zOffset*zPadding/2)},
        scale          = scale,
        width          = 600,
        height         = 400,
        font_size      = 360,
    })
    self.createButton({
        click_function = "button4",
        function_owner = self,
        label          = ">",
        position       = {4.775,0.1,1.9*zPadding-(zOffset*zPadding/2)},
        scale          = scale,
        width          = 400,
        height         = 400,
        font_size      = 360,
    })
    func = function() editImmediate(card,cardBlight,cardImmediate,cardHealthy) end
    self.setVar("button4",func)


    self.createButton({
        click_function = "nullFunc",
        label          = "Still-Healthy?",
        position       = {2.8,0.1,0.9*zPadding-(zOffset*zPadding/2)},
        scale          = scale,
        width          = 2200,
        height         = 400,
        font_size      = 360,
    })
    label = "No"
    if cardHealthy then
        label = "Yes"
    end
    self.createButton({
        click_function = "nullFunc",
        label          = label,
        position       = {4.225,0.1,0.9*zPadding-(zOffset*zPadding/2)},
        scale          = scale,
        width          = 600,
        height         = 400,
        font_size      = 360,
    })
    self.createButton({
        click_function = "button6",
        function_owner = self,
        label          = ">",
        position       = {4.775,0.1,0.9*zPadding-(zOffset*zPadding/2)},
        scale          = scale,
        width          = 400,
        height         = 400,
        font_size      = 360,
    })
    func = function() editHealthy(card,cardBlight,cardImmediate,cardHealthy) end
    self.setVar("button6",func)
end

local function updateCard(obj, blight, immediate, healthy)
    local scriptString = "blight=" .. blight
    if immediate then
        scriptString = scriptString .. "\nimmediate=true"
    end
    if healthy then
        scriptString = scriptString .. "\nhealthy=true"
    end
    obj.setLuaScript(scriptString .. "\n")
    obj.reload()
    rescan = true
    scan()
end

function editBlight(obj, cardBlight, blightChange, cardImmediate, cardHealthy)
    local newBlight = math.max(1, cardBlight + blightChange)
    updateCard(obj, newBlight, cardImmediate, cardHealthy)
end

function editImmediate(obj, cardBlight, immediate, cardHealthy)
    immediate = not immediate
    updateCard(obj, cardBlight, immediate, cardHealthy)
end
function editHealthy(obj, cardBlight, cardImmediate, healthy)
    healthy = not healthy
    updateCard(obj, cardBlight, cardImmediate, healthy)
end

function upCast(obj,dist,offset,types)
    dist = dist or 1
    offset = offset or 0
    types = types or {}
    local hits = Physics.cast({
        origin       = obj.getPosition() + Vector(0,offset,0),
        direction    = Vector(0,1,0),
        type         = 3,
        size         = obj.getBounds().size,
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
