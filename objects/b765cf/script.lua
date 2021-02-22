difficulty={[0] = 1, 3, 4, 6, 7, 9, 11}
fearCards={[0] = {0,0,0}, {0,1,0}, {1,1,0}, {1,2,1}, {1,2,2}, {1,2,2}, {1,2,1}}
fearTokens={[0]=0,0,0,0,0,0,1}
preSetup = true
preSetupComplete = false
reminderSetup = true
mapSetup = true
postSetup = true
postSetupComplete = false
hasLossCondition = true
hasUI = true

highImmigration = "e5d18b"
highImmigrationDiscardPosition = Vector(-52.90, 1.3, -5.30)
originalDiscardPosition = Vector(-51.25, 1.5, 0.38)

function onSave()
    data_table = {
        build2 = UI.getAttribute("panelBuild2","active"),
    }
    saved_data = JSON.encode(data_table)
    return saved_data
end

function onLoad(saved_data)
    loaded_data = JSON.decode(saved_data)
    if loaded_data.build2 == "true" then
        UI.setAttribute("panelBuild2","active",true)
        UI.setAttribute("panelInvader","width","470")
    end
end

function onObjectPickUp(player_color, picked_up_object)
    if picked_up_object.guid == highImmigration then
        UI.setAttribute("panelBuild2","active",false)
        UI.setAttribute("panelInvader","width","380")
        local aidBoard = Global.getVar("aidBoard")
        moveDiscard(aidBoard)
        removeEnglandSnap(aidBoard)
    end
end
function moveDiscard(aidBoard)
    local currentDiscard = aidBoard.getTable("discard")
    local hits = Physics.cast({
        origin       = currentDiscard,
        direction    = Vector(0,1,0),
        type         = 3,
        size         = Vector(1,0.9,1.5),
        orientation  = Vector(0,90,0),
        max_distance = 0,
        --debug        = true,
    })
    for _,hit in pairs(hits) do
        if hit.hit_object ~= aidBoard then
            if hit.hit_object.type == "Card" or hit.hit_object.type == "Deck" then
                hit.hit_object.setPosition(originalDiscardPosition)
                hit.hit_object.setRotation(Vector(0,90,0))
            end
        end
    end
end
function removeEnglandSnap(aidBoard)
    local snapPoints = Global.getSnapPoints()
    local newSnapPoints = {}
    for i,v in ipairs(snapPoints) do
        if table.concat(v.tags, "|") ~= "Invader Card" then
            table.insert(newSnapPoints,v)
        end
    end
    Global.setSnapPoints(newSnapPoints)

    snapPoints = aidBoard.getSnapPoints()
    table.insert(snapPoints, {
        position = Vector(0.41, 0.05, 1.77),
        rotation = Vector(0, 270, 0),
        rotation_snap = true,
        tags = {"Invader Card"},
    })
    aidBoard.setSnapPoints(snapPoints)
    aidBoard.setTable("discard", originalDiscardPosition)
end

function PreSetup(params)
    if params.level >= 5 then
        local townHealth = Global.getVar("townHealth")
        local current = tonumber(townHealth.TextTool.getValue())
        townHealth.TextTool.setValue(tostring(current+1))
        townHealth.TextTool.setFontColor({1,0.2,0.2})
        local cityHealth = Global.getVar("cityHealth")
        current = tonumber(cityHealth.TextTool.getValue())
        cityHealth.TextTool.setValue(tostring(current+1))
        cityHealth.TextTool.setFontColor({1,0.2,0.2})

        local adversaryBag = Global.getVar("adversaryBag")
        local townBag = Global.getVar("townBag")
        local townBagPosition = townBag.getPosition()
        local newGuid = "942899"
        if townBag.guid == "fabcad" then
            newGuid = "aeb4fa"
        end
        townBag.destruct()
        townBag = adversaryBag.takeObject({
            guid = newGuid,
            position = townBagPosition,
            rotation = {0,270,0},
            smooth = false,
            callback_function = function(obj) obj.setLock(true) end,
        })
        Global.setVar("townBag", townBag)

        local cityBag = Global.getVar("cityBag")
        local cityBagPosition = cityBag.getPosition()
        cityBag.destruct()
        cityBag = adversaryBag.takeObject({
            guid = "cb7231",
            position = cityBagPosition,
            rotation = {0,180,0},
            smooth = false,
            callback_function = function(obj) obj.setLock(true) end,
        })
        Global.setVar("cityBag", cityBag)
        Wait.condition(function() preSetupComplete = true end, function() return not townBag.isSmoothMoving() and not cityBag.isSmoothMoving() end)
    else
        preSetupComplete = true
    end
