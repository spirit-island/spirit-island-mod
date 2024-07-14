expansions = {}
adversaries = {}
numAdversaries = 0
allAdversaries = {}
scenarios = {}
numScenarios = 0
allScenarios = {}

pickedSpirits = {}
spiritGuids = {}
spiritTags = {}
spiritComplexities = {}
spiritChoices = {}
spiritChoicesLength = 0
allSpirits = {} -- intentionally not backed up on script state

weeklyChallenge = false

randomMin = 0
randomMax = 11
randomMaximizeLevel = false
randomAdversary = false
randomAdversary2 = false
randomScenario = false
randomBoard = false
randomBoardThematic = false

optionalNatureIncarnateSetup = true
optionalBlightCard = true
optionalSoloBlight = true
optionalBlightSetup = true
optionalExtraBoard = false
optionalBoardPairings = true
optionalThematicRebellion = false
optionalUniqueRebellion = false
optionalThematicRedo = false
optionalThematicPermute = false
optionalGameResults = true
optionalScaleBoard = true -- not currently hooked up into UI
optionalDrowningCap = false -- not currently hooked up into UI

exploratoryVOTD = false
exploratoryBODAN = false
exploratoryWar = false
exploratoryAid = false
exploratorySweden = false
exploratoryTrickster = false
exploratoryShadows = false
exploratoryFractured = false

playtestExpansion = "None"
playtestFear = "0"
playtestEvent = "0"
playtestBlight = "0"
playtestMinorPower = "0"
playtestMajorPower = "0"

updateLayoutsID = 0
setupStarted = false
exit = false
sourceSpirit = nil
challengeTier = 1
challengeConfig = {}
expansionsAdded = 0
expansionsSetup = 0

banList = {
    ["Major Powers"] = {},
    ["Minor Powers"] = {},
    ["Event Cards"] = {},
    ["Blight Cards"] = {},
    ["Fear Cards"] = {}
}

function onSave()
    local data_table = {}

    data_table.toggle = {}
    data_table.toggle.variant = self.UI.getAttribute("variant", "isOn") == "true"
    data_table.toggle.exploratory = self.UI.getAttribute("exploratory", "isOn") == "true"
    data_table.toggle.playtest = self.UI.getAttribute("playtesting", "isOn") == "true"
    data_table.toggle.challenge = weeklyChallenge
    data_table.toggle.advanced = self.UI.getAttribute("simpleMode", "isOn") == "true"

    data_table.variant = {}
    data_table.variant.natureIncarnateSetup = optionalNatureIncarnateSetup
    data_table.variant.blightCard = optionalBlightCard
    data_table.variant.soloBlight = optionalSoloBlight
    data_table.variant.blightSetup = optionalBlightSetup
    data_table.variant.extraBoard = optionalExtraBoard
    data_table.variant.boardPairings = optionalBoardPairings
    data_table.variant.thematicRebellion = optionalThematicRebellion
    data_table.variant.uniqueRebellion = optionalUniqueRebellion
    data_table.variant.thematicRedo = optionalThematicRedo
    data_table.variant.thematicPermute = optionalThematicPermute
    data_table.variant.gameResults = optionalGameResults
    data_table.variant.drowningCap = optionalDrowningCap

    data_table.exploratory = {}
    data_table.exploratory.votd = exploratoryVOTD
    data_table.exploratory.bodan = exploratoryBODAN
    data_table.exploratory.war = exploratoryWar
    data_table.exploratory.aid = exploratoryAid
    data_table.exploratory.sweden = exploratorySweden
    data_table.exploratory.trickster = exploratoryTrickster
    data_table.exploratory.shadows = exploratoryShadows
    data_table.exploratory.fractured = exploratoryFractured

    data_table.playtest = {}
    data_table.playtest.expansion = playtestExpansion
    data_table.playtest.fear = playtestFear
    data_table.playtest.event = playtestEvent
    data_table.playtest.blight = playtestBlight
    data_table.playtest.minorPower = playtestMinorPower
    data_table.playtest.majorPower = playtestMajorPower

    data_table.random = {}
    data_table.random.min = randomMin
    data_table.random.max = randomMax
    data_table.random.maximizeLevel = randomMaximizeLevel
    data_table.random.adversary = randomAdversary
    data_table.random.adversary2 = randomAdversary2
    data_table.random.scenario = randomScenario
    data_table.random.board = randomBoard
    data_table.random.thematic = randomBoardThematic

    local adversaryList = {}
    for name,guid in pairs(adversaries) do
        table.insert(adversaryList, {name=name, guid=guid})
    end
    data_table.adversaryList = adversaryList

    local allAdversaryList = {}
    for name,guid in pairs(allAdversaries) do
        table.insert(allAdversaryList, {name=name, guid=guid})
    end
    data_table.allAdversaryList = allAdversaryList

    local scenarioList = {}
    for name,guid in pairs(scenarios) do
        table.insert(scenarioList, {name=name, guid=guid})
    end
    data_table.scenarioList = scenarioList

    local allScenarioList = {}
    for name,guid in pairs(allScenarios) do
        table.insert(allScenarioList, {name=name, guid=guid})
    end
    data_table.allScenarioList = allScenarioList

    data_table.pickedSpirits = pickedSpirits

    return JSON.encode(data_table)
end
function onLoad(saved_data)
    Color.Add("SoftBlue", Color.new(0.53,0.92,1))
    Color.Add("SoftYellow", Color.new(1,0.8,0.5))
    if not Global.getVar("gameStarted") then
        showUI()
    else
        setupStarted = true
    end
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)

        -- This will get flipped by toggleChallenge()
        weeklyChallenge = not loaded_data.toggle.challenge

        optionalNatureIncarnateSetup = loaded_data.variant.natureIncarnateSetup
        optionalBlightCard = loaded_data.variant.blightCard
        optionalSoloBlight = loaded_data.variant.soloBlight
        optionalBlightSetup = loaded_data.variant.blightSetup
        optionalExtraBoard = loaded_data.variant.extraBoard
        optionalBoardPairings = loaded_data.variant.boardPairings
        optionalThematicRebellion = loaded_data.variant.thematicRebellion
        optionalUniqueRebellion = loaded_data.variant.uniqueRebellion
        optionalThematicRedo = loaded_data.variant.thematicRedo
        optionalThematicPermute = loaded_data.variant.thematicPermute
        optionalGameResults = loaded_data.variant.gameResults
        optionalDrowningCap = loaded_data.variant.drowningCap

        exploratoryVOTD = loaded_data.exploratory.votd
        exploratoryBODAN = loaded_data.exploratory.bodan
        exploratoryWar = loaded_data.exploratory.war
        exploratoryAid = loaded_data.exploratory.aid
        exploratorySweden = loaded_data.exploratory.sweden
        exploratoryTrickster = loaded_data.exploratory.trickster
        exploratoryShadows = loaded_data.exploratory.shadows
        exploratoryFractured = loaded_data.exploratory.fractured

        playtestExpansion = loaded_data.playtest.expansion
        playtestFear = loaded_data.playtest.fear
        playtestEvent = loaded_data.playtest.event
        playtestBlight = loaded_data.playtest.blight
        playtestMinorPower = loaded_data.playtest.minorPower
        playtestMajorPower = loaded_data.playtest.majorPower

        randomMin = loaded_data.random.min
        randomMax = loaded_data.random.max
        randomMaximizeLevel = loaded_data.random.maximizeLevel
        randomAdversary = loaded_data.random.adversary
        randomAdversary2 = loaded_data.random.adversary2
        randomScenario = loaded_data.random.scenario
        randomBoard = loaded_data.random.board
        randomBoardThematic = loaded_data.random.thematic

        adversaries = {}
        local count = 0
        for _,params in pairs(loaded_data.adversaryList) do
            adversaries[params.name] = params.guid
            if params.guid ~= "" then
                count = count + 1
            end
        end
        numAdversaries = count

        allAdversaries = {}
        for _,params in pairs(loaded_data.allAdversaryList) do
            allAdversaries[params.name] = params.guid
        end

        scenarios = {}
        count = 0
        for _,params in pairs(loaded_data.scenarioList) do
            scenarios[params.name] = params.guid
            if params.guid ~= "" then
                count = count + 1
            end
        end
        numScenarios = count

        allScenarios = {}
        for _,params in pairs(loaded_data.allScenarioList) do
            allScenarios[params.name] = params.guid
        end

        pickedSpirits = loaded_data.pickedSpirits

        setSlaveRebellion(optionalThematicRebellion, not setupStarted)
        setSweden(exploratorySweden, not setupStarted, true)
        if not setupStarted then
            self.UI.setAttribute("variant", "isOn", tostring(loaded_data.toggle.variant))
            self.UI.setAttribute("exploratory", "isOn", tostring(loaded_data.toggle.exploratory))
            self.UI.setAttribute("playtesting", "isOn", tostring(loaded_data.toggle.playtest))
            self.UI.setAttribute("challenge", "isOn", tostring(loaded_data.toggle.challenge))
            -- set this to opposite boolean so that toggleSimpleMode() will handle all the UI panels easily
            self.UI.setAttribute("simpleMode", "isOn", tostring(not loaded_data.toggle.advanced))

            self.UI.setAttribute("natureIncarnateSetup", "isOn", optionalNatureIncarnateSetup)
            self.UI.setAttribute("blightCard", "isOn", optionalBlightCard)
            self.UI.setAttribute("blightCard2", "isOn", optionalBlightCard)
            self.UI.setAttribute("soloBlight", "isOn", optionalSoloBlight)
            self.UI.setAttribute("blightSetup", "isOn", optionalBlightSetup)
            self.UI.setAttribute("extraBoard", "isOn", optionalExtraBoard)
            self.UI.setAttribute("boardPairings", "isOn", optionalBoardPairings)
            self.UI.setAttribute("slaveRebellionBack", "isOn", optionalUniqueRebellion)
            self.UI.setAttribute("thematicRedo", "isOn", optionalThematicRedo)
            self.UI.setAttribute("thematicPermute", "isOn", optionalThematicPermute)
            self.UI.setAttribute("carpetRedo", "isOn", Global.getVar("seaTile").getStateId() == 1)
            self.UI.setAttribute("gameResults", "isOn", optionalGameResults)

            self.UI.setAttribute("votd", "isOn", exploratoryVOTD)
            self.UI.setAttribute("bodan", "isOn", exploratoryBODAN)
            self.UI.setAttribute("war", "isOn", exploratoryWar)
            self.UI.setAttribute("aid", "isOn", exploratoryAid)
            self.UI.setAttribute("trickster", "isOn", exploratoryTrickster)
            self.UI.setAttribute("shadows", "isOn", exploratoryShadows)
            self.UI.setAttribute("fractured", "isOn", exploratoryFractured)

            togglePlaytestFear(nil, playtestFear, "playtestFear")
            togglePlaytestEvent(nil, playtestEvent, "playtestEvent")
            togglePlaytestBlight(nil, playtestBlight, "playtestBlight")
            togglePlaytestMinorPower(nil, playtestMinorPower, "playtestMinorPower")
            togglePlaytestMajorPower(nil, playtestMajorPower, "playtestMajorPower")

            toggleMinDifficulty(nil, randomMin)
            toggleMaxDifficulty(nil, randomMax)
            self.UI.setAttribute("maximizeLevelToggle", "isOn", randomMaximizeLevel)
            if randomAdversary or randomAdversary2 or randomScenario then
                enableRandomDifficulty()
            end

            for _,obj in pairs(getObjectsWithTag("Expansion")) do
                expansions[obj.getName()] = obj.guid
            end

            toggleLeadingLevel(nil, Global.getVar("adversaryLevel"))
            toggleSupportingLevel(nil, Global.getVar("adversaryLevel2"))
            local adversaryName = Global.getVar("adversaryCard")
            if adversaryName ~= "None" and adversaryName ~= "Random" then
                self.UI.setAttribute("leadingLevelSlider", "enabled", "true")
            end
            adversaryName = Global.getVar("adversaryCard2")
            if adversaryName ~= "None" and adversaryName ~= "Random" then
                self.UI.setAttribute("supportingLevelSlider", "enabled", "true")
            end

            local numPlayers = Global.getVar("numPlayers")
            self.UI.setAttribute("numPlayers", "text", "Number of Players: "..numPlayers)
            self.UI.setAttributes("numPlayersSlider", {value =  numPlayers, maxValue = Global.call("getSeatCount")})

            for name,guid in pairs(allAdversaries) do
                newAdversaryScenario(getObjectFromGUID(guid), true, adversaries[name] == nil)
            end
            for name,guid in pairs(allScenarios) do
                newAdversaryScenario(getObjectFromGUID(guid), false, scenarios[name] == nil)
            end

            Wait.frames(function()
                updateSelfXml()
                Wait.frames(function()
                    toggleSimpleMode()
                    toggleChallenge()
                    updateDifficulty()
                end, 2)
            end, 2)
        end
    end
    sourceSpirit = getObjectFromGUID("SourceSpirit")
