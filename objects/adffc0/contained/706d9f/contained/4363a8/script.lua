local balancedBag = "ab7fce"
local thematicBag = "bb7fce"

local preparedTileHeight = 0
local raiseHeight = 0.2
local castDownDropHeight = 0.05 -- The distance that the main mod drops a board when casting down.
local preparedTag = "Drowned Prepared"
local activeTag = "Drowned Active"
 -- A boolean, does the timer exist, stored in global.
local timerVarName = "castDownDrownedLandTimer"

local toPopulate = 0

local balancedPositions = {
    A1 = {x = -3.23, z = 3.98},
    A2 = {x = -8.19, z = 0.97},
    A3 = {x = -10.44, z = -7.66},
    A4 = {x = -2.63, z = -4.46},
    A5 = {x = 2.25, z = -2.42},
    A6 = {x = 2.30, z = 5.84},
    A7 = {x = 6.66, z = -3.05},
    A8 = {x = 9.89, z = 6.08},
    B1 = {x = -4.79, z = 5.20},
    B2 = {x = -8.13, z = -1.50},
    B3 = {x = -9.75, z = -7.24},
    B4 = {x = -0.79, z = -4.11},
    B5 = {x = 1.81, z = -0.19},
    B6 = {x = 2.49, z = 5.46},
    B7 = {x = 6.07, z = -3.67},
    B8 = {x = 10.34, z = 6.36},
    C1 = {x = -4.53, z = 5.06},
    C2 = {x = -7.18, z = -1.77},
    C3 = {x = -10.04, z = -6.53},
    C4 = {x = 1.80, z = -6.31},
    C5 = {x = 1.33, z = -1.13},
    C6 = {x = 3.29, z = 5.16},
    C7 = {x = 7.43, z = -0.98},
    C8 = {x = 9.96, z = 5.25},
    D1 = {x = 2.71, z = 7.17},
    D2 = {x = -6.25, z = -0.88},
    D3 = {x = -10.28, z = -5.88},
    D4 = {x = -3.21, z = -5.49},
    D5 = {x = 0.37, z = 1.01},
    D6 = {x = 3.81, z = -3.79},
    D7 = {x = 6.22, z = 0.54},
    D8 = {x = 10.36, z = 5.77},
    E1 = {x = -2.66, z = 6.38},
    E2 = {x = -7.08, z = -0.15},
    E3 = {x = -10.15, z = -6.00},
    E4 = {x = -0.32, z = -5.32},
    E5 = {x = -1.72, z = -0.71},
    E6 = {x = 6.25, z = -2.74},
    E7 = {x = 5.51, z = 3.56},
    E8 = {x = 9.99, z = 3.45},
    F1 = {x = -3.35, z = 6.13},
    F2 = {x = -6.58, z = -1.59},
    F3 = {x = -9.20, z = -5.25},
    F4 = {x = -0.53, z = -5.15},
    F5 = {x = 1.65, z = 2.34},
    F6 = {x = 4.90, z = 5.66},
    F7 = {x = 6.16, z = -3.74},
    F8 = {x = 7.19, z = 1.27},
    G1 = {x = -2.98, z = 5.50},
    G2 = {x = -5.80, z = -1.40},
    G3 = {x = -8.70, z = -6.87},
    G4 = {x = -1.70, z = -4.97},
    G5 = {x = 1.18, z = -0.43},
    G6 = {x = 3.59, z = 5.61},
    G7 = {x = 5.63, z = -3.58},
    G8 = {x = 9.13, z = 4.32},
    H1 = {x = -2.64, z = 6.01},
    H2 = {x = -6.60, z = 0.10},
    H3 = {x = -10.38, z = -6.63},
    H4 = {x = 1.11, z = -6.46},
    H5 = {x = -0.02, z = -2.73},
    H6 = {x = 1.87, z = 2.69},
    H7 = {x = 7.68, z = 1.08},
    H8 = {x = 8.45, z = 6.87},
}

local thematicPositions = {
}

function err(color, message)
    Player[color].broadcast(message, Color.Red)
end

function castDownCallback()
    -- If we're not currently casting down, return immediately to avoid overhead.
    if not Global.getVar("castDown") then
        return
    end
    
    local board = getObjectFromGUID(Global.getVar("castDown"))
    local drowningTiles = getBoardTiles(board)
    for _,guid in pairs(drowningTiles) do
        local obj = getObjectFromGUID(guid)
        if obj ~= nil then
            obj.destruct()
        end
    end
end

-- Starts the Cast Down timer.
function startCastDownTimer()
    -- We store the reference to the Cast Down timer in Global, so every Deeps token has access to it.
    -- Every Deeps token will try to do this, so if it already exists, don't worry about it.
    if Global.getVar(timerVarName) then
        return
    end
    -- Cast Down lasts 0.5 seconds.
    -- We need to drop the tiles early, to give things time to fall, so do this every 0.2 seconds.
    Wait.time(castDownCallback, 0.2, -1)
    Global.setVar(timerVarName, true)
end

-- Casts down from the provided location, returning the board found.
function getBoard(position)
    local hits = Physics.cast({
        origin = position,
        direction = Vector(0,-1,0),
        max_distance = 1,
    })
    for _,hit in pairs(hits) do
        if Global.call("isIslandBoard", {obj=hit.hit_object}) then
            return hit.hit_object
        end
    end
    return nil
end