end

function ReminderSetup(params)
    local reminderTiles = {}
    if params.level >= 1 then
        reminderTiles.build = "eb5ab2"
    end
    return reminderTiles
end

function AdversaryUI(params)
    local ui = {}

    ui.loss = {}
    ui.loss.tooltip = "If 7 or more Towns and/or Cities are\never in a single land, the Invaders win"

    ui.escalation = {}
    ui.escalation.tooltip = "On each board with a Town/City, Build\nin the land with the most Towns/Cities."
    if params.level >= 1 then
        ui.one = {}
        ui.one.name = "Indentured Servants Earn Land"
        ui.one.tooltip = "Invader Build actions affect lands without\nInvaders, if they are adjacent to at least\n2 Town/City before the Build Action."
    end
    if params.level == 3 then
        ui.three = {}
        ui.three.name = "High Immigration (I)"
        ui.three.tooltip = "Invaders take a Build action each Invader phase\nbefore Ravaging. Remove the tile when a Stage II\ncard slides onto it, putting that card in the discard."
    end
    if params.level >= 4 then
        ui.four = {}
        ui.four.name = "High Immigration (full)"
        ui.four.tooltip = "Invaders take a Build action each\nInvader phase before Ravaging."
    end
    if params.level >= 5 then
        ui.five = {}
        ui.five.name = "Local Autonomy"
        ui.five.tooltip = "Town/City have +1 Health."
    end
    if params.level >= 6 then
        ui.six = {}
        ui.six.name = "Independent Resolve"
        ui.six.tooltip = "During any Invader Phase where you\nresolve no Fear Cards, perform the\nBuild from High Immigration twice."
    end
    return ui
end

function MapSetup(params)
    if not params.extra and params.level >= 2 then
        table.insert(params.pieces[1],"City")
        table.insert(params.pieces[2],"Town")
    end
    return params.pieces
end

function PostSetup(params)
    if params.level >= 3 then
        local aidBoard = Global.getVar("aidBoard")
        local adversaryBag = Global.getVar("adversaryBag")
        adversaryBag.takeObject({
            guid = highImmigration,
            position = aidBoard.positionToWorld(Vector(0.41,0.1,1.93)),
            rotation = {0,180,0},
            callback_function = function(obj) obj.setLock(true) end,
        })

        UI.setAttribute("panelBuild2","active",true)
        UI.setAttribute("panelInvader","width","470")
        englandSnap(aidBoard)
        Wait.condition(function() postSetupComplete = true end, function() return not aidBoard.isSmoothMoving() end)
    else
        postSetupComplete = true
    end
end

function englandSnap(aidBoard)
    local snapPoints = aidBoard.getSnapPoints()
    local newSnapPoints = {}
    for i,v in ipairs(snapPoints) do
        if table.concat(v.tags, "|") ~= "Invader Card" then
            table.insert(newSnapPoints,v)
        end
    end
    aidBoard.setSnapPoints(newSnapPoints)
    aidBoard.setTable("discard", highImmigrationDiscardPosition)

    snapPoints = Global.getSnapPoints()
    table.insert(snapPoints, {
        position = highImmigrationDiscardPosition,
        rotation = Vector(0, 180, 0),
        rotation_snap = true,
        tags = {"Invader Card"},
    })
    Global.setSnapPoints(snapPoints)
end