end

function onObjectLeaveContainer(container, obj)
    if obj.hasTag("Spirit") then
        obj.setVar("leave", true)
    end
end
function onObjectSpawn(obj)
    if obj.hasTag("Spirit") then
        if obj.getVar("leave") then
            obj.setVar("leave")
        elseif obj.getVar("setup") then
            obj.setVar("setup")
        else
            sourceSpirit.call("load", {obj = obj})
        end
    elseif not setupStarted then
        if obj.type == "Card" then
            local objType = type(obj.getVar("difficulty"))
            if objType == "table" then
                newAdversaryScenario(obj, true)
                addAdversary(obj)
            elseif objType == "number" then
                newAdversaryScenario(obj, false)
                addScenario(obj)
            end
        end
        if obj.hasTag("Expansion") then
            addExpansion(obj)
        end
    end
end
function updateSelfXml()
    -- Bundles all updates to own UI XML together, to prevent race conditions.
    local funcList = {
        updateAdversaryList(),
        updateScenarioList(),
        updateExpansionToggles(),
        updateEventToggles(),
        updateBoardLayouts(),
        updatePlaytestExpansionList(),
    }
    updateXml(self, funcList)
end
function toggleAdversary(_, value, adversary)
    local obj = getObjectFromGUID(allAdversaries[adversary])
    if value == "True" then
        obj.UI.setAttribute(obj.getName(), "isOn", "true")
        addAdversary(obj)
    else
        obj.UI.setAttribute(obj.getName(), "isOn", "false")
        removeAdversary(obj)
    end
end
function toggleScenario(_, value, scenario)
    local obj = getObjectFromGUID(allScenarios[scenario])
    if value == "True" then
        obj.UI.setAttribute(obj.getName(), "isOn", "true")
        addScenario(obj)
    else
        obj.UI.setAttribute(obj.getName(), "isOn", "false")
        removeScenario(obj)
    end
end
function newAdversaryScenario(obj, adversary, disabled)
    local funcName = "SetupChecker/toggle"
    local position = "-95 -128 -28"
    local rotation = "0 0 180"
    if adversary then
        funcName = funcName.."Adversary"
        allAdversaries[obj.getName()] = obj.guid
    else
        funcName = funcName.."Scenario"
        position = "95 -128 28"
        rotation = "0 180 180"
        allScenarios[obj.getName()] = obj.guid
    end

    local enabled = "true"
    if disabled == true then
        enabled = "false"
    end

    obj.UI.setXmlTable({
        {
            tag = "Toggle",
            attributes = {
                id = obj.getName(),
                toggleWidth = "40",
                toggleHeight = "40",
                position = position,
                rotation = rotation,
                scale = "0.5 1 0.5",
                isOn = enabled,
                onValueChanged = funcName
            },
            children = {}
        }
    }, {})
end
function expansionHasEvents(bagGUID)
    local bag = getObjectFromGUID(bagGUID)
    if bag == nil then
        return false
    end
    local hasEvents = false
    for _,obj in pairs(bag.getObjects()) do
        if obj.name == "Events" then
            hasEvents = true
            break
        end
    end
    return hasEvents
end
function checkExpansionRequiredTags(bagGUID)
    local bag = getObjectFromGUID(bagGUID)
    if bag == nil then
        return false
    end
    if bag.hasTag("Requires Tokens") and not Global.call("usingSpiritTokens") then
        return false
    elseif bag.hasTag("Requires Badlands") and not Global.call("usingBadlands") then
        return false
    elseif bag.hasTag("Requires Isolate") and not Global.call("usingIsolate") then
        return false
    elseif bag.hasTag("Requires Vitality") and not Global.call("usingVitality") then
        return false
    elseif bag.hasTag("Requires Incarna") and not Global.call("usingIncarna") then
        return false
    elseif bag.hasTag("Requires Apocrypha") and not Global.call("usingApocrypha") then
        return false
    end
    return true
end
function addExpansion(bag)
    expansions[bag.getName()] = bag.guid
    updateSelfXml()
    Wait.frames(function() toggleExpansion(nil, nil, bag.getName()) end, 1)
end
function addAdversary(obj)
    if adversaries[obj.getName()] == nil then
        numAdversaries = numAdversaries + 1
    elseif adversaries[obj.getName()] == obj.guid then
        return
    end
    adversaries[obj.getName()] = obj.guid
    Wait.frames(updateSelfXml, 1)
end
function addScenario(obj)
    if scenarios[obj.getName()] == nil then
        numScenarios = numScenarios + 1
    elseif scenarios[obj.getName()] == obj.guid then
        return
    end
    scenarios[obj.getName()] = obj.guid
    Wait.frames(updateSelfXml, 1)
end
function onDestroy()
    exit = true
end
function onObjectEnterContainer(container, obj)
    if obj.hasTag("Spirit") then
        obj.setVar("enter", true)
    end
end
function onObjectDestroy(obj)
    if exit then
        return
    end
    if obj.hasTag("Spirit") then
        if obj.getVar("enter") then
            obj.setVar("enter")
        elseif obj.getVar("setup") then
            obj.setVar("setup")
        elseif obj.getVar("reload") then
            obj.setVar("reload")
        else
            removeSpirit({spirit=obj})
        end
    elseif not setupStarted then
        if obj.type == "Card" then
            local objType = type(obj.getVar("difficulty"))
            if objType == "table" then
                removeAdversary(obj)
                allAdversaries[obj.getName()] = nil
            elseif objType == "number" then
                removeScenario(obj)
                allScenarios[obj.getName()] = nil
            end
        end
        if obj.hasTag("Expansion") then
            removeExpansion(obj)
        end
    end
end
function removeExpansion(bag)
    expansions[bag.getName()] = nil

    local exps = Global.getTable("expansions")
    exps[bag.getName()] = nil
    Global.setTable("expansions", exps)

    local events = Global.getTable("events")
    events[bag.getName()] = nil
    Global.setTable("events", events)

    updateSelfXml()

    Wait.frames(updateRequiredContent, 1)
end
function removeAdversary(obj)
    for name,guid in pairs(adversaries) do
        if guid ~= "" and guid == obj.guid then
            adversaries[name] = nil
            numAdversaries = numAdversaries - 1
            if Global.getVar("adversaryCard") == obj then
                Global.setVar("adversaryCard", nil)
                toggleLeadingLevel(nil, 0)
            end
            if Global.getVar("adversaryCard2") == obj then
                Global.setVar("adversaryCard2", nil)
                toggleSupportingLevel(nil, 0)
            end
            Wait.frames(updateSelfXml, 1)
            break
        end
    end
end
function updateAdversaryList()
    local adversaryList = {}
    for name,_ in pairs(adversaries) do
        table.insert(adversaryList, name)
    end

    local leadName = "None"
    local adversary = Global.getVar("adversaryCard")
    if adversary ~= nil then
        leadName = adversary.getName()
    elseif randomAdversary then
        leadName = "Random"
    end
    local supportName = "None"
    adversary = Global.getVar("adversaryCard2")
    if adversary ~= nil then
        supportName = adversary.getName()
    elseif randomAdversary2 then
        supportName = "Random"
    end

    local updateLeading = updateDropdownList("leadingAdversary", adversaryList, leadName)
    local updateSupporting = updateDropdownList("supportingAdversary", adversaryList, supportName)
    -- Note: short-circuiting here is fine, as neither function will return
    -- true, if the other would have effects on t.
    return function (t) return updateLeading(t) or updateSupporting(t) end
end
function removeScenario(obj)
    for name,guid in pairs(scenarios) do
        if guid ~= "" and guid == obj.guid then
            scenarios[name] = nil
            numScenarios = numScenarios - 1
            if Global.getVar("scenarioCard") == obj then
                Global.setVar("scenarioCard", nil)
                updateDifficulty()
            end
            Wait.frames(updateSelfXml, 1)
            break
        end
    end
end
function updateScenarioList()
    local scenarioList = {}
    for name,_ in pairs(scenarios) do
        table.insert(scenarioList, name)
    end

    local scenarioName = "None"
    local scenario = Global.getVar("scenarioCard")
    if scenario ~= nil then
        scenarioName = scenario.getName()
    elseif randomScenario then
        scenarioName = "Random"
    end

    return updateDropdownList("scenario", scenarioList, scenarioName)
end
function RandomAdversary()
    local adversary = indexTable(adversaries, math.random(1,numAdversaries))
    if adversary == "" then
        return nil
    end
    return getObjectFromGUID(adversaries[adversary])
end
function RandomScenario()
    local scenario = indexTable(scenarios, math.random(1,numScenarios))
    if scenario == "" then
        return nil
    end
    return getObjectFromGUID(scenarios[scenario])
end

---- Setup UI Section
function updateMaxPlayers(params)
    self.UI.setAttribute("numPlayersSlider", "maxValue", params.max)
    if Global.getVar("numPlayers") > params.max then
        updateNumPlayers(params.max, true)
    end
end
function toggleNumPlayers(_, value)
    updateNumPlayers(value, true)
end
function updateNumPlayers(value, updateUI)
    local numPlayers = tonumber(value)
    if numPlayers > 5 and optionalExtraBoard and Global.getVar("boardLayout") == "Thematic" then
        numPlayers = 5
    end
    if numPlayers > 6 and self.UI.getAttribute("challenge", "isOn") == "true" then
        numPlayers = 6
    end
    Global.setVar("numPlayers", numPlayers)
    if updateUI then
        self.UI.setAttribute("numPlayers", "text", "Number of Players: "..numPlayers)
        self.UI.setAttribute("numPlayersSlider", "value", numPlayers)
        if self.UI.getAttribute("challenge", "isOn") == "true" then
            challengeConfig = {}
            for i=1,challengeTier do
                challengeConfig[i] = getWeeklyChallengeConfig(i, challengeConfig[i-1])
            end
            setWeeklyChallengeUI(challengeConfig[challengeTier])
        end

        -- Stop previous timer and start a new one
        if updateLayoutsID ~= 0 then
            Wait.stop(updateLayoutsID)
        end
        updateLayoutsID = Wait.time(updateSelfXml, 0.5)
    end
end
function updateBoardLayouts()
    local numBoards = Global.getVar("numPlayers")
    if optionalExtraBoard then
        numBoards = numBoards + 1
    end
    local layoutNames = { "Balanced" }
    local alternateBoardLayoutNames = Global.getTable("alternateBoardLayoutNames")
    if alternateBoardLayoutNames[numBoards] then
        for _,layout in pairs(alternateBoardLayoutNames[numBoards]) do
            table.insert(layoutNames, layout)
        end
    end
    local canThematic = (numBoards <= 6)
    if canThematic then
        table.insert(layoutNames, "Thematic")
    end
    table.insert(layoutNames, "Random")
    if canThematic then
        table.insert(layoutNames, "Random with Thematic")
    end

    if not tFind(layoutNames, Global.getVar("boardLayout")) then
        Global.setVar("boardLayout", "Balanced")
    end

    return updateDropdownList("boardLayout", layoutNames, Global.getVar("boardLayout"))
end

function toggleScenario(_, value)
    updateScenario(value, true)
end
function updateScenario(value, updateUI)
    if value == "Random" then
        Global.setVar("scenarioCard", nil)
        randomScenario = true
        enableRandomDifficulty()
    else
        Global.setVar("scenarioCard", getObjectFromGUID(scenarios[value]))
        randomScenario = false
        checkRandomDifficulty(false)
    end
    updateDifficulty()

    if updateUI then
        -- Wait for difficulty to update
        Wait.frames(function() updateScenarioSelection(value) end, 1)
    end
end
function updateScenarioSelection(name)
    getXml(self, {updateDropdownSelection("scenario", name)})
end

function toggleLeadingAdversary(_, value)
    updateLeadingAdversary(value, true)
end
function updateLeadingAdversary(value, updateUI)
    if value == "Random" then
        Global.setVar("adversaryCard", nil)
        randomAdversary = true
        enableRandomDifficulty()
    else
        local card = getObjectFromGUID(adversaries[value])
        Global.setVar("adversaryCard", card)
        randomAdversary = false
        checkRandomDifficulty(false)
        if updateUI and card ~= nil then
            updateLeadingAdversarySliderMax(card, updateUI)
        end
    end
    if value == "None" or value == "Random" then
        updateLeadingLevel(0, updateUI)
    else
        updateDifficulty()
        if updateUI then
            self.UI.setAttribute("leadingLevelSlider", "enabled", "true")
        end
    end

    if updateUI then
        -- Wait for difficulty to update
        Wait.frames(function() updateLeadingSelection(value) end, 1)
    end
