difficulty=0

requirements = true
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
    postSetupComplete = true
end

function ExportConfig()
    local data = {}
    data.numPlayers = Global.getVar("numPlayers")
    data.boardLayout = Global.getVar("boardLayout")
    data.extraBoard = (Global.getVar("numBoards") - data.numPlayers) == 1
    data.boards = Global.getTable("boards")
    local obj = Global.getVar("blightedIslandCard")
    -- Only store the blight card and count if the island is blighted
    if obj ~= nil and Global.getVar("blightedIsland") then
        data.blightCard = obj.getName()

        obj = Global.getVar("blightBag")
        data.secondWaveBlight = #obj.getObjects() - (2 * Global.getVar("numBoards"))
        if Global.getVar("SetupChecker").getVar("optionalBlightSetup") then
            data.secondWaveBlight = data.secondWaveBlight - 1
        end
    end
    obj = Global.getVar("adversaryCard")
    if obj ~= nil then
        data.adversary = obj.getName()
        data.adversaryLevel = Global.getVar("adversaryLevel")
        -- If the island is not blighted increase adversary level by 1
        if not data.blightCard then
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
        if not data.blightCard then
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
    data.bnc = Global.getVar("BnCAdded")
    data.je = Global.getVar("JEAdded")
    updateNotebook(JSON.encode_pretty(data))
end
function updateNotebook(json)
    for _,data in pairs(Notes.getNotebookTabs()) do
        if data.title == "Game Config" then
            Notes.editNotebookTab({
                index = data.index,
                body = json,
            })
            break
        end
    end
end
