difficulty=0

requirements = true
mapSetup = true
postSetup = true
postSetupComplete = false

function onLoad()
    if Global.getVar("gameStarted") then
        self.createButton({
            click_function = "ExportConfig",
            function_owner = self,
            label          = "Export Config",
            position       = Vector(0.6, 1, -1.1),
            rotation       = Vector(0,0,0),
            scale          = Vector(0.2,0.2,0.2),
            width          = 1800,
            height         = 500,
            font_size      = 300,
        })
    end
end

function Requirements(params)
    return params.adversary
end
function MapSetup(params)
    local config = readConfig()
    if not config or not config.secondWave or not config.secondWave.wave then
        return params.pieces
    end

    for i=1,#params.original do
        for j=#params.original[i],1,-1 do
            if string.sub(params.original[i][j],1,5) == "Wilds"
                    or string.sub(params.original[i][j],1,7) == "Disease"
                    or string.sub(params.original[i][j],1,6) == "Beasts"
                    or string.sub(params.original[i][j],1,8) == "Badlands"
                    or string.sub(params.original[i][j],1,5) == "Dahan"
                    or string.sub(params.original[i][j],1,10) == "Box Blight" then
                table.remove(params.pieces[i],j)
            elseif string.sub(params.original[i][j],1,9) == "ExplorerS"
                    or string.sub(params.original[i][j],1,5) == "TownS"
                    or string.sub(params.original[i][j],1,5) == "CityS" then
                params.pieces[i][j] = string.sub(params.original[i][j],1,-2)
            end
        end
    end

    local shift = math.max(5 - config.secondWave.wave, 0)
    for i=6,#params.pieces do
        for j=#params.pieces[i],1,-1 do
            if string.sub(params.pieces[i][j],1,8) == "Explorer"
                    or string.sub(params.pieces[i][j],1,4) == "Town"
                    or string.sub(params.pieces[i][j],1,4) == "City" then
                table.insert(params.pieces[i-shift],params.pieces[i][j])
                table.remove(params.pieces[i],j)
            end
        end
    end

    local count = config.secondWave.wave - 1
    for i=5,1,-1 do
        if count > 0 then
            count = count - 1
            table.insert(params.pieces[i],"Town")
        end
        if count <= 0 then
            break
        end
    end
    -- Not sure people can make it past wave 9, so we should be safe here
    for i=6,8 do
        if count > 0 then
            count = count - 1
            table.insert(params.pieces[i],"Town")
        end
        if count <= 0 then
            break
        end
    end
    return params.pieces
end
function PostSetup(params)
    self.createButton({
        click_function = "ExportConfig",
        function_owner = self,
        label          = "Export Config",
        position       = Vector(0.6, 1, -1.1),
        rotation       = Vector(0,0,0),
        scale          = Vector(0.2,0.2,0.2),
        width          = 1800,
        height         = 500,
        font_size      = 300,
    })

    local config = readConfig()
    if config and config.secondWave then
        if config.secondWave.blight then
            blightCount = config.secondWave.blight
        end
        if config.secondWave.wave then
            broadcastToAll("Adversary Blight should have come from the card not the box, so you might need to manually fix this", "Red")
        end
    end

    postSetupComplete = true
end
function readConfig()
    for _,data in pairs(Notes.getNotebookTabs()) do
        if data.title == "Game Config" then
            if data.body == "" then return nil end
            return JSON.decode(data.body)
        end
    end
    return nil
end

function ExportConfig()
    self.clearButtons()
    local data = {}
    data.secondWave = {}
    local config = readConfig()
    if config and config.secondWave and config.secondWave.wave then
        data.secondWave.wave = config.secondWave.wave + 1
    else
        data.secondWave.wave = 2
    end

    data.numPlayers = Global.getVar("numPlayers")
    data.boardLayout = Global.getVar("boardLayout")
    data.extraBoard = (Global.getVar("numBoards") - data.numPlayers) == 1
    data.boards = Global.getTable("selectedBoards")
    local obj = Global.getVar("blightedIslandCard")
    -- Only store the blight card and count if the island is blighted
    if obj ~= nil and Global.getVar("blightedIsland") then
        data.blightCard = obj.getName()

        obj = Global.getVar("blightBag")
        local multiplier = data.secondWave.wave
        data.secondWave.blight = #obj.getObjects() - (multiplier * Global.getVar("numBoards"))
        if Global.getVar("SetupChecker").getVar("optionalBlightSetup") then
            data.secondWave.blight = data.secondWave.blight - 1
        end
        data.secondWave.blight = math.max(data.secondWave.blight, 0)
    end
    obj = Global.getVar("adversaryCard")
    if obj ~= nil then
        data.adversary = obj.getName()
        data.adversaryLevel = Global.getVar("adversaryLevel")
        -- If the island is not blighted increase adversary level by 1
        if not data.blightCard and data.adversaryLevel < 6 then
            data.adversaryLevel = data.adversaryLevel + 1
        end
    else
        data.adversary = ""
        data.adversaryLevel = 0
    end
    obj = Global.getVar("adversaryCard2")
    if obj ~= nil then
        data.adversary2 = obj.getName()
        data.adversaryLevel2 = Global.getVar("adversaryLevel2")
        -- If the island is not blighted increase adversary level by 1
        if not data.blightCard and data.adversaryLevel2 < 6 then
            data.adversaryLevel2 = data.adversaryLevel2 + 1
        end
    else
        data.adversary2 = ""
        data.adversaryLevel2 = 0
    end
    obj = Global.getVar("scenarioCard")
    if obj ~= nil then
        data.scenario = obj.getName()
    else
        data.scenario = ""
    end
    data.expansions = {}
    if Global.getVar("BnCAdded") then
        table.insert(data.expansions, "bnc")
    end
    if Global.getVar("JEAdded") then
        table.insert(data.expansions, "je")
    end
    updateNotebook(JSON.encode_pretty(data))
end
function updateNotebook(json)
    for _,data in pairs(Notes.getNotebookTabs()) do
        if data.title == "Game Config" then
            Notes.editNotebookTab({
                index = data.index,
                body = json,
            })
            broadcastToAll("Notebook Tab \"Game Config\" has been updated", "White")
            break
        end
    end
end