end
function updateLeadingAdversarySliderMax(card, updateUI)
    local max = #card.getTable("difficulty")
    self.UI.setAttribute("leadingLevelSlider", "maxValue", max)
    if max < Global.getVar("adversaryLevel") then
        updateLeadingLevel(max, updateUI)
    end
end
function updateLeadingSelection(name)
    getXml(self, {updateDropdownSelection("leadingAdversary", name)})
end
function toggleSupportingAdversary(_, value)
    updateSupportingAdversary(value, true)
end
function updateSupportingAdversary(value, updateUI)
    if value == "Random" then
        Global.setVar("adversaryCard2", nil)
        randomAdversary2 = true
        enableRandomDifficulty()
    else
        local card = getObjectFromGUID(adversaries[value])
        Global.setVar("adversaryCard2", card)
        randomAdversary2 = false
        checkRandomDifficulty(false)
        if updateUI and card ~= nil then
            updateSupportingAdversarySliderMax(card, updateUI)
        end
    end
    if value == "None" or value == "Random" then
        updateSupportingLevel(0, updateUI)
    else
        updateDifficulty()
        if updateUI then
            self.UI.setAttribute("supportingLevelSlider", "enabled", "true")
        end
    end

    if updateUI then
        -- Wait for difficulty to update
        Wait.frames(function() updateSupportingSelection(value) end, 1)
    end
end
function updateSupportingAdversarySliderMax(card, updateUI)
    local max = #card.getTable("difficulty")
    self.UI.setAttribute("supportingLevelSlider", "maxValue", max)
    if max < Global.getVar("adversaryLevel2") then
        updateSupportingLevel(max, updateUI)
    end
end
function updateSupportingSelection(name)
    getXml(self, {updateDropdownSelection("supportingAdversary", name)})
end
function toggleLeadingLevel(_, value)
    updateLeadingLevel(value, true)
end
function updateLeadingLevel(value, updateUI)
    if Global.getVar("adversaryCard") == nil then
        Global.setVar("adversaryLevel", 0)
        value = 0
        if updateUI then
            self.UI.setAttribute("leadingLevelSlider", "enabled", "false")
        end
    else
        Global.setVar("adversaryLevel", tonumber(value))
    end
    if updateUI then
        self.UI.setAttribute("leadingLevel", "text", "Level: "..value)
        self.UI.setAttribute("leadingLevelSlider", "value", value)
    end
    updateDifficulty()
end
function toggleSupportingLevel(_, value)
    updateSupportingLevel(value, true)
end
function updateSupportingLevel(value, updateUI)
    if Global.getVar("adversaryCard2") == nil then
        Global.setVar("adversaryLevel2", 0)
        value = 0
        if updateUI then
            self.UI.setAttribute("supportingLevelSlider", "enabled", "false")
        end
    else
        Global.setVar("adversaryLevel2", tonumber(value))
    end
    if updateUI then
        self.UI.setAttribute("supportingLevel", "text", "Level: "..value)
        self.UI.setAttribute("supportingLevelSlider", "value", value)
    end
    updateDifficulty()
end

function updateRequiredContent()
    requiredContent("Requires Tokens", Global.call("usingSpiritTokens"))
    requiredContent("Requires Badlands", Global.call("usingBadlands"))
    requiredContent("Requires Isolate", Global.call("usingIsolate"))
    requiredContent("Requires Vitality", Global.call("usingVitality"))
    requiredContent("Requires Incarna", Global.call("usingIncarna"))
    requiredContent("Requires Apocrypha", Global.call("usingApocrypha"))
end
function requiredContent(tag, enabled)
    local colors = {}
    if not enabled then
        colors = Player.getColors()
    end
    for _,obj in pairs(getObjectsWithTag(tag)) do
        obj.setInvisibleTo(colors)

        if obj.hasTag("Spirit") then
            if #colors == 0 then
                addSpirit({spirit = obj})
            else
                removeSpirit({spirit = obj})
            end
        end

        if obj.type == "Card" then
            if #colors ~= 0 then
                obj.UI.hide(obj.getName())
            else
                obj.UI.show(obj.getName())
            end
            local objType = type(obj.getVar("difficulty"))
            if objType == "table" then
                if #colors == 0 then
                    if obj.UI.getAttribute(obj.getName(), "isOn") == "true" then
                        addAdversary(obj)
                    end
                else
                    removeAdversary(obj)
                end
            elseif objType == "number" then
                if #colors == 0 then
                    if obj.UI.getAttribute(obj.getName(), "isOn") == "true" then
                        addScenario(obj)
                    end
                else
                    removeScenario(obj)
                end
            end
        end
    end
end

function toggleExpansion(_, _, id)
    local exps = Global.getTable("expansions")
    local enable = not exps[id]

    if enable then
        enable = checkExpansionRequiredTags(expansions[id])
    end

    if not enable then
        exps[id] = nil
    else
        exps[id] = true
    end
    Global.setTable("expansions", exps)
    self.UI.setAttribute(id, "isOn", enable)

    if not enable then
        for exp, enabled in pairs(exps) do
            if enabled and exp ~= id then
                if not checkExpansionRequiredTags(expansions[exp]) then
                    toggleExpansion(_, _, exp)
                end
            end
        end
    end

    if expansionHasEvents(expansions[id]) then
        local events = Global.getTable("events")
        events[id] = exps[id]
        Global.setTable("events", events)
        self.UI.setAttribute(id.." Events", "isOn", enable)
        if enable then
            self.UI.setAttribute("allEvents", "isOn", "true")
        else
            local allDisabled = true
            for _,enabled in pairs(events) do
                if enabled then
                    allDisabled = false
                    break
                end
            end
            if allDisabled then
                self.UI.setAttribute("allEvents", "isOn", "false")
            end
        end
    end
    updateDifficulty()

    Wait.frames(updateSelfXml, 1)
    Wait.frames(updateRequiredContent, 2)
end
function toggleAllEvents()
    local checked = self.UI.getAttribute("allEvents", "isOn")
    if checked == "true" then
        self.UI.setAttribute("allEvents", "isOn", "false")
        local events = Global.getTable("events")
        for exp,enabled in pairs(events) do
            if enabled then
                toggleEvents(nil, nil, exp.." Events")
            end
        end
        Global.setTable("events", {})
    else
        self.UI.setAttribute("allEvents", "isOn", "true")
        local events = {}
        local exps = Global.getTable("expansions")
        for exp,enabled in pairs(exps) do
            if enabled then
                if expansionHasEvents(expansions[exp]) then
                    events[exp] = true
                    toggleEvents(nil, nil, exp.." Events")
                end
            end
        end
        Global.setTable("events", events)
    end
end
function toggleEvents(_, _, id)
    local exp = id:sub(1, -8)
    if not Global.getTable("expansions")[exp] then
        self.UI.setAttribute(id, "isOn", "false")
        return
    end
    local events = Global.getTable("events")
    local bool
    if events[exp] then
        events[exp] = nil
        bool = false
        local allDisabled = true
        for _,enabled in pairs(events) do
            if enabled then
                allDisabled = false
                break
            end
        end
        if allDisabled then
            self.UI.setAttribute("allEvents", "isOn", "false")
        end
    else
        events[exp] = true
        bool = true
        self.UI.setAttribute("allEvents", "isOn", "true")
    end
    Global.setTable("events", events)
    self.UI.setAttribute(id, "isOn", bool)
end

function updatePlaytestExpansionList()
    local playtestExpansions = {"None"}
    local found = false
    for name,enabled in pairs(Global.getTable("expansions")) do
        if enabled then
            table.insert(playtestExpansions, name)
            if playtestExpansion == name then
                found = true
            end
        end
    end

    if not found then
        playtestExpansion = "None"
    end

    return updateDropdownList("playtestExpansion", playtestExpansions, playtestExpansion)
end

function toggleBoardLayout(_, value)
    updateBoardLayout(value, true)
end
function updateBoardLayout(value, updateUI)
    if value == "Random" then
        randomBoard = true
        randomBoardThematic = false
        checkRandomDifficulty(false)
    elseif value == "Random with Thematic" then
        randomBoard = true
        randomBoardThematic = true
        enableRandomDifficulty()
    else
        randomBoard = false
        randomBoardThematic = false
        checkRandomDifficulty(false)
    end
    Global.setVar("boardLayout", value)
    updateDifficulty()

    if updateUI then
        -- Wait for difficulty to update
        Wait.frames(function() updateBoardLayoutSelection(value) end, 1)
    end
end
function updateBoardLayoutSelection(name)
    getXml(self, {updateDropdownSelection("boardLayout", name)})
end

function updateDifficulty()
    local difficulty = difficultyCheck({})
    Global.setVar("difficulty", difficulty)
    self.UI.setAttribute("difficulty", "text", "Total Difficulty: "..difficulty)
end
function difficultyCheck(params)
    local difficulty = 0

    local leadingAdversary
    if params.adversary then
        leadingAdversary = getObjectFromGUID(adversaries[params.adversary])
    else
        leadingAdversary = Global.getVar("adversaryCard")
    end
    if leadingAdversary ~= nil then
        local leadingLevel
        if params.adversaryLevel then
            leadingLevel = params.adversaryLevel
        else
            leadingLevel = Global.getVar("adversaryLevel")
        end
        difficulty = difficulty + leadingAdversary.getTable("difficulty")[leadingLevel]
    elseif params.lead ~= nil then
        difficulty = difficulty + params.lead
    end

    local supportingAdversary
    if params.adversary2 then
        supportingAdversary = getObjectFromGUID(adversaries[params.adversary2])
    else
        supportingAdversary = Global.getVar("adversaryCard2")
    end
    if supportingAdversary ~= nil then
        local supportingLevel
        if params.adversaryLevel2 then
            supportingLevel = params.adversaryLevel2
        else
            supportingLevel = Global.getVar("adversaryLevel2")
        end
        local difficulty2 = supportingAdversary.getTable("difficulty")[supportingLevel]
        if difficulty > difficulty2 then
            difficulty = difficulty + (0.5 * difficulty2)
        else
            difficulty = (0.5 * difficulty) + difficulty2
        end
    elseif params.support ~= nil then
        local difficulty2 = params.support
        if difficulty > difficulty2 then
            difficulty = difficulty + (0.5 * difficulty2)
        else
            difficulty = (0.5 * difficulty) + difficulty2
        end
    end

    local scenario
    if params.scenario then
        scenario = getObjectFromGUID(scenarios[params.scenario])
    else
        scenario = Global.getVar("scenarioCard")
    end
    if scenario ~= nil then
        difficulty = difficulty + scenario.getVar("difficulty")
    elseif params.scenario ~= nil then
        difficulty = difficulty + params.scenario
    end

    local boardLayout
    if params.boardLayout ~= nil then
        boardLayout = params.boardLayout
    else
        boardLayout = Global.getVar("boardLayout")
    end
    if boardLayout == "Thematic" or params.thematic then
        if params.expansions then
            local found = false
            for _, expansion in pairs(params.expansions) do
                if expansion == "Branch & Claw" or expansion == "Jagged Earth" then
                    found = true
                    break
                end
            end
            if found then
                difficulty = difficulty + 1
            else
                difficulty = difficulty + 3
            end
        else
            if Global.call("usingSpiritTokens") then
                difficulty = difficulty + 1
            else
                difficulty = difficulty + 3
            end
        end
    end

    local extraBoard
    if params.variant ~= nil and params.variant.extraBoard ~= nil then
        extraBoard = params.variant.extraBoard
    else
        extraBoard = optionalExtraBoard
    end
    if extraBoard then
        local intNum = math.floor(difficulty / 3) + 2
        difficulty = difficulty + intNum
        if boardLayout == "Thematic" or params.thematic then
            difficulty = difficulty - (intNum / 2)
        end
    end

    return difficulty
end

function startGame()
    if setupStarted then
        return
    end
    local config
    if weeklyChallenge then
        config = challengeConfig[challengeTier]
    else
        config = getNotebookConfig()
    end
    if config ~= nil then
        loadConfig(config)
    end
    if not Global.call("CanSetupGame") then
        return
    end
    if config == nil then
        local secondWave = getObjectFromGUID("e924fe")
        secondWave.setLock(false)
        Global.getVar("scenarioBag").putObject(secondWave)
    end
    setupStarted = true

    local exps = Global.getTable("expansions")
    for expansion,enabled in pairs(exps) do
        -- Playtest expansion setup is handled in Global script
        if enabled and expansions[expansion] and expansion ~= playtestExpansion then
            setupExpansion(getObjectFromGUID(expansions[expansion]))
        elseif expansion ~= playtestExpansion then
            -- expansion is disabled or doesn't exist in mod
            exps[expansion] = nil
        end
    end
    local events = Global.getTable("events")
    for expansion,enabled in pairs(events) do
        if not enabled or not exps[expansion] or not expansions[expansion] then
            events[expansion] = nil
        end
    end
    Global.setTable("expansions", exps)
    Global.setTable("events", events)

    Wait.condition(function()
        removeBannedCards()
        Global.call("SetupGame")
    end, function() return expansionsAdded == expansionsSetup end)
