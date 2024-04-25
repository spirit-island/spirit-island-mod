spiritName = "Shroud of Silent Mist"

local val = 0

function onLoad(saved_data)
    local setupComplete = false
    -- NB: setupComplete in the script state is set by the global script
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        val = loaded_data.val
        setupComplete = loaded_data.setupComplete
    end

    if setupComplete then
        createCounterButtons()
    end
end

function onSave()
    -- We must build on the existing script state, to avoid overwriting setupComplete
    local data_table = {}
    if self.script_state ~= "" then
        data_table = JSON.decode(self.script_state)
    end
    data_table.val = val
    return JSON.encode(data_table)
end

function doSetup(params)
    createCounterButtons()
    return true
end

function changePhase(params)
    if params.phase == 2 then
        val = 0
        setCounter()

        local color = Global.call("getSpiritColor", {name = spiritName})
        local isolate = Global.getTable("selectedColors")[color].isolate
        local isoToken = isolate.takeObject({position = self.getPosition() + Vector(0,0.03,0)})
        isoToken.setName(isoToken.getName().." - Stranded in the Shifting Mist")
    elseif params.phase == 4 then
        val = 0
        setCounter()
    end
end

function createCounterButtons()
    self.createButton({
        click_function = "null",
        function_owner = self,
        label          = "Used\nPushes:",
        position       = Vector(-0.6,0.2,-0.7),
        rotation       = Vector(0,90,0),
        width          = 0,
        height         = 0,
        font_size      = 150,
        font_color     = {0, 0, 0},
    })
    self.createButton({
        click_function = "adjustValue",
        function_owner = self,
        label          = tostring(val).."/2",
        position       = Vector(-0.6,0.2,0.6),
        rotation       = Vector(0,90,0),
        width          = 500,
        height         = 350,
        font_size      = 300,
        font_color     = {0, 0, 0},
    })
end

function adjustValue(_,_,alt_click)
    val = alt_click and math.max(0,val-1) or math.min(2,val+1)
    setCounter()
end

function setCounter()
    self.editButton({
        index = 1,
        label = tostring(val).."/2",
    })
end

function null()
end
