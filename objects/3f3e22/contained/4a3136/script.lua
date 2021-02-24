local Raycast = require('Raycast')

local rescan

function onLoad()
    self.createButton({
        click_function = "nullFunc",
        label = "Blight Card\nEditor",
        font_color = {1,1,1},
        position = {0,1,0.8},
        width = 0,
        height = 0,
    })
    Wait.time(scan, 0.5, -1)
    rescan = false
end

function scan()
    local objs = Raycast.upCast(self, 0.4, 0.1, {"Card"})
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
    clearButtons()
    self.createButton({
        click_function = "nullFunc",
        label          = "Blight",
        position       = {0.7,0.1,-0.35},
        scale          = {0.1,0.1,0.1},
        width          = 1600,
        height         = 400,
        font_size      = 300,
    })
    self.createButton({
        click_function = "button1",
        function_owner = self,
        label          = "-",
        position       = {0.92,0.1,-0.35},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 300,
    })
    local func = function() editBlight(card,cardBlight,-1,cardImmediate,cardHealthy) end
    self.setVar("button1",func)
    self.createButton({
        click_function = "nullFunc",
        label          = cardBlight,
        position       = {1.05,0.1,-0.35},
        scale          = {0.1,0.1,0.1},
        width          = 800,
        height         = 400,
        font_size      = 300,
    })
    self.createButton({
        click_function = "button2",
        function_owner = self,
        label          = "+",
        position       = {1.18,0.1,-0.35},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 300,
    })
    local func = function() editBlight(card,cardBlight,1,cardImmediate,cardHealthy) end
    self.setVar("button2",func)
    self.createButton({
        click_function = "nullFunc",
        label          = "Immediate",
        position       = {0.7,0.1,-0.25},
        scale          = {0.1,0.1,0.1},
        width          = 1600,
        height         = 400,
        font_size      = 300,
    })
    self.createButton({
        click_function = "button3",
        function_owner = self,
        label          = "-",
        position       = {0.92,0.1,-0.25},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 300,
    })
    local func = function() editImmediate(card,cardBlight,false,cardHealthy) end
    self.setVar("button3",func)
    local label = "No"
    if cardImmediate then
        label = "Yes"
    end
    self.createButton({
        click_function = "nullFunc",
        label          = label,
        position       = {1.05,0.1,-0.25},
        scale          = {0.1,0.1,0.1},
        width          = 800,
        height         = 400,
        font_size      = 300,
    })
    self.createButton({
        click_function = "button4",
        function_owner = self,
        label          = "+",
        position       = {1.18,0.1,-0.25},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 300,
    })
    local func = function() editImmediate(card,cardBlight,true,cardHealthy) end
    self.setVar("button4",func)
    self.createButton({
        click_function = "nullFunc",
        label          = "Healthy",
        position       = {0.7,0.1,-0.15},
        scale          = {0.1,0.1,0.1},
        width          = 1600,
        height         = 400,
        font_size      = 300,
    })
    self.createButton({
        click_function = "button5",
        function_owner = self,
        label          = "-",
        position       = {0.92,0.1,-0.15},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 300,
    })
    local func = function() editHealthy(card,cardBlight,cardImmediate,false) end
    self.setVar("button5",func)
    local label = "No"
    if cardHealthy then
        label = "Yes"
    end
    self.createButton({
        click_function = "nullFunc",
        label          = label,
        position       = {1.05,0.1,-0.15},
        scale          = {0.1,0.1,0.1},
        width          = 800,
        height         = 400,
        font_size      = 300,
    })
    self.createButton({
        click_function = "button6",
        function_owner = self,
        label          = "+",
        position       = {1.18,0.1,-0.15},
        scale          = {0.1,0.1,0.1},
        width          = 400,
        height         = 400,
        font_size      = 300,
    })
    local func = function() editHealthy(card,cardBlight,cardImmediate,true) end
    self.setVar("button6",func)
end

function editBlight(obj,cardBlight,blight,cardImmediate,cardHealthy)
    blight = math.max(1,cardBlight+blight)
    local scriptString = "blight="..blight
    if cardImmediate then
        scriptString = scriptString.."\nimmediate=true"
    end
    if cardHealthy then
        scriptString = scriptString.."\nhealthy=true"
    end
    obj.setLuaScript(scriptString)
    obj.reload()
    rescan = true
    scan()
end
function editImmediate(obj,cardBlight,immediate,cardHealthy)
    local scriptString = "blight="..cardBlight
    if immediate then
        scriptString = scriptString.."\nimmediate=true"
    end
    if cardHealthy then
        scriptString = scriptString.."\nhealthy=true"
    end
    obj.setLuaScript(scriptString)
    obj.reload()
    rescan = true
    scan()
end
function editHealthy(obj,cardBlight,cardImmediate,healthy)
    local scriptString = "blight="..cardBlight
    if cardImmediate then
        scriptString = scriptString.."\nimmediate=true"
    end
    if healthy then
        scriptString = scriptString.."\nhealthy=true"
    end
    obj.setLuaScript(scriptString)
    obj.reload()
    rescan = true
    scan()
end