end
function getNotebookConfig()
    for _,data in pairs(Notes.getNotebookTabs()) do
        if data.title == "Game Config" then
            if data.body == "" then return nil end
            broadcastToAll("Loading config data from notebook", Color.SoftYellow)
            return JSON.decode(data.body)
        end
    end
    return nil
end
function loadConfig(config)
    if config.numPlayers then
        updateNumPlayers(config.numPlayers, false)
    end
    if config.boardLayout then
        -- Convert from reddit community names to ones used by our mod
        if config.boardLayout == "Standard" then
            config.boardLayout = "Balanced"
        elseif config.boardLayout == "Fragment 2" then
            config.boardLayout = "Inverted Fragment"
        end
        updateBoardLayout(config.boardLayout, false)
    end
    if config.variant then
        if config.variant.natureIncarnateSetup ~= nil then
            optionalNatureIncarnateSetup = config.variant.natureIncarnateSetup
        end
        if config.variant.blightCard ~= nil then
            optionalBlightCard = config.variant.blightCard
        end
        if config.variant.soloBlight ~= nil then
            optionalSoloBlight = config.variant.soloBlight
        end
        if config.variant.blightSetup ~= nil then
            optionalBlightSetup = config.variant.blightSetup
        end
        if config.variant.extraBoard ~= nil then
            optionalExtraBoard = config.variant.extraBoard
            if optionalExtraBoard then
                if config.variant.extraBoardRandom ~= nil then
                    Global.setVar("extraRandomBoard", config.variant.extraBoardRandom)
                end
            end
        end
        if config.variant.boardPairings ~= nil then
            optionalBoardPairings = config.variant.boardPairings
        end
        if config.variant.thematicRebellion ~= nil then
            setSlaveRebellion(config.variant.thematicRebellion, false)
        end
        if config.variant.uniqueRebellion ~= nil then
            optionalUniqueRebellion = config.variant.uniqueRebellion
        end
        if config.variant.thematicRedo ~= nil then
            optionalThematicRedo = config.variant.thematicRedo
        end
        if config.variant.thematicPermute ~= nil then
            optionalThematicPermute = config.variant.thematicPermute
        end
        if config.variant.carpetRedo ~= nil then
            local seaTile = Global.getVar("seaTile")
            if config.variant.carpetRedo then
                if seaTile.getStateId() ~= 1 then
                    seaTile.setState(1)
                end
            else
                if seaTile.getStateId() ~= 2 then
                    seaTile.setState(2)
                end
            end
        end
        if config.variant.gameResults ~= nil then
            optionalGameResults = config.variant.gameResults
        end
        if config.variant.drowningCap ~= nil then
            optionalDrowningCap = config.variant.drowningCap
        end
    end
    if config.exploratory then
        if config.exploratory.votd ~= nil then
            exploratoryVOTD = config.exploratory.votd
        end
        if config.exploratory.bodan ~= nil then
            exploratoryBODAN = config.exploratory.bodan
        end
        if config.exploratory.war ~= nil then
            exploratoryWar = config.exploratory.war
        end
        if config.exploratory.aid ~= nil then
            exploratoryAid = config.exploratory.aid
        end
        if config.exploratory.sweden ~= nil then
            setSweden(config.exploratory.sweden, false, false)
        end
        if config.exploratory.trickster ~= nil then
            exploratoryTrickster = config.exploratory.trickster
        end
        if config.exploratory.shadows ~= nil then
            exploratoryShadows = config.exploratory.shadows
        end
        if config.exploratory.fractured ~= nil then
            exploratoryFractured = config.exploratory.fractured
        end
    end
    if config.playtest then
        if config.playtest.expansion ~= nil then
            playtestExpansion = config.playtest.expansion
        end
        if config.playtest.fear ~= nil then
            playtestFear = config.playtest.fear
        end
        if config.playtest.event ~= nil then
            playtestEvent = config.playtest.event
        end
        if config.playtest.blight ~= nil then
            playtestBlight = config.playtest.blight
        end
        if config.playtest.minorPower ~= nil then
            playtestMinorPower = config.playtest.minorPower
        end
        if config.playtest.majorPower ~= nil then
            playtestMajorPower = config.playtest.majorPower
        end
    end
    if config.random then
        if config.random.min then
            randomMin = config.random.min
        end
        if config.random.max then
            randomMax = config.random.max
        end
        if config.random.adversary then
            randomAdversary = config.random.adversary
        end
        if config.random.adversary2 then
            randomAdversary2 = config.random.adversary2
        end
        if config.random.scenario then
            randomScenario = config.random.scenario
        end
        if config.random.board then
            randomBoard = config.random.board
        end
        if config.random.thematic then
            randomBoardThematic = config.random.thematic
        end
    end
    if config.boards then
        Global.setTable("selectedBoards", config.boards)
    end
    if config.blightCards then
        Global.setTable("blightCards", config.blightCards)
    end
    if config.adversary then
        if config.adversary == "Bradenburg-Prussia" then
            config.adversary = "Prussia"
        elseif config.adversary == "Habsburg" then
            config.adversary = "Habsburg-Livestock"
        end
        updateLeadingAdversary(config.adversary, false)
    end
    if config.adversaryLevel then
        updateLeadingLevel(config.adversaryLevel, false)
    end
    if config.adversary2 then
        if config.adversary2 == "Bradenburg-Prussia" then
            config.adversary2 = "Prussia"
        elseif config.adversary2 == "Habsburg" then
            config.adversary2 = "Habsburg-Livestock"
        end
        updateSupportingAdversary(config.adversary2, false)
    end
    if config.adversaryLevel2 then
        updateSupportingLevel(config.adversaryLevel2, false)
    end
    if config.scenario then
        updateScenario(config.scenario, false)
    end
    if config.secondWave then
        if config.secondWave.wave and config.secondWave.wave > 1 then
            Global.setVar("secondWave", getObjectFromGUID("e924fe"))
            Global.setVar("wave", config.secondWave.wave)
        end
    else
        local secondWave = getObjectFromGUID("e924fe")
        secondWave.setLock(false)
        Global.getVar("scenarioBag").putObject(secondWave)
    end
    if config.spirits then
        for name,aspect in pairs(config.spirits) do
            PickSpirit(name, aspect)
        end
    end
    if config.expansions then
        local exps = {}
        local events = {}
        for _,expansion in pairs(config.expansions) do
            exps[expansion] = true
            -- in case config.events isn't provided include events by default
            events[expansion] = true
        end
        Global.setTable("expansions", exps)
        Global.setTable("events", events)
    end
    if config.events then
        local events = {}
        for _,expansion in pairs(config.events) do
            events[expansion] = true
        end
        Global.setTable("events", events)
    end
    if config.broadcast then
        printToAll(config.broadcast, Color.SoftYellow)
    end
    updateDifficulty()
end
function PickSpirit(name, aspect)
    for _,spirit in pairs(getObjectsWithTag("Spirit")) do
        if spirit.getName():lower() == name:lower() then
            if isSpiritPickable({guid = spirit.guid}) then
                local color = Global.call("getEmptySeat")
                if color ~= nil then
                    sourceSpirit.call("PickSpirit", {obj = spirit, color = color, aspect = aspect})
                else
                    broadcastToAll("Unable to pick "..name..", no seats left", Color.Red)
                end
            end
            break
        end
    end
end
function setupExpansion(bag)
    expansionsAdded = expansionsAdded + 1
    _G["setupExpansionCo"] = function()
        local eventsStarted = false
        local eventsDone = false
        for _,obj in pairs(bag.getObjects()) do
            if obj.name == "Fear" then
                local fearDeck = bag.takeObject({guid = obj.guid})
                Global.getVar("fearDeckSetupZone").getObjects()[1].putObject(fearDeck)
            elseif obj.name == "Minor Powers" then
                local minorPowers = bag.takeObject({guid = obj.guid})
                getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1].putObject(minorPowers)
            elseif obj.name == "Major Powers" then
                local majorPowers = bag.takeObject({guid = obj.guid})
                getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1].putObject(majorPowers)
            elseif obj.name == "Blight Cards" then
                local blightCards = bag.takeObject({guid = obj.guid})
                Global.getVar("blightDeckZone").getObjects()[1].putObject(blightCards)
            elseif obj.name == "Events" then
                if Global.getTable("events")[bag.getName()] then
                    eventsStarted = true
                    local eventDeckZone = Global.getVar("eventDeckZone")
                    if #eventDeckZone.getObjects() > 0 then
                        local events = bag.takeObject({guid = obj.guid})
                        eventDeckZone.getObjects()[1].putObject(events)
                        eventsDone = true
                    else
                        local events = bag.takeObject({
                            guid = obj.guid,
                            position = eventDeckZone.getPosition(),
                            rotation = {0,180,180},
                            smooth = false,
                        })
                        Wait.condition(function() eventsDone = true end, function() return not events.loading_custom and #eventDeckZone.getObjects() == 1 end)
                    end
                end
            end
        end
        Wait.condition(function() expansionsSetup = expansionsSetup + 1 end, function() return eventsStarted == eventsDone end)
        return 1
    end
    startLuaCoroutine(self, "setupExpansionCo")
end
function removeBannedCards()
    for _,data in pairs(Notes.getNotebookTabs()) do
        if data.title == "Card Ban List" then
            if data.body == "" then
                return
            end

            local function split(inputstr, sep)
                local t={}
                for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                    table.insert(t, str)
                end
                return t
            end
            local count = 0
            local deck = nil
            local subBanList = nil -- luacheck: ignore 331

            for _,line in pairs(split(data.body, "\r\n")) do
                if line == "[Major Powers]" then
                    deck = getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1]
                    subBanList = banList["Major Powers"]
                elseif line == "[Minor Powers]" then
                    deck = getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1]
                    subBanList = banList["Minor Powers"]
                elseif line == "[Event Cards]" then
                    deck = Global.getVar("eventDeckZone").getObjects()[1]
                    subBanList = banList["Event Cards"]
                elseif line == "[Blight Cards]" then
                    deck = Global.getVar("blightDeckZone").getObjects()[1]
                    subBanList = banList["Blight Cards"]
                elseif line == "[Fear Cards]" then
                    deck = Global.getVar("fearDeckSetupZone").getObjects()[1]
                    subBanList = banList["Fear Cards"]
                else
                    if line:len() > 0 then
                        local lowerLine = line:lower()
                        for _,card in pairs(deck.getObjects()) do
                            if card.name:lower() == lowerLine or card.guid:lower() == lowerLine then
                                deck.takeObject({guid = card.guid}).destruct()
                                count = count + 1
                                break
                            end
                        end
                        subBanList[line] = true
                    end
                end
            end

            if count > 0 then
                broadcastToAll("Removed "..count.." cards as per ban list from notebook", Color.SoftYellow)
            end
            return
        end
    end
end

function showUI()
    toggleSetupUI(true)
    self.UI.setAttribute("panelSetupSmall", "visibility", "Invisible")
    toggleAdversaryScenarioVisiblity(true)
end
function hideUI()
    toggleSetupUI(false)
    self.UI.setAttribute("panelSetupSmall", "visibility", "")
    toggleAdversaryScenarioVisiblity(false)
end
function closeUI()
    toggleSetupUI(false)
    self.UI.setAttribute("panelSetupSmall", "visibility", "Invisible")
    toggleAdversaryScenarioVisiblity(true)
end
function toggleSetupUI(show)
    local visibility = ""
    if not show then
        visibility = "Invisible"
    end
    self.UI.setAttribute("panelSetup", "visibility", visibility)
    if show and self.UI.getAttribute("variant", "isOn") == "true" then
        self.UI.setAttribute("panelVariant", "visibility", "")
    else
        self.UI.setAttribute("panelVariant", "visibility", "Invisible")
    end
    if show and self.UI.getAttribute("exploratory", "isOn") == "true" then
        self.UI.setAttribute("panelExploratory", "visibility", "")
    else
        self.UI.setAttribute("panelExploratory", "visibility", "Invisible")
    end
    if show and self.UI.getAttribute("playtesting", "isOn") == "true" then
        self.UI.setAttribute("panelPlaytesting", "visibility", "")
    else
        self.UI.setAttribute("panelPlaytesting", "visibility", "Invisible")
    end
    if show and weeklyChallenge then
        self.UI.setAttribute("panelChallenge", "visibility", "")
    else
        self.UI.setAttribute("panelChallenge", "visibility", "Invisible")
    end
    self.UI.setAttribute("panelAdversaryScenario", "visibility", visibility)
    self.UI.setAttribute("panelAdvertising", "visibility", visibility)
