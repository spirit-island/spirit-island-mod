preSetup = true
preSetupComplete = false
mapSetup = true
postSetup = true
postSetupComplete = false
hasBroadcast = true

broadcast = nil
blightCount = nil
blightedIsland = false

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

function PreSetup()
    local config = readConfig()
    if config and config.secondWave then
        if config.secondWave.blight then
            blightCount = config.secondWave.blight
        end
        blightedIsland = config.blightedIsland

        if config.secondWave.boards then
            local mapBag
            if config.boardLayout == "Custom" then
                mapBag = Global.getVar("StandardMapBag")
            else
                mapBag = Global.getVar("ThematicMapBag")
            end
            local started = 0
            local finished = 0
            for boardName,position in pairs(config.secondWave.boards) do
                for _,obj in pairs(mapBag.getObjects()) do
                    if obj.name == boardName then
                        started = started + 1
                        local board = mapBag.takeObject({
                            guid = obj.guid,
                            position = position,
                            smooth = false,
                        })
                        Wait.condition(function() finished = finished + 1 end, function() return not board.loading_custom end)
                        break
                    end
                end
            end
            Wait.condition(function() preSetupComplete = true end, function() return started == finished end)
        else
            preSetupComplete = true
        end
    else
        preSetupComplete = true
    end
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
                    or params.pieces[i][j] == "Vitality"
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
function PostSetup()
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
        position = {-38.14, 0.71, 35.97},
        rotation = {0,180,0},
        smooth = false,
        callback_function = function(obj) obj.setLock(true) end,
    })

    local config = readConfig()
    if config and config.secondWave then
        if config.secondWave.wave then
            broadcast = "Second Wave - Starting Wave "..config.secondWave.wave
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
                    local objs = getObjectsWithTag("Spirit")
                    for _,obj in pairs(objs) do
                        if obj.type == "Bag" then
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
                        end
                        if found then
                            break
                        end
                    end

                    if not found then
                        objs = getObjectsWithTag("Unique")
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
                end

                if not found then
                    broadcastToAll("Unable to find "..tag.." Power Card with guid "..guid, Color.Red)
                end
            end
        end
        if config.secondWave.pieces then
            local boards = Global.call("getMapTiles")
            for _,board in pairs(boards) do
                if config.secondWave.pieces[board.getName()] then
                    for _,objData in pairs(config.secondWave.pieces[board.getName()]) do
                        for _ = 1,objData.quantity do
                            Global.call("place", {name = objData.name, position = board.positionToWorld(objData.position) + Vector(0, 2, 0)})
                        end
                    end
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

