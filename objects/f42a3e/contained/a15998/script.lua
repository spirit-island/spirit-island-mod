local currentBoard
local boardTypes = {"Balanced", "Thematic"}

function onLoad()
    self.createButton({
        click_function = "nullFunc",
        label = "Place Island Board Here",
        font_color = {1,1,1},
        position = {0,0.1,0},
        font_size = 300,
        width = 0,
        height = 0,
    })
    Color.Add("SoftBlue", Color.new(0.53,0.92,1))
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
    Wait.time(scan, 0.5, -1)
end

function scan()
    local objs = upCast(self, 1, 0, {"Tile"})
    if #objs ~= 1 then
	currentBoard = nil
        clearButtons()
        return
    end
    currentBoard = objs[1]
    local type
    for _,tag in pairs(boardTypes) do
        if currentBoard.hasTag(tag) then
            type = tag
            break
        end
    end
    createButtons(currentBoard, type)
end

function clearButtons()
    local buttons = self.getButtons()
    for i=2,#buttons do
        self.removeButton(buttons[i].index)
    end
end

function createButtons(board, type)
    clearButtons()
    local tooltip = "[b]Balanced[/b] boards will additionally setup a Beasts in the lowest-numbered land without other setup and a Disease in land #2.\n[b]Thematic[/b] boards will not."
    self.createButton({
        click_function = "nullFunc",
        label          = "Type",
        position       = {3,0.1,16},
        width          = 830,
        height         = 330,
        font_size      = 300,
	tooltip	       = tooltip,
    })

    self.createButton({
        click_function = "button2",
        function_owner = self,
        label          = "<",
        position       = {4.25,0.1,16},
        width          = 330,
        height         = 330,
        font_size      = 300,
	tooltip	       = tooltip,
    })
    local func = function() editType(board,-1) end
    self.setVar("button2",func)

    local label = type
    if type == nil then
	label = ""
    end
    self.createButton({
        click_function = "nullFunc",
        label          = label,
        position       = {5.95,0.1,16},
        width          = 1245,
        height         = 330,
        font_size      = 300,
	tooltip	       = tooltip,
    })

    self.createButton({
        click_function = "button3",
        function_owner = self,
        label          = ">",
        position       = {7.65,0.1,16},
        width          = 330,
        height         = 330,
        font_size      = 300,
	tooltip	       = tooltip,
    })
    func = function() editType(board,1) end
    self.setVar("button3",func)
end