end
function toggleAdversaryScenarioVisiblity(show)
    local colors = {}
    if not show then
        colors = Player.getColors()
    end
    for _,guid in pairs(allAdversaries) do
        if guid ~= "" then
            local obj = getObjectFromGUID(guid)
            obj.setInvisibleTo(colors)
            if not show then
                obj.UI.hide(obj.getName())
            else
                obj.UI.show(obj.getName())
            end
        end
    end
    for _,guid in pairs(allScenarios) do
        if guid ~= "" then
            local obj = getObjectFromGUID(guid)
            obj.setInvisibleTo(colors)
            if not show then
                obj.UI.hide(obj.getName())
            else
                obj.UI.show(obj.getName())
            end
        end
    end
    local secondWave = getObjectFromGUID("e924fe")
    if secondWave ~= nil then
        secondWave.setInvisibleTo(colors)
    end
end

function toggleSimpleMode()
    local checked = self.UI.getAttribute("simpleMode", "isOn")
    if checked == "true" then
        self.UI.setAttribute("simpleMode", "isOn", "false")
        self.UI.setAttribute("leadingText", "text", "Adversary")
        self.UI.setAttribute("supportingHeader", "visibility", "Invisible")
        self.UI.setAttribute("supportingRow", "visibility", "Invisible")
        checkRandomDifficulty(false)
        self.UI.setAttribute("simpleRow", "visibility", "")
        self.UI.setAttribute("toggles", "visibility", "Invisible")
        self.UI.setAttribute("toggles2", "visibility", "Invisible")
        self.UI.setAttribute("panelVariant", "visibility", "Invisible")
        self.UI.setAttribute("panelExploratory", "visibility", "Invisible")
        self.UI.setAttribute("panelPlaytesting", "visibility", "Invisible")
        self.UI.setAttribute("panelSpirit", "visibility", "Invisible")

        Global.setVar("showPlayerButtons", false)
        Global.call("updateAllPlayerAreas", nil)
    else
        self.UI.setAttribute("simpleMode", "isOn", "true")
        self.UI.setAttribute("leadingText", "text", "Leading Adversary")
        self.UI.setAttribute("supportingHeader", "visibility", "")
        self.UI.setAttribute("supportingRow", "visibility", "")
        checkRandomDifficulty(true)
        self.UI.setAttribute("simpleRow", "visibility", "Invisible")
        self.UI.setAttribute("toggles", "visibility", "")
        self.UI.setAttribute("toggles2", "visibility", "")
        showUI()
        self.UI.setAttribute("panelSpirit", "visibility", "")

        Global.setVar("showPlayerButtons", true)
        Global.call("updateAllPlayerAreas", nil)
    end
end
function toggleVariant()
    local checked = self.UI.getAttribute("variant", "isOn")
    if checked == "true" then
        self.UI.setAttribute("variant", "isOn", "false")
        self.UI.setAttribute("panelVariant", "visibility", "Invisible")
    else
        self.UI.setAttribute("variant", "isOn", "true")
        self.UI.setAttribute("panelVariant", "visibility", "")
    end
end
function toggleExploratory()
    local checked = self.UI.getAttribute("exploratory", "isOn")
    if checked == "true" then
        self.UI.setAttribute("exploratory", "isOn", "false")
        self.UI.setAttribute("panelExploratory", "visibility", "Invisible")
    else
        self.UI.setAttribute("exploratory", "isOn", "true")
        self.UI.setAttribute("panelExploratory", "visibility", "")
    end
end
function togglePlaytesting()
    local checked = self.UI.getAttribute("playtesting", "isOn")
    if checked == "true" then
        self.UI.setAttribute("playtesting", "isOn", "false")
        self.UI.setAttribute("panelPlaytesting", "visibility", "Invisible")
    else
        self.UI.setAttribute("playtesting", "isOn", "true")
        self.UI.setAttribute("panelPlaytesting", "visibility", "")
    end
end
function toggleChallenge()
    weeklyChallenge = not weeklyChallenge
    if weeklyChallenge then
        local numPlayers = Global.getVar("numPlayers")
        if numPlayers > 6 then
            toggleNumPlayers(nil, 6)
        end
        if challengeConfig[challengeTier] == nil then
            for i=1,challengeTier do
                if challengeConfig[i] == nil then
                    challengeConfig[i] = getWeeklyChallengeConfig(i, challengeConfig[i-1])
                end
            end
        end
        setWeeklyChallengeUI(challengeConfig[challengeTier])

        self.UI.setAttribute("leadingHeader", "visibility", "Invisible")
        self.UI.setAttribute("leadingRow", "visibility", "Invisible")
        self.UI.setAttribute("supportingHeader", "visibility", "Invisible")
        self.UI.setAttribute("supportingRow", "visibility", "Invisible")
        self.UI.setAttribute("scenarioHeader", "visibility", "Invisible")
        self.UI.setAttribute("scenarioRow", "visibility", "Invisible")
        self.UI.setAttribute("difficultyHeader", "visibility", "Invisible")
        self.UI.setAttribute("expansionsHeader", "visibility", "Invisible")
        self.UI.setAttribute("expansionsRow", "visibility", "Invisible")
        checkRandomDifficulty(false, true)
        self.UI.setAttribute("toggles3", "visibility", "Invisible")
        self.UI.setAttribute("panelSpirit", "visibility", "Invisible")
        self.UI.setAttribute("panelPlaytesting", "visibility", "Invisible")
        self.UI.setAttribute("panelChallenge", "visibility", "")
    else
        self.UI.setAttribute("leadingHeader", "visibility", "")
        self.UI.setAttribute("leadingRow", "visibility", "")
        self.UI.setAttribute("supportingHeader", "visibility", "")
        self.UI.setAttribute("supportingRow", "visibility", "")
        self.UI.setAttribute("scenarioHeader", "visibility", "")
        self.UI.setAttribute("scenarioRow", "visibility", "")
        self.UI.setAttribute("difficultyHeader", "visibility", "")
        self.UI.setAttribute("expansionsHeader", "visibility", "")
        self.UI.setAttribute("expansionsRow", "visibility", "")
        checkRandomDifficulty(true)
        self.UI.setAttribute("toggles3", "visibility", "")
        self.UI.setAttribute("panelSpirit", "visibility", "")
        if self.UI.getAttribute("playtesting", "isOn") == "true" then
            self.UI.setAttribute("panelPlaytesting", "visibility", "")
        end
        self.UI.setAttribute("panelChallenge", "visibility", "Invisible")
    end
    self.UI.setAttribute("challenge", "isOn", tostring(weeklyChallenge))
end
function toggleChallengeTier(_, selected, id)
    if selected == "0" then
        challengeTier = 1
    elseif selected == "1" then
        challengeTier = 2
    elseif selected == "2" then
        challengeTier = 3
    end
    for i=0,2 do
        self.UI.setAttribute(id..i, "isOn", "false")
    end
    self.UI.setAttribute(id..selected, "isOn", "true")
    if challengeConfig[challengeTier] == nil then
        for i=1,challengeTier do
            if challengeConfig[i] == nil then
                challengeConfig[i] = getWeeklyChallengeConfig(i, challengeConfig[i-1])
            end
        end
    end
    setWeeklyChallengeUI(challengeConfig[challengeTier])
end

function toggleMinDifficulty(_, value)
    local min = tonumber(value)
    if min > randomMax then
        randomMin = randomMax
    else
        randomMin = min
    end

    self.UI.setAttribute("minDifficulty", "text", "Min Random Difficulty: "..randomMin)
    self.UI.setAttribute("minDifficultySlider", "value", randomMin)
end
function toggleMaxDifficulty(_, value)
    local max = tonumber(value)
    if max < randomMin  then
        randomMax = randomMin
    else
        randomMax = max
    end

    self.UI.setAttribute("maxDifficulty", "text", "Max Random Difficulty: "..randomMax)
    self.UI.setAttribute("maxDifficultySlider", "value", randomMax)
end
function toggleMaximizeLevel()
    randomMaximizeLevel = not randomMaximizeLevel
    self.UI.setAttribute("maximizeLevelToggle", "isOn", randomMaximizeLevel)
end
function enableRandomDifficulty()
    self.UI.setAttribute("minTextRow", "visibility", "")
    self.UI.setAttribute("minRow", "visibility", "")
    self.UI.setAttribute("maxTextRow", "visibility", "")
    self.UI.setAttribute("maxRow", "visibility", "")
    self.UI.setAttribute("maximizeLevelRow", "visibility", "")
end
function checkRandomDifficulty(enable, force)
    local visibility = ""
    if not enable then
        visibility = "Invisible"
    end
    local random = randomAdversary or randomAdversary2 or randomBoardThematic or randomScenario
    if random == enable or force then
        self.UI.setAttribute("minTextRow", "visibility", visibility)
        self.UI.setAttribute("minRow", "visibility", visibility)
        self.UI.setAttribute("maxTextRow", "visibility", visibility)
        self.UI.setAttribute("maxRow", "visibility", visibility)
        self.UI.setAttribute("maximizeLevelRow", "visibility", visibility)
    end
end

function toggleSpirit(_,_,id)
    local checked = self.UI.getAttribute(id, "isOn")
    if checked == "true" then
        self.UI.setAttribute(id, "isOn", "false")
    else
        self.UI.setAttribute(id, "isOn", "true")
    end
end
function getSpiritTags()
    local tags = {}
    local added = false
    if self.UI.getAttribute("spiritBase", "isOn") == "true" then
        tags["Base"] = true
        added = true
    end
    if self.UI.getAttribute("spiritBnC", "isOn") == "true" then
        tags["BnC"] = true
        added = true
    end
    if self.UI.getAttribute("spiritJE", "isOn") == "true" then
        tags["JE"] = true
        added = true
    end
    if self.UI.getAttribute("spiritFnF", "isOn") == "true" then
        tags["FnF"] = true
        added = true
    end
    if self.UI.getAttribute("spiritHorizons", "isOn") == "true" then
        tags["Horizons"] = true
        added = true
    end
    if self.UI.getAttribute("spiritNI", "isOn") == "true" then
        tags["NI"] = true
        added = true
    end
    if self.UI.getAttribute("spiritApocrypha", "isOn") == "true" then
        tags["Apocrypha"] = true
        added = true
    end
    if self.UI.getAttribute("spiritCustom", "isOn") == "true" then
        tags[""] = true
        added = true
    end
    if not added then
        return nil
    end
    return tags
end
function getSpiritComplexities()
    local complexities = {
        [""] = true,
    }
    local added = false
    if self.UI.getAttribute("spiritLow", "isOn") == "true" then
        complexities["Low"] = true
        added = true
    end
    if self.UI.getAttribute("spiritModerate", "isOn") == "true" then
        complexities["Moderate"] = true
        added = true
    end
    if self.UI.getAttribute("spiritHigh", "isOn") == "true" then
        complexities["High"] = true
        added = true
    end
    if self.UI.getAttribute("spiritVeryHigh", "isOn") == "true" then
        complexities["Very High"] = true
        added = true
    end
    if not added then
        return nil
    end
    return complexities
