local threshold = {0,0,0,0,0,0,0,0}
local editMode = false
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

function onLoad()
    local state = self.script_state
    if state ~= "" then
        local data = JSON.decode(state)
        threshold = data.threshold or threshold
        editMode = data.editMode or editMode
    end
    updateButtons()
end

function updateButtons()
    if editMode then
        self.clearButtons()
        local paddingX = 1.1
        for i = 1,8 do
            self.createButton({
                click_function = "button"..i,
                function_owner = self,
                label = ">",
                rotation = {0,90,0},
                font_size = 500,
                color = hexToDec(elementColors[i]),
                font_color = {0,0,0},
                position = {0.5+i*paddingX,0.1,1},
                width = 400,
                height = 500,
            })
            local func = function() editThreshold(i,-1) end
            self.setVar("button"..i,func)

            self.createButton({
                click_function = "nullFunc",
                function_owner = self,
                label = threshold[i],

                font_size = 500,
                color = hexToDec(elementColors[i]),
                font_color = {0,0,0},
                position = {0.5+i*paddingX,0.1,0},
                width = 500,
                height = 500,
            })

            self.createButton({
                click_function = "button"..i+8,
                function_owner = self,
                label = "<",
                rotation = {0,90,0},
                font_size = 500,
                color = hexToDec(elementColors[i]),
                font_color = {0,0,0},
                position = {0.5+i*paddingX,0.1,-1},
                width = 400,
                height = 500,
            })
            func = function() editThreshold(i,1) end
            self.setVar("button"..i+8,func)
        end
        self.createButton({
            click_function = "changeButtons",
            function_owner = self,
            label = "Hide",
	    rotation = {0,270,0},
            font_size = 400,
            color = {1,1,1},
            font_color = {0,0,0},
            position = {-1.6,0.1,0},
            width = 1000,
            height = 500,
        })
    else
        self.clearButtons()
        self.createButton({
            click_function = "changeButtons",
            function_owner = self,
            label = "Show",
	    rotation = {0,270,0},
            font_size = 400,
            color = {1,1,1},
            font_color = {0,0,0},
            position = {-1.6,0.1,0},
            width = 1000,
            height = 500,
        })
    end
end

function editThreshold(eleIndex, num)
    threshold[eleIndex] = math.max(threshold[eleIndex]+num,0)
    self.script_state = JSON.encode({
        threshold = threshold,
        editMode = editMode
    })
    updateButtons()
end

function changeButtons()
    editMode = not editMode
    self.script_state = JSON.encode({
        threshold = threshold,
        editMode = editMode
    })
    updateButtons()
end

function nullFunc()
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