function editType(obj, num)
    local index = 0
    for i,tag in pairs(boardTypes) do
        if obj.hasTag(tag) then
            index = i
            break
        end
    end
    -- Increase the index by num, keeping it in the range [1, #boardTypes]
    index = (index + num - 1) % #boardTypes + 1
    if index < 1 then
        index = index + #boardTypes
    end
    for i,tag in pairs(boardTypes) do
        if i == index then
            obj.addTag(tag)
        else
            obj.removeTag(tag)
        end
    end
    scan()
end

function updateSetupPos(player)
    GenerateSpawnPositions()
    if currentBoard == nil then
	player.broadcast("There is no board to update", Color.SoftYellow)
    else
        player.broadcast("Updated setup positions for Board " .. currentBoard.getName(), Color.SoftBlue)
    end
end

function populateSetupPos(player)
    PopulateSpawnPositions(player)
end

function upCast(object,dist,offset,types)
    dist = dist or 1
    offset = offset or 0
    types = types or {}
    local hits = Physics.cast({
        origin       = object.getPosition() + Vector(0,offset,0),
        direction    = Vector(0,1,0),
        type         = 3,
        size         = object.getBounds().size,
        orientation  = object.getRotation(),
        max_distance = dist,
        --debug        = true,
    })
    local hitObjects = {}
    for _,hit in pairs(hits) do
        if types ~= {} then
            local matchesType = false
            for _,t in pairs(types) do
                if hit.hit_object.type == t then matchesType = true end
            end
            if matchesType then
                table.insert(hitObjects,hit.hit_object)
            end
        else
            table.insert(hitObjects,hit.hit_object)
        end
    end
    return hitObjects
end

function GenerateSpawnPositions()
    local output = GetSpawnPositions()
    local boardLines = {}
    local setupPiecesNamed = {}
    local setupCoordsNamed = {}
    local setupPiecesUnnamed = {}
    local setupCoordsUnnamed = {}

    local function combine2DTables(t1, t2) --concatenate rows from two 2D tables
        local result = {}
        for i = 1, #t1 do
            local combinedRow = {}
            for _, v in ipairs(t1[i]) do
                table.insert(combinedRow, v)
            end
            for _, v in ipairs(t2[i]) do
                table.insert(combinedRow, v)
            end
            table.insert(result, combinedRow)
        end
        return result
    end

    local function concat2DTable(t, tName) --concatenate a 2D table
        local result = {tName.." = {"}
        for _, row in ipairs(t) do
            local rowString = " {\n" .. table.concat(row, ",\n").."\n},"
            table.insert(result, rowString)
        end
        table.insert(result, " }\n")
        return table.concat(result)
    end

    for boardGUID,objsData in pairs(output) do
        local board = getObjectFromGUID(boardGUID)
        for _,objData in pairs(objsData) do
            local name = objData.name
            local pos = objData.position
            local state = objData.state
            if not setupCoordsUnnamed[state] then
                setupCoordsUnnamed[state] = {}
                setupPiecesUnnamed[state] = {}
                setupCoordsNamed[state] = {}
                setupPiecesNamed[state] = {}
            end
            if name == "Empty Space" then
                table.insert(setupCoordsUnnamed[state], "{x="..pos.x..", y="..pos.y..", z="..pos.z.."}")
            else
                table.insert(setupCoordsNamed[state], "{x="..pos.x..", y="..pos.y..", z="..pos.z.."}")
                table.insert(setupPiecesNamed[state], "\""..name.."\"")
            end
        end
        table.insert(boardLines, concat2DTable(combine2DTables(setupCoordsNamed, setupCoordsUnnamed), "posMap"))
        table.insert(boardLines, concat2DTable(combine2DTables(setupPiecesNamed, setupPiecesUnnamed), "pieceMap"))
        local boardScript = table.concat(boardLines, "\n").."\n"
        --HACK: I have no clue why but it doesn't work when the script is applied only once :shrug:
        board.setLuaScript(boardScript)
        board.setLuaScript(boardScript)
        board.reload()
        setupCoordsUnnamed, setupPiecesUnnamed, setupCoordsNamed, setupPiecesNamed = {}, {}, {}, {}
    end
end

function GetSpawnPositions()
    local strifeablePieces = {
      ["Explorer"] = true,
      ["Town"] = true,
      ["City"] = true
    }
    local boards = getMapTiles()

    local moving = false
    while moving do
        for _, obj in pairs(boards) do
            if obj.isSmoothMoving() then
                moving = true
            end
        end
        if not moving then break end
        coroutine.yield()
    end

    local output = {}
    for _,board in pairs(boards) do
        local boardTable = {}
        local hits = Physics.cast({
            origin = board.getPosition() + Vector(0, 0.45, 0),
            direction = Vector(0, 1, 0),
            type = 3,
            size = board.getBounds().size,
        })
        for _,hit in pairs(hits) do
            if not Global.call("isIslandBoard", {obj=hit.hit_object}) then
                local subHits = Physics.cast({
                    origin = hit.hit_object.getPosition() + Vector(0, 0.1, 0),
                    direction = Vector(0, -1, 0),
                    max_distance = 0.6,
                })
                local onBoard = false
                for _,subHit in pairs(subHits) do
                    if subHit.hit_object == board then
                        onBoard = true
                        break
                    end
                end
                if onBoard then
		    local state = hit.hit_object.getStateId() --State tracks what land the piece is in
                    if state == -1 then
                        state = 1
                    end
                    local name = hit.hit_object.getName()
                    if strifeablePieces[name] then
                        local strifeHits = Physics.cast({
                            origin          = hit.hit_object.getPosition(),
                            direction       = Vector(0, 1, 0),
                            max_distance    = 5,
                            --debug           = true
                        })
                        for _,strifeHit in pairs(strifeHits) do
                            if strifeHit.hit_object.getName() == "Strife" then
                                name = name.."S"
                                state = strifeHit.hit_object.getStateId()
                                destroyObject(strifeHit.hit_object)
                              break
                          end
                       end
                    end
                    local pos = board.positionToLocal(hit.hit_object.getPosition())
                    pos.y = 0.7
                    table.insert(boardTable, {state = state, name = name, position = pos})
		    destroyObject(hit.hit_object)
                end
            end
        end
        output[board.getGUID()] = boardTable
    end
    return output
end

function getMapTiles()
    local mapTiles = {}
    for _,obj in pairs(upCast(self, 1, 0, {"Tile"})) do
        if Global.call("isIslandBoard", {obj=obj}) then
            table.insert(mapTiles,obj)
        end
    end
    return mapTiles
end

function PopulateSpawnPositions(player)
    local boards = getMapTiles()
    local moving = false
    while not moving do
        for _, obj in pairs(boards) do
            if obj.isSmoothMoving() then
                moving = true
                break
            end
        end
        if not moving then
            break
        end
        coroutine.yield()
    end

    for _,board in pairs(boards) do
        if board.getTable("pieceMap") == nil or board.getTable("posMap") == nil then
            player.broadcast("Board "..currentBoard.." does not have any setup positions to populate", Color.SoftYellow)
            return
        end
        local piecesToPlace = board.getTable("pieceMap")
        local posToPlace = board.getTable("posMap")

        for l,landTable in ipairs(posToPlace) do
            for i,pieceName in ipairs(piecesToPlace[l]) do
                place({
                    name     = pieceName,
                    position = board.positionToWorld(posToPlace[l][i]),
                    state    = l,
                })
            end

            local startIndex = #piecesToPlace[l]+1
            for i=startIndex,#landTable do
                place({
                    name = "Empty",
                    position = board.positionToWorld(posToPlace[l][i]),
                    state = l,
                })
            end
        end
    end
end

function place(params)
    local pieceBags = {
        ["Empty"]      = "cd370a",
        ["Explorer"]   = "85225b",
        ["Town"]       = "78540e",
        ["City"]       = "f4eb76",
        ["Dahan"]      = "b14600",
        ["Blight"]     = "f60888",
        ["Box Blight"] = "f60888",
        ["Beasts"]     = "cb11a0",
        ["Badlands"]   = "150475",
        ["Wilds"]      = "bc12de",
        ["Disease"]    = "af56a7",
        ["Strife"]     = "7fb430",
        ["Vitality"]   = "ae9812",
    }
    local piecesWithStrife = {
        ["ExplorerS"] = true,
        ["TownS"]     = true,
        ["CityS"]     = true
    }
    local pieceName = params.name
    local pieceBag = getObjectFromGUID(pieceBags[pieceName])
    local pieceWithStrife = piecesWithStrife[pieceName]

    --If there is no bag for such a piece, place nothing
    if not (pieceBag or pieceWithStrife) then
        return
    end
    --If it requires Strife, queue up its placement
    if pieceWithStrife then
        Wait.time(function() place({
            name 	 = "Strife",
            position = params.position + Vector(0,1.5,0),
            state    = params.state,
            }) end, 0.5)
        --Remove 'S' from the end of the pieceName
        pieceName = string.sub(pieceName, 1, -2)
        pieceBag = getObjectFromGUID(pieceBags[pieceName])
    end
    --Place the piece
    return pieceBag.takeObject({
        position             = params.position,
        rotation             = Vector(0,180,0),
        smooth               = not params.fast,
        callback_function    = function(obj) if params.state ~= 1 then obj.setState(params.state) end end,
    })
end