end
function randomSpirit(player)
    if player.color == "Grey" or player.color == "Black" then
        return
    end
    if Global.getTable("selectedColors")[player.color] then
        player.broadcast("You already picked a spirit", Color.Red)
        return
    end
    if not Global.getTable("playerTables")[player.color] then
        return
    end

    local tags = getSpiritTags()
    if tags == nil then
        player.broadcast("You have no expansions selected", Color.Red)
        return
    end
    local complexities = getSpiritComplexities()
    if complexities == nil then
        player.broadcast("You have no complexities selected", Color.Red)
        return
    end

    local guid = spiritGuids[math.random(1,#spiritGuids)]
    local count = 0
    while((not tags[spiritTags[guid]] or not complexities[spiritComplexities[guid]]) and count < 100) do
        guid = spiritGuids[math.random(1,#spiritGuids)]
        count = count + 1
    end
    if count >= 100 then
        player.broadcast("No suitable spirit was found", Color.Red)
        return
    end
    local spirit = getObjectFromGUID(guid)
    sourceSpirit.call("PickSpirit", {obj = spirit, color = player.color, aspect = "Random"})
    player.broadcast("Your randomized spirit is "..spirit.getName(), "Blue")
end
function getGainSpiritChoices(obj)
    local choices = {}
    getXml(obj, {matchRecurse("GainSpirits", function (t)
        for _, button in pairs(t.children) do
            if button.tag == "Button" then
                table.insert(choices, {spirit = button.attributes.spirit, aspect = button.attributes.aspect})
            else
                table.insert(choices, {})
            end
        end
    end)})
    return choices
end
function setupGainSpiritChoices(obj, choices)
    local buttons = {}
    for _, choice in pairs(choices) do
        if choice.spirit ~= nil then
            local label = choice.spirit
            if choice.aspect ~= nil and choice.aspect ~= "" then
                label = label .. " - " .. choice.aspect
            end
            table.insert(buttons, {
                tag = "Button",
                attributes = {
                    id = "gain! " .. choice.spirit,
                    text = label,
                    onClick = "SetupChecker/pickGainSpiritChoice(" .. obj.guid .. ")",
                    fontSize = "44",
                    minWidth = "800",
                    minHeight = "110",
                    spirit = choice.spirit,
                    aspect = choice.aspect,
                },
                children = {},
            })
        else
            table.insert(buttons, {
                tag = "Text",
                attributes = {
                    minHeight = "110",
                },
                children = {},
            })
        end
    end
    updateXml(obj, {matchRecurse("GainSpirits", function (t) t.children = buttons end)})
end
function gainSpirit(player)
    if player.color == "Grey" or player.color == "Black" then
        player.broadcast("You need to pick a color before gaining spirits.", Color.Red)
        return
    end
    if Global.getTable("selectedColors")[player.color] then
        player.broadcast("You already picked a spirit", Color.Red)
        return
    end
    local obj = Global.getTable("playerTables")[player.color]
    if not obj then
        player.broadcast("You need to pick a table before gaining spirits.", Color.Red)
        return
    end

    local choices = getGainSpiritChoices(obj)
    local numChoices = 0
    for _, choice in pairs(choices) do
        if choice.spirit ~= nil then
            numChoices = numChoices + 1
        end
    end

    if numChoices == 4 then
        player.broadcast("You already have Spirit options", Color.Red)
        return
    end
    local tags = getSpiritTags()
    if tags == nil then
        player.broadcast("You have no expansions selected", Color.Red)
        return
    end
    local complexities = getSpiritComplexities()
    if complexities == nil then
        player.broadcast("You have no complexities selected", Color.Red)
        return
    end

    local count = 0
    for i = 1, 4 do
        if choices[i] == nil or choices[i].spirit == nil then
            local spirit, aspect = getNewSpirit(tags, complexities)
            if spirit then
                count = count + 1
                choices[i] = {spirit = spirit.getName(), aspect = aspect}
            else
                break
            end
        end
    end
    if count > 0 then
        setupGainSpiritChoices(obj, choices)
        player.broadcast("Your randomized spirits to choose from are in your play area", Color.SoftBlue)
    else
        player.broadcast("No suitable spirits were found", Color.Red)
    end
end
function getNewSpirit(tags, complexities)
    if spiritChoicesLength >= #spiritGuids then
        return nil
    end
    local spirit = getObjectFromGUID(spiritGuids[math.random(1,#spiritGuids)])
    local count = 0
    while((not tags[spiritTags[spirit.guid]] or not complexities[spiritComplexities[spirit.guid]] or spiritChoices[spirit.getName()]) and count < 100) do
        spirit = getObjectFromGUID(spiritGuids[math.random(1,#spiritGuids)])
        count = count + 1
    end
    if count >= 100 then
        return nil
    end
    local aspect = RandomAspect({obj = spirit})
    spiritChoices[spirit.getName()] = {guid=spirit.guid}
    spiritChoicesLength = spiritChoicesLength + 1
    return spirit, aspect
end
function replaceSpirit(obj, oldSpirit, player)
    local tags = getSpiritTags()
    if tags == nil then
        player.broadcast("You have no expansions selected", Color.Red)
        return
    end
    local complexities = getSpiritComplexities()
    if complexities == nil then
        player.broadcast("You have no complexities selected", Color.Red)
        return
    end
    local spirit, aspect = getNewSpirit(tags, complexities)
    local choices = getGainSpiritChoices(obj)
    for _, choice in pairs(choices) do
        if choice.spirit == oldSpirit then
            choice.spirit = spirit and spirit.getName()
            choice.aspect = aspect
            break
        end
    end
    setupGainSpiritChoices(obj, choices)
    if spirit ~= nil then
        player.broadcast("Spirit unavailable getting new one", Color.Red)
    else
        player.broadcast("No suitable replacment was found", Color.Red)
    end
end
function pickGainSpiritChoice(player, guid, id)
    local obj = getObjectFromGUID(guid)
    if Global.getTable("playerTables")[player.color] ~= obj then return end
    local spirit = obj.UI.getAttribute(id, "spirit")
    local aspect = obj.UI.getAttribute(id, "aspect")
    local spiritGuid = spiritChoices[spirit].guid
    if isSpiritPickable({guid = spiritGuid}) then
        sourceSpirit.call("PickSpirit", {obj = getObjectFromGUID(spiritGuid), color = player.color, aspect = aspect})
    else
        replaceSpirit(obj, spirit, player)
    end
end
function isSpiritPickable(params)
    for _,v in pairs(spiritGuids) do
        if v == params.guid then
            return true
        end
    end
    return false
end
function addSpirit(params)
    -- Ignore Source Spirit
    if params.spirit.guid == "SourceSpirit" then return end

    -- Spirit has already been picked
    if pickedSpirits[params.spirit.getName()] then
        return false
    end

    -- If spirit with same name has already been added, assume this is pulling spirit panel out of bag
    if allSpirits[params.spirit.getName()] and not params.spirit.getVar("reload") then
        return false
    end
    allSpirits[params.spirit.getName()] = true

    -- In case of state change, update existing choice with new guid
    if spiritChoices[params.spirit.getName()] ~= nil then
        spiritChoices[params.spirit.getName()].guid = params.spirit.guid
    end

    local found = false
    for _,guid in pairs(spiritGuids) do
        if guid == params.spirit.guid then
            found = true
            break
        end
    end
    if not found then
        table.insert(spiritGuids, params.spirit.guid)
    end

    local expansion = ""
    if params.spirit.hasTag("Base") then
        expansion = "Base"
    elseif params.spirit.hasTag("BnC") then
        expansion = "BnC"
    elseif params.spirit.hasTag("JE") then
        expansion = "JE"
    elseif params.spirit.hasTag("FnF") then
        expansion = "FnF"
    elseif params.spirit.hasTag("Horizons") then
        expansion = "Horizons"
    elseif params.spirit.hasTag("NI") then
        expansion = "NI"
    elseif params.spirit.hasTag("Apocrypha") then
        expansion = "Apocrypha"
    end
    spiritTags[params.spirit.guid] = expansion

    local complexity = ""
    if params.spirit.hasTag("Low") then
        complexity = "Low"
    elseif params.spirit.hasTag("Moderate") then
        complexity = "Moderate"
    elseif params.spirit.hasTag("High") then
        complexity = "High"
    elseif params.spirit.hasTag("Very High") then
        complexity = "Very High"
    end
    spiritComplexities[params.spirit.guid] = complexity

    return true
end
function removeSpirit(params)
    local found = false
    for i,guid in pairs(spiritGuids) do
        if guid == params.spirit.guid then
            table.remove(spiritGuids, i)
            found = true
            break
        end
    end
    if not found then
        return
    end

    if params.color ~= nil then
        pickedSpirits[params.spirit.getName()] = true
    end

    allSpirits[params.spirit.getName()] = nil
    spiritTags[params.spirit.guid] = nil
    spiritComplexities[params.spirit.guid] = nil
    found = false
    for _,data in pairs(spiritChoices) do
        if data.guid == params.spirit.guid then
            spiritChoicesLength = spiritChoicesLength - 1
            found = true
            break
        end
    end

    local foundColor = false
    local foundGain = not found
    for color,obj in pairs(Global.getTable("playerTables")) do
        if params.color == color then
            -- This is the table of the player selecting the spirit, so remove the choice buttons.
            setupGainSpiritChoices(obj, {})
            foundColor = true
            if foundGain then
                break
            end
        elseif not foundGain then
            local choices = getGainSpiritChoices(obj)
            for _, choice in pairs(choices) do
                if choice.spirit == params.spirit.getName() then
                    replaceSpirit(obj, choice.spirit, Player[color])
                    foundGain = true
                    break
                end
            end
            if foundColor then
                break
            end
        end
    end
end

function toggleSoloBlight()
    optionalSoloBlight = not optionalSoloBlight
    self.UI.setAttribute("soloBlight", "isOn", optionalSoloBlight)
end
function toggleBlightCard()
    optionalBlightCard = not optionalBlightCard
    self.UI.setAttribute("blightCard", "isOn", optionalBlightCard)
    self.UI.setAttribute("blightCard2", "isOn", optionalBlightCard)
end
function toggleBlightSetup()
    optionalBlightSetup = not optionalBlightSetup
    self.UI.setAttribute("blightSetup", "isOn", optionalBlightSetup)
end
function toggleExtraBoard()
    optionalExtraBoard = not optionalExtraBoard
    self.UI.setAttribute("extraBoard", "isOn", optionalExtraBoard)
    updateDifficulty()

    local numPlayers = Global.getVar("numPlayers")
    if optionalExtraBoard and numPlayers > 5 and Global.getVar("boardLayout") == "Thematic" then
        toggleNumPlayers(nil, 5)
    else
        -- Stop previous timer and start a new one
        if updateLayoutsID ~= 0 then
            Wait.stop(updateLayoutsID)
        end
        updateLayoutsID = Wait.time(updateSelfXml, 0.5)
    end
end
function toggleBoardPairings()
    optionalBoardPairings = not optionalBoardPairings
    self.UI.setAttribute("boardPairings", "isOn", optionalBoardPairings)
end
function toggleNatureIncarnateSetup()
    optionalNatureIncarnateSetup = not optionalNatureIncarnateSetup
    self.UI.setAttribute("natureIncarnateSetup", "isOn", optionalNatureIncarnateSetup)
end
function toggleSlaveRebellion()
    setSlaveRebellion(not optionalThematicRebellion, true)
end
function setSlaveRebellion(bool, updateUI)
    optionalThematicRebellion = bool
    local obj = getObjectFromGUID(adversaries.France)
    if obj ~= nil then
        obj.setVar("thematicRebellion", optionalThematicRebellion)
    end
    if updateUI then
        self.UI.setAttribute("slaveRebellion", "isOn", optionalThematicRebellion)
    end
end
function toggleSlaveRebellionBack()
    optionalUniqueRebellion = not optionalUniqueRebellion
    self.UI.setAttribute("slaveRebellionBack", "isOn", optionalUniqueRebellion)
end
function toggleThematicRedo()
    optionalThematicRedo = not optionalThematicRedo
    self.UI.setAttribute("thematicRedo", "isOn", optionalThematicRedo)
end
function toggleThematicPermute()
    optionalThematicPermute = not optionalThematicPermute
    self.UI.setAttribute("thematicPermute", "isOn", optionalThematicPermute)
end
function toggleCarpetRedo()
    local seaTile = Global.getVar("seaTile")
    if seaTile.getStateId() == 1 then
        seaTile.setState(2)
    else
        seaTile.setState(1)
    end
end
function toggleGameResults()
    optionalGameResults = not optionalGameResults
    self.UI.setAttribute("gameResults", "isOn", optionalGameResults)
end

function toggleExploratoryAll()
    local checked = self.UI.getAttribute("exploratoryAll", "isOn")
    if checked == "true" then
        checked = "false"
        if exploratoryVOTD then toggleVOTD() end
        if exploratoryBODAN then toggleBODAN() end
        if exploratoryWar then toggleWar() end
        if exploratoryAid then toggleAid() end
        if exploratorySweden then toggleSweden() end
        if exploratoryTrickster then toggleTrickster() end
        if exploratoryShadows then toggleShadows() end
        if exploratoryFractured then toggleFractured() end
    else
        checked = "true"
        if not exploratoryVOTD then toggleVOTD() end
        if not exploratoryBODAN then toggleBODAN() end
        if not exploratoryWar then toggleWar() end
        if not exploratoryAid then toggleAid() end
        if not exploratorySweden then toggleSweden() end
        if not exploratoryTrickster then toggleTrickster() end
        if not exploratoryShadows then toggleShadows() end
        if not exploratoryFractured then toggleFractured() end
    end
    self.UI.setAttribute("exploratoryAll", "isOn", checked)
end
function toggleVOTD()
    exploratoryVOTD = not exploratoryVOTD
    self.UI.setAttribute("votd", "isOn", exploratoryVOTD)
end
function toggleBODAN()
    exploratoryBODAN = not exploratoryBODAN
    self.UI.setAttribute("bodan", "isOn", exploratoryBODAN)
end
function toggleWar()
    exploratoryWar = not exploratoryWar
    self.UI.setAttribute("war", "isOn", exploratoryWar)
end
function toggleAid()
    exploratoryAid = not exploratoryAid
    self.UI.setAttribute("aid", "isOn", exploratoryAid)
end
function toggleSweden()
    setSweden(not exploratorySweden, true, false)
end
function setSweden(bool, updateUI, loading)
    exploratorySweden = bool
    local obj = getObjectFromGUID(adversaries.Sweden)
    if obj ~= nil then
        if exploratorySweden then
            obj.setTable("difficulty", {[0] = 1, 2, 3, 5, 6, 7, 8, 10})
            obj.setTable("fearCards", {[0] = {0,0,0}, {0,0,0}, {0,1,0}, {0,1,0}, {0,1,1}, {1,1,1}, {1,1,2}, {1,2,2}})
            if Global.getVar("adversaryCard") == obj then
                updateLeadingAdversarySliderMax(obj, updateUI)
            end
            if Global.getVar("adversaryCard2") == obj then
                updateSupportingAdversarySliderMax(obj, updateUI)
            end
        else
            obj.setTable("difficulty", {[0] = 1, 2, 3, 5, 6, 7, 8})
            obj.setTable("fearCards", {[0] = {0,0,0}, {0,0,0}, {0,1,0}, {0,1,0}, {0,1,1}, {1,1,1}, {1,1,2}})
            if Global.getVar("adversaryCard") == obj then
                updateLeadingAdversarySliderMax(obj, updateUI)
            end
            if Global.getVar("adversaryCard2") == obj then
                updateSupportingAdversarySliderMax(obj, updateUI)
            end
        end
        obj.setVar("exploratory", exploratorySweden)
        if updateUI and not loading then
            updateDifficulty()
        end
    end
    if updateUI then
        self.UI.setAttribute("sweden", "isOn", exploratorySweden)
    end
end
function toggleTrickster()
    exploratoryTrickster = not exploratoryTrickster
    self.UI.setAttribute("trickster", "isOn", exploratoryTrickster)
end
function toggleShadows()
    exploratoryShadows = not exploratoryShadows
    self.UI.setAttribute("shadows", "isOn", exploratoryShadows)
end
function toggleFractured()
    exploratoryFractured = not exploratoryFractured
    self.UI.setAttribute("fractured", "isOn", exploratoryFractured)
end

function wt(some)
    local Time = os.clock() + some
    while os.clock() < Time do
        coroutine.yield(0)
    end
end

function tFind(table, needle)
    for i, value in pairs(table) do
        if value == needle then
            return i
        end
    end
    return nil
end
---

--- Update the UI XML of an object.
-- This takes a list of function to use to update the XML table.
-- Each function should take a table element, update it with any relevant changes
-- and return `true` if updateXml should recurse into the children of the element.
-- Note: The functions should be prepared to be called on child elements, even if
-- recursion was not requested.
-- @param obj The object to update the UI XML for
-- @param updateFunctions The list of functions to use to update the table
function updateXml(obj, updateFunctions)
    local function recurse(t)
        local shouldRecurse = false
        for _, f in pairs(updateFunctions) do
            if f(t) then
                shouldRecurse = true
            end
        end
        if shouldRecurse then
            for _, v in pairs(t.children) do
                recurse(v)
            end
        end
    end
    local t = obj.UI.getXmlTable()
    for _,v in pairs(t) do
        recurse(v)
    end
    obj.UI.setXmlTable(t, {})
end
function getXml(obj, updateFunctions)
    local function recurse(t)
        local shouldRecurse = false
        for _, f in pairs(updateFunctions) do
            if f(t) then
                shouldRecurse = true
            end
        end
        if shouldRecurse then
            for _, v in pairs(t.children) do
                recurse(v)
            end
        end
    end
    local t = obj.UI.getXmlTable()
    for _,v in pairs(t) do
        recurse(v)
    end
end
--- Apply an XML UI update function on an element with a specific id
-- This returns a function suitable to pass to `updateXml` that applies the
-- given function to the element with the given id. All the parent elements of the
-- desired element must have the id present in the `recurse` attribute for this to
-- find the element.
-- @param id The id of the element to update
-- @param f The function that updates the element
function matchRecurse(id, f)
    return function (t)
        if t.attributes.recurse ~= nil and string.match(t.attributes.recurse, id) then
            if t.attributes.id == id then
                f(t)
            else
                return true
            end
        end
        return false
    end
end
--- Update a dropdown list to have the given items and selected item
-- @param id The id of the dropdown to update
-- @param values The list of values for the dropdown
-- @param selectedValue The value to mark as selected.
function updateDropdownList(id, values, selectedValue)
    return matchRecurse(id, function (t)
        t.children = {}
        for i,v in pairs(values) do
            t.children[i] = {
                tag="Option",
                value=v,
                attributes={},
                children={},
            }
            if v == selectedValue then
                t.attributes["value"] = i - 1
            end
        end
    end)
end
function updateDropdownSelection(id, value)
    return matchRecurse(id, function (t)
        for index,v in pairs(t.children) do
            if v.value == value then
                self.UI.setAttribute(id, "value", index-1)
                break
            end
        end
    end)
end

-- Update a 2-width grid of toggle buttons to the have the given items and states
-- @param id The id of the row containing the grid of toggles
-- @param values A table mapping toggle names to boolean values and tooltip
-- @param onValueChanged The name of the function to call when a toggle is clicked
function updateToggleGrid(id, values, onValueChanged)
    return matchRecurse(id, function (t)
        t.children[1].children[1].children = {}
        for name,params in pairs(values) do
            local attributes = {id = name, onValueChanged = onValueChanged, isOn = tostring(params.enabled)}
            if params.tooltip then
                attributes.tooltip = params.tooltip
            end
            table.insert(t.children[1].children[1].children, {
                tag="Toggle",
                value=name,
                attributes=attributes,
                children={},
            })
        end
        local count = #t.children[1].children[1].children
        t.attributes["preferredHeight"] = math.ceil(count / 2) * 60 + 0.1
    end)
end
function updateExpansionToggles()
    local exps = Global.getTable("expansions")
    local values = {}
    for name,guid in pairs(expansions) do
        values[name] = {}
        -- The Global expansions table stores nil for disabled expansions
        -- We want a boolean false, so we explicitly check for equality to true
        values[name].enabled = (exps[name] == true)

        local expBag = getObjectFromGUID(guid)
        if expBag and expBag.getDescription() then
            values[name].tooltip = expBag.getDescription()
        end
    end
    return updateToggleGrid("expansionsRow", values, "toggleExpansion")
end
function updateEventToggles()
    local events = Global.getTable("events")
    local values = {}
    for name,guid in pairs(expansions) do
        if expansionHasEvents(guid) then
            values[name.." Events"] = {}
            -- The Global events table stores nil for disabled expansions
            -- We want a boolean false, so we explicitly check for equality to true
            values[name.." Events"].enabled = (events[name] == true)
        end
    end
    return updateToggleGrid("events", values, "toggleEvents")
end

function updateAdversaryUI(params)
    local adversaryCard = Global.getVar("adversaryCard")
    local adversaryCard2 = Global.getVar("adversaryCard2")
    local funcList = {}
    if adversaryCard ~= nil then
        table.insert(funcList, addAdversaryRows(false, #adversaryCard.getTable("difficulty")))
    end
    if adversaryCard2 ~= nil then
        table.insert(funcList, addAdversaryRows(true, #adversaryCard2.getTable("difficulty")))
    end
    if #funcList > 0 then
        updateXml(Global, funcList)
    end
    if params.callback ~= nil then
        Wait.frames(function() Global.call(params.callback) end, 2)
    end
end
function addAdversaryRows(supporting, levels)
    local prefix = "panelAdversary"
    if supporting then
        prefix = prefix.."2"
    end
    local id = prefix.."Helper"
    return matchRecurse(id, function (t)
        for i=1,levels do
            table.insert(t.children, {
                tag="Text",
                value="",
                attributes={id = prefix.."Level"..i, active="false", fontsize="16", alignment="UpperLeft", tooltipPosition="Left"},
                children={},
            })
        end
    end)
end

function indexTable(table, index)
    local i = 1
    for name,guid in pairs(table) do
        if guid == "" then
            -- noop
        elseif i == index then
            return name
        else
            i = i + 1
        end
    end
    return ""
end
function getWeeklyChallengeConfig(tier, prevTierConfig)
    local function seedTimestamp()
        local weekDiff = 604800
        local dayDiff = 86400
        local hourDiff = 3600
        local time = os.time()
        time = time + (dayDiff * 3) - (hourDiff * 5)
        time = time - (time % weekDiff)
        time = time - (dayDiff * 3) + (hourDiff * 5)
        math.randomseed(time)
    end
    seedTimestamp()

    -- Requires both Branch & Claw and Jagged Earth expansions
    local config = {boards = {}, spirits = {}, expansions = {"Branch & Claw", "Jagged Earth", "Nature Incarnate"}, events = {}, broadcast = ""}
    local numPlayers = Global.getVar("numPlayers")

    local leadingAdversary = math.random(1, numAdversaries)
    config.adversary = indexTable(adversaries, leadingAdversary)
    local adversaryLevelMax = #getObjectFromGUID(adversaries[config.adversary]).getTable("difficulty")
    local adversaryLevelMaxFixed = adversaryLevelMax
    local fact = 1
    for i=2,adversaryLevelMax+1 do
        fact = fact * i
    end
    local leadingAdversaryLevel = math.random(0, fact)
    config.adversaryLevel = leadingAdversaryLevel % (adversaryLevelMax + 1)

    local supportingAdversary = math.random(1, numAdversaries - 1)
    if supportingAdversary >= leadingAdversary then
        supportingAdversary = supportingAdversary + 1
    end
    local adversary2 = indexTable(adversaries, supportingAdversary)
    local adversaryLevel2Max = #getObjectFromGUID(adversaries[adversary2]).getTable("difficulty")
    fact = 1
    for i=2,adversaryLevel2Max+1 do
        fact = fact * i
    end
    local supportingAdversaryLevel = math.random(0, fact)
    local adversaryLevel2 = supportingAdversaryLevel % (adversaryLevel2Max + 1)

    -- 2/3 chance to get scenario
    local useScenario = math.random(1, 3)
    if useScenario == 1 then
        local scenario = math.random(1, numScenarios)
        config.scenario = indexTable(scenarios, scenario)
    else
        math.random(0,0)
    end

    config.variant = {}
    config.variant.extraBoard = math.random(-2, 1) == 1

    local setups = Global.getTable("boardLayouts")
    local numBoards = numPlayers
    if config.variant.extraBoard then
        numBoards = numPlayers + 1
    end
    if math.random(-2, 1) == 1 then
        config.boardLayout = "Thematic"
        if numBoards > 6 then
            config.variant.extraBoard = false
            numBoards = 6
        end
    else
        local layoutsCount = 0
        for _,_ in pairs(setups[numBoards]) do
            layoutsCount = layoutsCount + 1
        end
        -- Thematic layout is always first index, so skip it
        local layoutRng = math.random(2, layoutsCount)
        -- Vary the layouts up a bit to not be uniform across all player counts
        layoutRng = (layoutRng - 2 + math.random(1, numBoards)) % (layoutsCount - 1) + 2
        config.boardLayout = indexTable(setups[numBoards], layoutRng)
    end

    local events = math.random(1, 12)
    if events == 1 or events == 4 or events == 5 or events >= 7 then
        table.insert(config.events, "Branch & Claw")
    end
    if events == 2 or events == 4 or events == 6 or events >= 7 then
        table.insert(config.events, "Jagged Earth")
    end
    if events == 3 or events == 5 or events == 6 or events >= 7 then
        table.insert(config.events, "Nature Incarnate")
    end

    local boardsCount
    local boards
    if config.boardLayout == "Thematic" then
        boards = {}
        for _,board in pairs(setups[numBoards]["Thematic"]) do
            boards[board.board] = false
        end
        boardsCount = numBoards
    else
        boards = {A = false, B = false, C = false, D = false, E = false, F = false, G = false, H = false}
        boardsCount = 8
    end
    local function findBoard(picked)
        local board
        if config.boardLayout == "Thematic" then
            board = math.random(1, 1)
        else
            board = math.random(1, boardsCount - picked)
        end
        local i = 1
        for name,taken in pairs(boards) do
            if taken then
                -- noop
            elseif i == board then
                boards[name] = true
                return name
            else
                i = i + 1
            end
        end
        return ""
    end

    -- Copy spiritGuids table so we can remove elements from it
    local spiritGuidsCopy = {table.unpack(spiritGuids)}
    for i=1,numPlayers do
        local index = math.random(1, #spiritGuidsCopy)
        local spirit = getObjectFromGUID(spiritGuidsCopy[index])
        local aspect = RandomAspect({obj=spirit})

        config.spirits[spirit.getName()] = aspect
        table.remove(spiritGuidsCopy, index)
        local boardName = findBoard(i - 1)
        table.insert(config.boards, boardName)
        if i ~= 1 then
            config.broadcast = config.broadcast.."\n"
        end
        config.broadcast = config.broadcast..boardName.." - "..spirit.getName()
    end

    local extraBoardRandom = nil
    if config.variant.extraBoard then
        -- make sure the extra board added is always the same one the next player would use
        math.random(0,0)
        math.random(0,0)
        if numPlayers > 7 then
            boards = {A2 = false, B2 = false, C2 = false, D2 = false, E2 = false, F2 = false, G2 = false, H2 = false}
            table.insert(config.boards, findBoard(0))
        else
            table.insert(config.boards, findBoard(numPlayers))
        end
        extraBoardRandom = config.boards[numBoards]
    end

    -- DO NOT put any more math.random calls below this block of code
    -- Change up the order of boards so the extra board isn't always last
    if config.boardLayout ~= "Thematic" then
        local function shuffle(tbl)
            for i = #tbl, 2, -1 do
                local j = math.random(i)
                tbl[i], tbl[j] = tbl[j], tbl[i]
            end
        end
        shuffle(config.boards)
    end
    if config.variant.extraBoard then
        for i, board in pairs(config.boards) do
            if board == extraBoardRandom then
                config.variant.extraBoardRandom = i
                break
            end
        end
    end

    -- Makes sure difficulty is in acceptable range for the tier of challenge
    local tiers = { {7, 10}, {10, 13}, {13, 16} }
    local difficulty = difficultyCheck(config)

    local adversaryLevelMin = 0
    local adversaryLevel2Min = -1
    if prevTierConfig ~= nil then
        adversaryLevelMin = prevTierConfig.adversaryLevel
        if prevTierConfig.adversaryLevel2 then
            -- Previous tier had second adversary so should this tier
            config.adversary2 = adversary2
            config.adversaryLevel2 = adversaryLevel2
            adversaryLevel2Min = prevTierConfig.adversaryLevel2
        end
        -- make sure adversary level is always increasing
        if prevTierConfig.variant.extraBoard then
            if adversaryLevelMin < adversaryLevelMax then
                adversaryLevelMin = adversaryLevelMin + 1
            end
            if prevTierConfig.adversaryLevel2 and adversaryLevel2Min < adversaryLevel2Max then
                adversaryLevel2Min = adversaryLevel2Min + 1
            end
        end
    end
    while difficulty < tiers[tier][1] or difficulty >= tiers[tier][2] do
        if difficulty < tiers[tier][1] then
            if config.adversaryLevel == adversaryLevelMaxFixed and not config.adversaryLevel2 then
                -- Need to add second adversary into mix
                adversaryLevelMin = adversaryLevelMaxFixed
                adversaryLevel2Min = 0
                config.adversary2 = adversary2
                config.adversaryLevel2 = adversaryLevel2
            else
                if config.adversaryLevel > adversaryLevelMin then
                    adversaryLevelMin = config.adversaryLevel
                end
                if config.adversaryLevel2 and config.adversaryLevel2 > adversaryLevel2Min then
                    adversaryLevel2Min = config.adversaryLevel2
                end
                if config.adversaryLevel < adversaryLevelMax then
                    local leadingDiff = adversaryLevelMax - config.adversaryLevel
                    config.adversaryLevel = leadingAdversaryLevel % leadingDiff + config.adversaryLevel + 1
                end
                if config.adversaryLevel2 and config.adversaryLevel2 < adversaryLevel2Max then
                    local supportingDiff = adversaryLevel2Max - config.adversaryLevel2
                    config.adversaryLevel2 = supportingAdversaryLevel % supportingDiff + config.adversaryLevel2 + 1
                end
            end
        else
            -- difficulty >= tiers[tier][2]
            if config.adversaryLevel < adversaryLevelMax then
                adversaryLevelMax = config.adversaryLevel
            end
            if config.adversaryLevel2 and config.adversaryLevel2 < adversaryLevel2Max then
                adversaryLevel2Max = config.adversaryLevel2
            end
            if config.adversaryLevel > adversaryLevelMin then
                local leadingDiff = config.adversaryLevel - adversaryLevelMin
                config.adversaryLevel = leadingAdversaryLevel % leadingDiff + adversaryLevelMin
            end
            if config.adversaryLevel2 and config.adversaryLevel2 > adversaryLevel2Min then
                local leadingDiff = config.adversaryLevel2 - adversaryLevel2Min
                config.adversaryLevel2 = supportingAdversaryLevel % leadingDiff + adversaryLevel2Min
            end
        end
        if adversaryLevelMin >= adversaryLevelMax and ((adversaryLevel2Min == -1 and adversaryLevelMin < adversaryLevelMaxFixed) or adversaryLevel2Min >= adversaryLevel2Max) then
            config.adversaryLevel = adversaryLevelMin
            if adversaryLevel2Min ~= -1 then
                config.adversaryLevel2 = adversaryLevel2Min
            end
            break
        end
        difficulty = difficultyCheck(config)
    end

    config.playtest = {expansion=""}

    math.randomseed(os.time())
    return config
end
function setWeeklyChallengeUI(config)
    local difficulty = difficultyCheck(config)
    self.UI.setAttribute("challengeLeadingAdversary", "text", "Leading Adversary: "..config.adversary.." "..config.adversaryLevel)
    if config.adversary2 then
        self.UI.setAttribute("challengeSupportingAdversary", "text", "Supporting Adversary: "..config.adversary2.." "..config.adversaryLevel2)
    else
        self.UI.setAttribute("challengeSupportingAdversary", "text", "")
    end
    if config.scenario then
        self.UI.setAttribute("challengeScenario", "text", "Scenario: "..config.scenario)
    else
        self.UI.setAttribute("challengeScenario", "text", "Scenario: None")
    end
    if #config.events == 0 then
        self.UI.setAttribute("challengeEvents", "text", "Events: None")
    else
        local events = "Events: "
        for _,expansion in pairs(config.events) do
            events = events..expansion..", "
        end
        self.UI.setAttribute("challengeEvents", "text", events:sub(1,-3))
    end
    self.UI.setAttribute("challengeLayout", "text", "Layout: "..config.boardLayout)
    if config.variant.extraBoard then
        self.UI.setAttribute("challengeExtraBoard", "text", "Extra Board: "..config.boards[config.variant.extraBoardRandom])
        self.UI.setAttribute("challengeExtraBoardRow", "visibility", "")
    else
        self.UI.setAttribute("challengeExtraBoardRow", "visibility", "Invisible")
    end
    self.UI.setAttribute("challengeDifficulty", "text", "Difficulty: "..difficulty)

    local i = 1
    for str in config.broadcast:gmatch("([^\n]+)") do
        local start, finish = str:find(" %- ")
        local spiritText = str:sub(finish+1)
        if config.spirits[spiritText] ~= "" then
            spiritText = spiritText.. " - "..config.spirits[spiritText]
        end
        self.UI.setAttribute("challengeSpirit"..i, "text", str:sub(1, start-1)..": "..spiritText)
        self.UI.setAttribute("challengeSpiritRow"..i, "visibility", "")
        i = i + 1
    end
    while i <= 6 do
        self.UI.setAttribute("challengeSpiritRow"..i, "visibility", "Invisible")
        i = i + 1
    end
end
function FindAspects(params)
    if params.obj.type == "Bag" then
        local aspects = {}
        for _,obj in pairs(params.obj.getObjects()) do
            for _,tag in pairs(obj.tags) do
                if tag == "Aspect" then
                    table.insert(aspects, obj)
                    break
                end
            end
        end
        return aspects
    else
        for _,obj in pairs(upCast(params.obj)) do
            if obj.hasTag("Aspect") then
                return obj
            end
        end
    end
    return nil
end
function upCast(obj)
    local hits = Physics.cast({
        origin       = obj.getPosition() + Vector(0,0.1,0),
        direction    = Vector(0,1,0),
        type         = 3,
        size         = obj.getBounds().size,
        orientation  = Vector(0, 180, 180),
    })
    local hitObjects = {}
    for _, v in pairs(hits) do
        if v.hit_object ~= obj then table.insert(hitObjects,v.hit_object) end
    end
    return hitObjects
end
function RandomAspect(params)
    local obj = FindAspects(params)
    if obj == nil then
        -- math.random call is for weekly challenge to always call once regardless of type of aspects
        math.random(0,0)
        return ""
    elseif type(obj) == "table" then
        local newDeck = {}
        local aspectNames = {}
        for _,aspect in pairs(obj) do
            local enabled = true
            for _,tag in pairs(aspect.tags) do
                if tag == "Requires Tokens" and not Global.call("usingSpiritTokens") then
                    enabled = false
                elseif tag == "Requires Badlands" and not Global.call("usingBadlands") then
                    enabled = false
                elseif tag == "Requires Isolate" and not Global.call("usingIsolate") then
                    enabled = false
                elseif tag == "Requires Vitality" and not Global.call("usingVitality") then
                    enabled = false
                elseif tag == "Requires Incarna" and not Global.call("usingIncarna") then
                    enabled = false
                elseif tag == "Requires Apocrypha" and not Global.call("usingApocrypha") then
                    enabled = false
                end
            end
            if enabled and not aspectNames[aspect.name] then
                table.insert(newDeck, aspect)
                aspectNames[aspect.name] = true
            end
        end
        local index = math.random(0,#newDeck)
        if index == 0 then
            return ""
        end
        return newDeck[index].name
    elseif obj.type == "Deck" then
        local newDeck = {}
        local aspectNames = {}
        for _,aspect in pairs(obj.getObjects()) do
            local enabled = true
            for _,tag in pairs(aspect.tags) do
                if tag == "Requires Tokens" and not Global.call("usingSpiritTokens") then
                    enabled = false
                elseif tag == "Requires Badlands" and not Global.call("usingBadlands") then
                    enabled = false
                elseif tag == "Requires Isolate" and not Global.call("usingIsolate") then
                    enabled = false
                elseif tag == "Requires Vitality" and not Global.call("usingVitality") then
                    enabled = false
                elseif tag == "Requires Incarna" and not Global.call("usingIncarna") then
                    enabled = false
                elseif tag == "Requires Apocrypha" and not Global.call("usingApocrypha") then
                    enabled = false
                end
            end
            if enabled and not aspectNames[aspect.name] then
                table.insert(newDeck, aspect)
                aspectNames[aspect.name] = true
            end
        end
        local index = math.random(0,#newDeck)
        if index == 0 then
            return ""
        end
        return newDeck[index].name
    elseif obj.type == "Card" then
        local count = 1
        if obj.hasTag("Requires Tokens") and not Global.call("usingSpiritTokens") then
            count = 0
        elseif obj.hasTag("Requires Badlands") and not Global.call("usingBadlands") then
            count = 0
        elseif obj.hasTag("Requires Isolate") and not Global.call("usingIsolate") then
            count = 0
        elseif obj.hasTag("Requires Vitality") and not Global.call("usingVitality") then
            count = 0
        elseif obj.hasTag("Requires Incarna") and not Global.call("usingIncarna") then
            count = 0
        elseif obj.hasTag("Requires Apocrypha") and not Global.call("usingApocrypha") then
            count = 0
        end
        local index = math.random(0,count)
        if index == 0 then
            return ""
        end
        return obj.getName()
    end
    return ""
end

function togglePlaytestExpansion(_, selected, id)
    playtestExpansion = selected
    getXml(self, {updateDropdownSelection(id, selected)})
end
function togglePlaytestFear(_, selected, id)
    if playtestExpansion ~= "None" then
        playtestFear = selected
    end
    for i=0,2 do
        self.UI.setAttribute(id..i, "isOn", "false")
    end
    self.UI.setAttribute(id..playtestFear, "isOn", "true")
end
function togglePlaytestEvent(_, selected, id)
    if playtestExpansion ~= "None" then
        playtestEvent = selected
    end
    for i=0,2 do
        self.UI.setAttribute(id..i, "isOn", "false")
    end
    self.UI.setAttribute(id..playtestEvent, "isOn", "true")
end
function togglePlaytestBlight(_, selected, id)
    if playtestExpansion ~= "None" then
        playtestBlight = selected
    end
    for i=0,2 do
        self.UI.setAttribute(id..i, "isOn", "false")
    end
    self.UI.setAttribute(id..playtestBlight, "isOn", "true")
end
function togglePlaytestMinorPower(_, selected, id)
    if playtestExpansion ~= "None" then
        playtestMinorPower = selected
    end
    for i=0,2 do
        self.UI.setAttribute(id..i, "isOn", "false")
    end
    self.UI.setAttribute(id..playtestMinorPower, "isOn", "true")
end
function togglePlaytestMajorPower(_, selected, id)
    if playtestExpansion ~= "None" then
        playtestMajorPower = selected
    end
    for i=0,2 do
        self.UI.setAttribute(id..i, "isOn", "false")
    end
    self.UI.setAttribute(id..playtestMajorPower, "isOn", "true")
end