function Broadcast(params)
    return broadcast
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
    if data.boardLayout == "Custom" or data.boardLayout == "Custom Thematic" then
        local boardPos = {}
        for _,board in pairs(Global.call("getMapTiles")) do
            boardPos[board.getName()] = board.getPosition()
        end
        data.secondWave.boards = boardPos
    end

    local SetupChecker = Global.getVar("SetupChecker")
    data.variant = {}
    data.variant.natureIncarnateSetup = SetupChecker.getVar("optionalNatureIncarnateSetup")
    data.variant.blightCard = SetupChecker.getVar("optionalBlightCard")
    data.variant.soloBlight = SetupChecker.getVar("optionalSoloBlight")
    data.variant.blightSetup = SetupChecker.getVar("optionalBlightSetup")
    data.variant.extraBoard = SetupChecker.getVar("optionalExtraBoard")
    local extraBoardRandom = Global.getVar("extraRandomBoard")
    if extraBoardRandom ~= nil then
        data.variant.extraBoardRandom = extraBoardRandom
    end
    data.variant.boardPairings = SetupChecker.getVar("optionalBoardPairings")
    data.variant.thematicRebellion = SetupChecker.getVar("optionalThematicRebellion")
    data.variant.uniqueRebellion = SetupChecker.getVar("optionalUniqueRebellion")
    data.variant.thematicRedo = SetupChecker.getVar("optionalThematicRedo")
    data.variant.thematicPermute = SetupChecker.getVar("optionalThematicPermute")
    data.variant.carpetRedo = Global.getVar("seaTile").getStateId() == 1
    data.variant.gameResults = SetupChecker.getVar("optionalGameResults")

    data.exploratory = {}
    data.exploratory.votd = SetupChecker.getVar("exploratoryVOTD")
    data.exploratory.bodan = SetupChecker.getVar("exploratoryBODAN")
    data.exploratory.war = SetupChecker.getVar("exploratoryWar")
    data.exploratory.aid = SetupChecker.getVar("exploratoryAid")
    data.exploratory.sweden = SetupChecker.getVar("exploratorySweden")
    data.exploratory.trickster = SetupChecker.getVar("exploratoryTrickster")
    data.exploratory.shadows = SetupChecker.getVar("exploratoryShadows")
    data.exploratory.fractured = SetupChecker.getVar("exploratoryFractured")

    data.playtest = {}
    data.playtest.expansion = SetupChecker.getVar("playtestExpansion")
    data.playtest.fear = SetupChecker.getVar("playtestFear")
    data.playtest.event = SetupChecker.getVar("playtestEvent")
    data.playtest.blight = SetupChecker.getVar("playtestBlight")
    data.playtest.minorPower = SetupChecker.getVar("playtestMinorPower")
    data.playtest.majorPower = SetupChecker.getVar("playtestMajorPower")

    local selectedBoards = Global.getTable("selectedBoards")
    if selectedBoards and #selectedBoards > 0 then
        data.boards = selectedBoards
    end
    data.blightCards = Global.getTable("blightCards")

    data.secondWave.blight = {}
    local blight = #Global.getVar("blightBag").getObjects()

    local numBoards = Global.getVar("numBoards")
    local startingBlight = 2 * numBoards
    if Global.getVar("SetupChecker").getVar("optionalBlightSetup") then
        startingBlight = startingBlight + 1
    end

    local blightIndex = Global.call("getBlightCardIndex")
    if blightIndex ~= -1 then
        local blightCard = Global.getVar("blightedIslandCard")
        if blightCard ~= nil and blightCard.is_face_down then
            blightIndex = -1
        end
    end

    if blightIndex == -1 then
        table.insert(data.secondWave.blight, blight)
        blight = 0
        blightIndex = 0
    else
        local setupBlight = math.min(startingBlight, blight)
        table.insert(data.secondWave.blight, setupBlight)
        blight = blight - setupBlight
    end
    for i=1,blightIndex do
        if i ~= blightIndex then
            local setupBlight = math.min(2 * numBoards, blight)
            table.insert(data.secondWave.blight, setupBlight)
            blight = blight - setupBlight
        else
            table.insert(data.secondWave.blight, blight)
            blight = 0
        end
    end
    for i=blightIndex+1,#data.blightCards do
        if config.secondWave.blight then
            table.insert(data.secondWave.blight, config.secondWave.blight[i+1])
        else
            table.insert(data.secondWave.blight, 0)
        end
    end
    for i=1,#data.secondWave.blight do
        if i == 1 then
            -- initial
            if data.secondWave.blight[i] < startingBlight then
                local diff = startingBlight - data.secondWave.blight[i]
                for j=#data.secondWave.blight,i+1,-1 do
                    local add = math.min(data.secondWave.blight[j], diff)
                    data.secondWave.blight[i] = data.secondWave.blight[i] + add
                    data.secondWave.blight[j] = data.secondWave.blight[j] - add
                    diff = diff - add

                    if diff == 0 then
                        break
                    end
                end
            end
        elseif i ~= #data.secondWave.blight then
            -- still-healthy
            if data.secondWave.blight[i] < 2 * numBoards then
                local diff = startingBlight - data.secondWave.blight[i]
                for j=#data.secondWave.blight,i+1,-1 do
                    local add = math.min(data.secondWave.blight[j], diff)
                    data.secondWave.blight[i] = data.secondWave.blight[i] + add
                    data.secondWave.blight[j] = data.secondWave.blight[j] - add
                    diff = diff - add

                    if diff == 0 then
                        break
                    end
                end
            end
        end
    end
    local blightedIsland = Global.getVar("blightedIsland")
    data.secondWave.blightedIsland = blightedIsland
    if config and config.secondWave then
        data.secondWave.blightedIsland = data.secondWave.blightedIsland or config.secondWave.blightedIsland
    end

    local obj = Global.getVar("adversaryCard")
    if obj ~= nil then
        data.adversary = obj.getName()
        data.adversaryLevel = Global.getVar("adversaryLevel")
        -- If the island is not blighted increase adversary level by 1
        if not blightedIsland and data.adversaryLevel < #obj.getTable("difficulty") then
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
        if not blightedIsland and data.adversaryLevel2 < #obj.getTable("difficulty") then
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
    local piecesData = Global.call("GetSpawnPositions", {})
    local piecesDataFiltered = {}
    for boardName,objsData in pairs(piecesData) do
        local boardTable = {}
        for _,objData in pairs(objsData) do
            if objData.name == "Dahan" then
                table.insert(boardTable, objData)
            elseif objData.name == "Blight" then
                objData.name = "Box Blight"
                table.insert(boardTable, objData)
            elseif objData.name == "Beasts" then
                table.insert(boardTable, objData)
            elseif objData.name == "Wilds" then
                table.insert(boardTable, objData)
            elseif objData.name == "Disease" then
                table.insert(boardTable, objData)
            elseif objData.name == "Strife" then
                table.insert(boardTable, objData)
            elseif objData.name == "Badlands" then
                table.insert(boardTable, objData)
            elseif objData.name == "Vitality" then
                table.insert(boardTable, objData)
            end
        end
        piecesDataFiltered[boardName] = boardTable
    end
    data.secondWave.pieces = piecesDataFiltered
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