-- Marks a board as having been populated with drowned land tiles.
-- Does so in a way that persists through saves and reloads.
function markBoard(board, drowningTiles)
    local json
    if board.script_state ~= "" then
        json = JSON.decode(board.script_state)
    else
        json = {}
    end
    json.drowningTiles = drowningTiles
    board.script_state = JSON.encode(json)
end

-- Returns whether a board has been marked by markBoard.
function checkBoard(board)
    if board.script_state == "" then
        return false
    end
    local json = JSON.decode(board.script_state)
    return json.drowningTiles ~= nil
end

-- Gets the table of drowning tiles from a board
function getBoardTiles(board)
    if board.script_state == "" then
        return {}
    end
    local json = JSON.decode(board.script_state)
    return json.drowningTiles
end

-- Places a single drowned land tile, from a bag, into the correct place.
-- Creates a copy from the bag, 'cause we may need multiple copies for extra bags.
-- Gives the object a tag to indicate it's submerged in a board.
function populateTile(bag, guid, position, rotation)
    -- TODO: Scale this properly according to scaleFactors[SetupChecker.getVar("optionalScaleBoard")].size
    -- Get the object out of the bag to clone it, but use a callback to put it back as soon as it spawns.
    local original = bag.takeObject({
        guid = guid,
        position = bag.getPosition() + Vector(0, 10, 0),
        callback_function = function(obj) bag.putObject(obj) end,
    })
    -- Spawn the clones somewhere out of the way, so we can lock them before moving them into position.
    local clone = original.clone({position = original.getPosition() + Vector(0, 10, 0)})
    clone.setLock(true)
    clone.setPosition(position)
    clone.setRotation(rotation)
    clone.addTag(preparedTag)
    clone.interactable = false
    clone.addTag("Uninteractable")
    Wait.condition(
        function() toPopulate = toPopulate - 1 end,
        function() return not clone.spawning and not clone.loading_custom end
    )
    return clone.getGUID()
end

-- Calculates the correct position for a tile, given a board.
function calculatePosition(board, tilePosition)
    local boardScale = board.getScale()
    local localPosition = Vector(-tilePosition.x / boardScale.x, preparedTileHeight / boardScale.y, -tilePosition.z / boardScale.z)
    return board.positionToWorld(localPosition)
end

-- Takes a board and fills it with drowning tiles, locked and hidden inside it.
function populateBoard(board)
    if checkBoard(board) then
        return
    end
    
    -- Determine the appropriate bag.
    local bag
    local positions
    if board.hasTag("Balanced") then
        bag = getObjectFromGUID(balancedBag)
        positions = balancedPositions
    else
        bag = getObjectFromGUID(thematicBag)
        positions = thematicPositions
    end
    
    -- Go through the bag, storing the GUIDs of the objects we want.
    -- We store GUIDs as populateTile modifies the bag contents, which may interfere with bag operations.
    local guids = {}
    for _,obj in pairs(bag.getObjects()) do
        if string.find(obj.name, "^"..board.getName().."[0-9]*$") then
            guids[obj.name] = obj.guid
            toPopulate = toPopulate + 1
        end
    end
    
    local drowningTiles = {}
    -- Copy all the appropriate objects into place.
    for name,guid in pairs(guids) do
        local spawnedGUID = populateTile(bag, guid, calculatePosition(board, positions[name]), board.getRotation())
        drowningTiles[name] = spawnedGUID
    end
    
    markBoard(board, drowningTiles)
    startCastDownTimer()
end

-- Adds right-click functionality to a tile to undrown itself.
function addUndrown(tile)
    -- We also need to ensure it will restore this functionality to itself if reloaded.
    tile.setLuaScript(string.format([[
        function onLoad()
            self.addContextMenuItem("Undrown Land",
                function()
                    self.setPosition(self.getPosition() - Vector(0, %f, 0))
                    self.removeTag("%s")
                    self.addTag("%s")
                    self.interactable = false
                    self.addTag("Uninteractable")
                end
            )
        end
    ]], raiseHeight, activeTag, preparedTag))
end

-- Lifts a tile up out of the board to be visible.
-- Acts only on objects with preparedTag.
function liftTile(color, token_position)
    local hits = Physics.cast({
        origin = token_position,
        direction = Vector(0,-1,0),
        max_distance = 1,
    })
    for _,hit in pairs(hits) do
        local obj = hit.hit_object
        if obj.hasTag(preparedTag) then
            obj.setPosition(obj.getPosition() + Vector(0, raiseHeight, 0))
            obj.removeTag(preparedTag)
            obj.addTag(activeTag)
            obj.interactable = true
            obj.removeTag("Uninteractable")
            addUndrown(obj)
            return
        end
    end
    
    err(color, "Can't find drowned land tile\nIs the token on a land boundary? Has this tile already been drowned?")
end

function activate(color, token_position, _)
    -- First, find which board we're over.
    local board = getBoard(token_position)
    if not board then
        err(color, "Token is not on a board")
        return
    end
    
    populateBoard(board)
    
    -- Wait for the drowned land tiles to appear before raising one.
    Wait.condition(
        function() liftTile(color, token_position) end,
        function() return toPopulate == 0 end
    )
end

function onLoad()
    self.addContextMenuItem("Drown Land", activate)
    
    if getObjectsWithAnyTags({preparedTag, activeTag}) then
        startCastDownTimer()
    end
end
