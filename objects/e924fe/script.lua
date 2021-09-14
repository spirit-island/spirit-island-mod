difficulty=0
broadcast=nil

requirements = true
mapSetup = true
postSetup = true
postSetupComplete = false
blightCount = nil

function onLoad()
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
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

    for i=1,#params.pieces do
        for j=#params.pieces[i],1,-1 do
            if params.pieces[i][j] == "Wilds"
                    or params.pieces[i][j] == "Disease"
                    or params.pieces[i][j] == "Beasts"
                    or params.pieces[i][j] == "Badlands"
                    or params.pieces[i][j] == "Dahan"
                    or params.pieces[i][j] == "Box Blight" then
                table.remove(params.pieces[i],j)
            elseif string.sub(params.pieces[i][j],1,9) == "ExplorerS"
                    or string.sub(params.pieces[i][j],1,5) == "TownS"
                    or string.sub(params.pieces[i][j],1,5) == "CityS" then
                params.pieces[i][j] = string.sub(params.pieces[i][j],1,-2)
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
    local scenarioBag = Global.getVar("scenarioBag")
    local powersBag = scenarioBag.takeObject({
        guid = "8d6e45",
        position = {-45.24, 0.84, 36.64},
        rotation = {0,180,0},
        smooth = false,
        callback_function = function(obj) obj.setLock(true) end,
    })

    local config = readConfig()
    if config and config.secondWave then
        if config.secondWave.blight then
            blightCount = config.secondWave.blight
        end
        if config.secondWave.wave then
            broadcast = "Starting Wave "..config.secondWave.wave.." - Second Wave"
            broadcastToAll("Adversary Blight should have come from the card not the box, so you might need to manually fix this", Color.Red)
        end
        if config.secondWave.powers then
            local minorPowerDeck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
            local majorPowerDeck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
            for guid,tag in pairs(config.secondWave.powers) do
                local found = false
                if tag == "Minor" then
                    for _,data in pairs(minorPowerDeck.getObjects()) do
                        if data.guid == guid then
                            local card = minorPowerDeck.takeObject({
                                guid = guid,
                                smooth = false,
                            })
                            powersBag.putObject(card)
                            found = true
                            break
                        end
                    end
                elseif tag == "Major" then
                    for _,data in pairs(majorPowerDeck.getObjects()) do
                        if data.guid == guid then
                            local card = majorPowerDeck.takeObject({
                                guid = guid,
                                smooth = false,
                            })
                            powersBag.putObject(card)
                            found = true
                            break
                        end
                    end
                elseif tag == "Unique" then
                    local objs = getObjectsWithTag("Unique")
                    for _,obj in pairs(objs) do
                        if obj.type == "Deck" then
                            for _,data in pairs(obj.getObjects()) do
                                if data.guid == guid then
                                    local card = obj.takeObject({
                                        guid = guid,
                                        smooth = false,
                                    })
                                    powersBag.putObject(card)
                                    found = true
                                    break
                                end
                            end
                        elseif obj.type == "Card" then
                            if obj.guid == guid then
                                powersBag.putObject(obj)
                                found = true
                            end
                        end
                        if found then
                            break
                        end
                    end
                end

                if not found then
                    broadcastToAll("Unable to find "..tag.." Power Card with guid "..guid, Color.Red)
                end
            end
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
    local powersBag = getObjectFromGUID("8d6e45")
    local bagPowers = nil
    if powersBag ~= nil then
        bagPowers = powersBag.getObjects()
        if #bagPowers == 0 then
            broadcastToAll("Powers Bag is currently empty, did you forget to add the power cards for next game in there?", Color.SoftYellow)
            return
        end
    end
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
    data.variant = {}
    data.variant.extraBoard = (Global.getVar("numBoards") - data.numPlayers) == 1
    local extraBoardRandom = Global.getVar("randomBoard")
    if extraBoardRandom ~= nil then
        data.variant.extraBoardRandom = extraBoardRandom
    end
    local selectedBoards = Global.getTable("selectedBoards")
    if selectedBoards and #selectedBoards > 0 then
        data.boards = selectedBoards
    end
    data.blightCards = Global.getTable("blightCards")
    local blightedIsland = Global.getVar("blightedIsland")
    if blightedIsland then
        -- Only store the blight count if the island is blighted
        local obj = Global.getVar("blightBag")
        data.secondWave.blight = #obj.getObjects() - (2 * Global.getVar("numBoards"))
        if Global.getVar("SetupChecker").getVar("optionalBlightSetup") then
            data.secondWave.blight = data.secondWave.blight - 1
        end
        data.secondWave.blight = math.max(data.secondWave.blight, 0)
    end
    local obj = Global.getVar("adversaryCard")
    if obj ~= nil then
        data.adversary = obj.getName()
        data.adversaryLevel = Global.getVar("adversaryLevel")
        -- If the island is not blighted increase adversary level by 1
        if not blightedIsland and data.adversaryLevel < 6 then
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
        if not blightedIsland and data.adversaryLevel2 < 6 then
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
    for expansion,added in pairs(Global.getTable("expansions")) do
        if added then
            table.insert(data.expansions, expansion)
        end
    end
    data.events = {}
    for expansion,added in pairs(Global.getTable("events")) do
        if added then
            table.insert(data.events, expansion)
        end
    end
    if powersBag ~= nil then
        local powers = {}
        local inserted = false
        for _, card in pairs(bagPowers) do
            local tag = ""
            for _,cardTag in pairs(card.tags) do
                if cardTag == "Minor" then
                    tag = cardTag
                    break
                elseif cardTag == "Major" then
                    tag = cardTag
                    break
                elseif cardTag == "Unique" then
                    tag = cardTag
                    break
                end
            end
            if tag ~= "" then
                powers[card.guid] = tag
                inserted = true
            end
        end
        if inserted then
            data.secondWave.powers = powers
        end
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
            broadcastToAll("Notebook Tab \"Game Config\" has been updated", Color.White)
            break
        end
    end
end
