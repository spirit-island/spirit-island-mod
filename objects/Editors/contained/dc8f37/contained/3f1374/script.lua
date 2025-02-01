local count = 0
local bonusMode = false

function onLoad()
    local state = self.script_state
    if state and state ~= "" then
        local data = JSON.decode(state)
        count = data.count or count
        bonusMode = data.bonusMode or bonusMode
    end
    updateButtons()
end

function updateButtons()
    self.clearButtons()
        self.createButton({
            click_function = "button1",
            function_owner = self,
            label = ">",
            rotation = {0,90,0},
            font_size = 400,
            position = {0,0.3,0.75},
            width = 320,
            height = 400,
        })
        local func = function() editCount(-1) end
        self.setVar("button1",func)

        self.createButton({
            click_function = "nullFunc",
            function_owner = self,
            label = count,
            font_size = 400,
            position = {0,0.3,0},
            width = 400,
            height = 400,
        })

        self.createButton({
            click_function = "button2",
            function_owner = self,
            label = "<",
            rotation = {0,90,0},
            font_size = 400,
            position = {0,0.3,-0.75},
            width = 320,
            height = 400,
        })
        func = function() editCount(1) end
        self.setVar("button2",func)

        local bonus = ""
        if bonusMode then
            bonus = "+"
        end
        self.createButton({
            click_function = "changeBonus",
            function_owner = self,
            label = bonus,
            font_size = 500,
            position = {-0.75,0.3,0},
            width = 300,
            height = 300,
        })
end

function editCount(num)
    count = math.max(count+num,0)
    self.script_state = JSON.encode({
        count = count,
        bonusMode = bonusMode
    })
    updateButtons()
end

function changeBonus()
    bonusMode = not bonusMode
    self.script_state = JSON.encode({
        count = count,
        bonusMode = bonusMode
    })
    updateButtons()
end

function nullFunc()
end
