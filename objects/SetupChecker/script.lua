bncDone = false
jeDone = false
setupStarted = false

adversaries = {
    ["None"] = "",
    ["Random"] = "",
    ["Prussia"] = "dd3d47",
    ["England"] = "b765cf",
    ["Sweden"] = "f114f8",
    ["France"] = "e8f3e3",
    ["Habsburg"] = "1d9bcd",
    ["Russia"] = "1ea4cf",
    ["Scotland"] = "37a592",
}
numAdversaries = 7
scenarios = {
    ["None"] = "",
    ["Random"] = "",
    ["Blitz"] = "1b39da",
    ["Guard the Isle's Heart"] = "04397d",
    ["Rituals of Terror"] = "7ac013",
    ["Dahan Insurrection"] = "ee90ad",
    ["Ward the Shores"] = "bd528e",
    ["Powers Long Forgotten"] = "ca88f0",
    ["Rituals of the Destroying Flame"] = "a69e8c",
    ["Second Wave"] = "e924fe",
    ["The Great River"] = "5a95bc",
    ["Elemental Invocation"] = "b8b521",
    ["Despicable Theft"] = "ec49d4",
    ["Varied Terrains"] = "64caee",
    ["A Diversity of Spirits"] = "3d1ba3",
}
numScenarios = 13

-- This must match the same guids of global's elementScanZones
playerZones = {
    ["9fc5a4"] = true,
    ["654ab2"] = true,
    ["102771"] = true,
    ["6f2249"] = true,
    ["190f05"] = true,
    ["61ac7c"] = true,
}

spiritGuids = {}
spiritTags = {}
spiritComplexities = {}
spiritChoices = {}
spiritChoicesLength = 0

optionalSoloBlight = true
optionalStrangeMadness = false
optionalBlightSetup = true
optionalExtraBoard = false
optionalThematicRedo = false
optionalBoardPairings = true
optionalScaleBoard = true
optionalDigitalEvents = false

exploratoryVOTD = false
exploratoryBODAN = false
exploratoryWar = false
exploratoryAid = false

updateLayoutsID = 0
setupStarted = false
exit = false
sourceSpirit = nil
weeklyChallenge = false
challengeTier = 1
challengeConfig = nil

function onSave()
    local data_table = {}

    data_table.optionalBlightSetup = optionalBlightSetup

    local adversaryList = {}
    for name,guid in pairs(adversaries) do
        table.insert(adversaryList, {name=name, guid=guid})
    end
    data_table.adversaryList = adversaryList

    local scenarioList = {}
    for name,guid in pairs(scenarios) do
        table.insert(scenarioList, {name=name, guid=guid})
    end
    data_table.scenarioList = scenarioList

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

        optionalBlightSetup = loaded_data.optionalBlightSetup
        self.UI.setAttribute("blightSetup", "isOn", optionalBlightSetup)

        adversaries = {}
        local count = 0
        for _,params in pairs(loaded_data.adversaryList) do
            adversaries[params.name] = params.guid
            if params.guid ~= "" then
                count = count + 1
            end
        end
        numAdversaries = count

        scenarios = {}
        count = 0
        for _,params in pairs(loaded_data.scenarioList) do
            scenarios[params.name] = params.guid
            if params.guid ~= "" then
                count = count + 1
            end
        end
        numScenarios = count

        if not setupStarted then
            toggleLeadingLevel(nil, Global.getVar("adversaryLevel"))
            toggleSupportingLevel(nil, Global.getVar("adversaryLevel2"))

            local numPlayers = Global.getVar("numPlayers")
            self.UI.setAttribute("numPlayers", "text", "Number of Players: "..numPlayers)
            self.UI.setAttribute("numPlayersSlider", "value", numPlayers)

            if Global.getVar("BnCAdded") then
                self.UI.setAttribute("bnc", "isOn", "true")
                if Global.getVar("useBnCEvents") then
                    self.UI.setAttribute("bncEvents", "isOn", "true")
                end
            end
            if Global.getVar("JEAdded") then
                self.UI.setAttribute("je", "isOn", "true")
                if Global.getVar("useJEEvents") then
                    self.UI.setAttribute("jeEvents", "isOn", "true")
                end
            end

            -- queue up all dropdown changes as once
            Wait.frames(function()
                updateXml{
                    updateAdversaryList(),
                    updateScenarioList(),
                    updateBoardLayouts(numPlayers),
                }
                Wait.frames(updateDifficulty, 1)
            end, 2)
        end
    end
    sourceSpirit = getObjectFromGUID("SourceSpirit")
end

function onObjectSpawn(obj)
    if not setupStarted and obj.type == "Card" then
        local objType = type(obj.getVar("difficulty"))
        if objType == "table" then
            addAdversary(obj)
        elseif objType == "number" then
            -- Scenario
        end
    end
end
function addAdversary(obj)
    if adversaries[obj.getName()] == nil then
        numAdversaries = numAdversaries + 1
    end
    adversaries[obj.getName()] = obj.guid
    updateXml{updateAdversaryList()}
end
function onDestroy()
    exit = true
end
function onObjectDestroy(obj)
    if exit then
        return
    end
    if obj.hasTag("Spirit") then
        removeSpirit({spirit=obj.guid})
    elseif not setupStarted and obj.type == "Card" then
        local objType = type(obj.getVar("difficulty"))
        if objType == "table" then
            removeAdversary(obj)
        elseif objType == "number" then
            removeScenario(obj)
        end
    end
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
            Wait.frames(function() updateXml{updateAdversaryList()} end, 1)
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
    elseif Global.getVar("useRandomAdversary") then
        leadName = "Random"
    end
    local supportName = "None"
    adversary = Global.getVar("adversaryCard2")
    if adversary ~= nil then
        supportName = adversary.getName()
    elseif Global.getVar("useSecondAdversary") then
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
            Wait.frames(function () updateXml{updateScenarioList()} end, 1)
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
    elseif Global.getVar("useRandomScenario") then
        scenarioName = "Random"
    end

    return updateDropdownList("scenario", scenarioList, scenarioName)
end
function randomAdversary()
    local adversary = indexTable(adversaries, math.random(1,numAdversaries))
    if adversary == "" then
        return nil
    end
    return getObjectFromGUID(adversaries[adversary])
end
function randomScenario()
    local scenario = indexTable(scenarios, math.random(1,numScenarios))
    if scenario == "" then
        return nil
    end
    return getObjectFromGUID(scenarios[scenario])
end

---- Setup UI Section
function toggleNumPlayers(_, value)
    updateNumPlayers(value, true)
end
function updateNumPlayers(value, updateUI)
    local numPlayers = tonumber(value)
    if numPlayers > 5 and optionalExtraBoard then
        numPlayers = 5
    end
    Global.setVar("numPlayers", numPlayers)
    if updateUI then
        self.UI.setAttribute("numPlayers", "text", "Number of Players: "..numPlayers)
        self.UI.setAttribute("numPlayersSlider", "value", numPlayers)
        challengeConfig = getWeeklyChallengeConfig()

        -- Stop previous timer and start a new one
        if updateLayoutsID ~= 0 then
            Wait.stop(updateLayoutsID)
        end
        updateLayoutsID = Wait.time(function() updateXml{updateBoardLayouts(numPlayers)} end, 0.5)
    end
end
function updateBoardLayouts(numPlayers)
    local numBoards = numPlayers
    if optionalExtraBoard then
        numBoards = numPlayers + 1
    end
    local layoutNames = {
        "Balanced",
        "Thematic",
        "Random",
        "Random with Thematic",
        table.unpack(Global.getVar("alternateBoardLayoutNames")[numBoards])
    }

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
        Global.setVar("useRandomScenario", true)
        enableRandomDifficulty()
    else
        Global.setVar("scenarioCard", getObjectFromGUID(scenarios[value]))
        Global.setVar("useRandomScenario", false)
        checkRandomDifficulty(false)
    end
    updateDifficulty()

    if updateUI then
        -- Wait for difficulty to update
        Wait.frames(function() updateScenarioSelection(value) end, 1)
    end
end
function updateScenarioSelection(name)
    updateXml{
        updateDropdownSelection("scenario", name),
    }
end

function toggleLeadingAdversary(_, value)
    updateLeadingAdversary(value, true)
end
function updateLeadingAdversary(value, updateUI)
    if value == "Random" then
        Global.setVar("adversaryCard", nil)
        Global.setVar("useRandomAdversary", true)
        enableRandomDifficulty()
    else
        Global.setVar("adversaryCard", getObjectFromGUID(adversaries[value]))
        Global.setVar("useRandomAdversary", false)
        checkRandomDifficulty(false)
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
function updateLeadingSelection(name)
    updateXml{
        updateDropdownSelection("leadingAdversary", name),
    }
end
function toggleSupportingAdversary(_, value)
    updateSupportingAdversary(value, true)
end
function updateSupportingAdversary(value, updateUI)
    if value == "Random" then
        Global.setVar("adversaryCard2", nil)
        Global.setVar("useSecondAdversary", true)
        enableRandomDifficulty()
    else
        Global.setVar("adversaryCard2", getObjectFromGUID(adversaries[value]))
        Global.setVar("useSecondAdversary", false)
        checkRandomDifficulty(false)
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
function updateSupportingSelection(name)
    updateXml{
        updateDropdownSelection("supportingAdversary", name)
    }
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

function toggleBnC()
    local BnCAdded = Global.getVar("BnCAdded")
    BnCAdded = not BnCAdded
    Global.setVar("BnCAdded", BnCAdded)
    self.UI.setAttribute("bnc", "isOn", BnCAdded)
    Global.setVar("useBnCEvents", BnCAdded)
    self.UI.setAttribute("bncEvents", "isOn", BnCAdded)
    updateDifficulty()
end
function toggleJE()
    local JEAdded = Global.getVar("JEAdded")
    JEAdded = not JEAdded
    Global.setVar("JEAdded", JEAdded)
    self.UI.setAttribute("je", "isOn", JEAdded)
    Global.setVar("useJEEvents", JEAdded)
    self.UI.setAttribute("jeEvents", "isOn", JEAdded)
    updateDifficulty()
end
function toggleBnCEvents()
    if not Global.getVar("BnCAdded") then
        self.UI.setAttribute("bncEvents", "isOn", "false")
        return
    end
    local useBnCEvents = Global.getVar("useBnCEvents")
    useBnCEvents = not useBnCEvents
    Global.setVar("useBnCEvents", useBnCEvents)
    self.UI.setAttribute("bncEvents", "isOn", useBnCEvents)
end
function toggleJEEvents()
    if not Global.getVar("JEAdded") then
        self.UI.setAttribute("jeEvents", "isOn", "false")
        return
    end
    local useJEEvents = Global.getVar("useJEEvents")
    useJEEvents = not useJEEvents
    Global.setVar("useJEEvents", useJEEvents)
    self.UI.setAttribute("jeEvents", "isOn", useJEEvents)
end
function toggleBlightCard()
    local useBlightCard = Global.getVar("useBlightCard")
    useBlightCard = not useBlightCard
    Global.setVar("useBlightCard", useBlightCard)
    self.UI.setAttribute("blightCard", "isOn", useBlightCard)
    self.UI.setAttribute("blightCard2", "isOn", useBlightCard)
end

function toggleBoardLayout(_, value)
    updateBoardLayout(value, true)
end
function updateBoardLayout(value, updateUI)
    if value == "Random" then
        Global.setVar("useRandomBoard", true)
        Global.setVar("includeThematic", false)
        checkRandomDifficulty(false)
    elseif value == "Random with Thematic" then
        Global.setVar("useRandomBoard", true)
        Global.setVar("includeThematic", true)
        enableRandomDifficulty()
    else
        Global.setVar("useRandomBoard", false)
        Global.setVar("includeThematic", false)
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
    updateXml{
        updateDropdownSelection("boardLayout", name),
    }
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
        difficulty = difficulty + leadingAdversary.getVar("difficulty")[leadingLevel]
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
        local difficulty2 = supportingAdversary.getVar("difficulty")[supportingLevel]
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
        if Global.getVar("BnCAdded") or Global.getVar("JEAdded") then
            difficulty = difficulty + 1
        else
            difficulty = difficulty + 3
        end
    end

    local extraBoard
    if params.extraBoard ~= nil then
        extraBoard = params.extraBoard
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
        config = challengeConfig
    else
        config = getNotebookConfig()
    end
    if config ~= nil then
        loadConfig(config)
    end
    if not Global.call("CanSetupGame", {}) then
        return
    end
    setupStarted = true
    if Global.getVar("BnCAdded") then
        startLuaCoroutine(self, "addBnCCo")
    else
        bncDone = true
    end
    if Global.getVar("JEAdded") then
        startLuaCoroutine(self, "addJECo")
    else
        jeDone = true
    end
    Wait.condition(function() Global.call("SetupGame", {}) end, function() return bncDone and jeDone end)
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
    if config.extraBoard ~= nil then
        if config.extraBoard then
            optionalExtraBoard = true
        else
            optionalExtraBoard = false
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
        end
        updateLeadingAdversary(config.adversary, false)
    end
    if config.adversaryLevel then
        updateLeadingLevel(config.adversaryLevel, false)
    end
    if config.adversary2 then
        if config.adversary2 == "Bradenburg-Prussia" then
            config.adversary2 = "Prussia"
        end
        updateSupportingAdversary(config.adversary2, false)
    end
    if config.adversaryLevel2 then
        updateSupportingLevel(config.adversaryLevel2, false)
    end
    if config.scenario then
        updateScenario(config.scenario, false)
    end
    if config.spirits then
        for name,aspect in pairs(config.spirits) do
            PickSpirit(name, aspect)
        end
    end
    if config.expansions then
        local expansions = {}
        for _,expansion in pairs(config.expansions) do
            expansions[expansion] = true
        end
        if expansions.bnc then
            Global.setVar("BnCAdded", true)
            Global.setVar("useBnCEvents", true)
        else
            Global.setVar("BnCAdded", false)
            Global.setVar("useBnCEvents", false)
        end
        if expansions.je then
            Global.setVar("JEAdded", true)
            Global.setVar("useJEEvents", true)
        else
            Global.setVar("JEAdded", false)
            Global.setVar("useJEEvents", false)
        end
    end
    if config.events then
        local expansions = {}
        for _,expansion in pairs(config.events) do
            expansions[expansion] = true
        end
        if expansions.bnc then
            Global.setVar("useBnCEvents", true)
        else
            Global.setVar("useBnCEvents", false)
        end
        if expansions.je then
            Global.setVar("useJEEvents", true)
        else
            Global.setVar("useJEEvents", false)
        end
    end
    if config.broadcast then
        printToAll("Weekly Challenge - Spirit Setup", Color.White)
        printToAll(config.broadcast, Color.SoftBlue)
    end
    updateDifficulty()
end
function PickSpirit(name, aspect)
    for _,spirit in pairs(getObjectsWithTag("Spirit")) do
        if spirit.getName():lower() == name:lower() then
            if isSpiritPickable({guid = spirit.guid}) then
                local color = Global.call("getEmptySeat", {})
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
function addBnCCo()
    local BnCBag = getObjectFromGUID("BnCBag")

    local fearDeck = BnCBag.takeObject({guid = "d16f70"})
    getObjectFromGUID(Global.getVar("fearDeckSetupZone")).getObjects()[1].putObject(fearDeck)
    local minorPowers = BnCBag.takeObject({guid = "913789"})
    getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1].putObject(minorPowers)
    local majorPowers = BnCBag.takeObject({guid = "07ac50"})
    getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1].putObject(majorPowers)
    local blightCards = BnCBag.takeObject({guid = "788333"})
    getObjectFromGUID("b38ea8").getObjects()[1].putObject(blightCards)

    wt(0.5)
    bncDone = true
    return 1
end
function addJECo()
    local JEBag = getObjectFromGUID("JEBag")

    local fearDeck = JEBag.takeObject({guid = "723183"})
    getObjectFromGUID(Global.getVar("fearDeckSetupZone")).getObjects()[1].putObject(fearDeck)
    local minorPowers = JEBag.takeObject({guid = "80b54a"})
    getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1].putObject(minorPowers)
    local majorPowers = JEBag.takeObject({guid = "98a916"})
    getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1].putObject(majorPowers)
    local blightCards = JEBag.takeObject({guid = "8120e0"})
    getObjectFromGUID("b38ea8").getObjects()[1].putObject(blightCards)

    wt(0.5)
    jeDone = true
    return 1
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
    if show and self.UI.getAttribute("optionalRules", "isOn") == "true" then
        self.UI.setAttribute("panelOptional", "visibility", "")
    else
        self.UI.setAttribute("panelOptional", "visibility", "Invisible")
    end
    if show and self.UI.getAttribute("exploratory", "isOn") == "true" then
        self.UI.setAttribute("panelExploratory", "visibility", "")
    else
        self.UI.setAttribute("panelExploratory", "visibility", "Invisible")
    end
    if show and weeklyChallenge then
        self.UI.setAttribute("panelChallenge", "visibility", "")
    else
        self.UI.setAttribute("panelChallenge", "visibility", "Invisible")
    end
    self.UI.setAttribute("panelAdvesaryScenario", "visibility", visibility)
    self.UI.setAttribute("panelSpirit", "visibility", visibility)
end
function toggleAdversaryScenarioVisiblity(show)
    local colors = {}
    if not show then
        colors = Player.getColors()
    end
    for _,guid in pairs(adversaries) do
        if guid ~= "" then
            local obj = getObjectFromGUID(guid)
            obj.setInvisibleTo(colors)
        end
    end
    for _,guid in pairs(scenarios) do
        if guid ~= "" then
            local obj = getObjectFromGUID(guid)
            obj.setInvisibleTo(colors)
        end
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
        self.UI.setAttribute("blightCardRow", "visibility", "")
        self.UI.setAttribute("optionalCell", "visibility", "Invisible")
        self.UI.setAttribute("toggles", "visibility", "Invisible")
        self.UI.setAttribute("panelOptional", "visibility", "Invisible")
        self.UI.setAttribute("panelExploratory", "visibility", "Invisible")
        self.UI.setAttribute("panelSpirit", "visibility", "Invisible")

        Global.setVar("showPlayerButtons", false)
        Global.call("updateAllPlayerAreas", nil)
    else
        self.UI.setAttribute("simpleMode", "isOn", "true")
        self.UI.setAttribute("leadingText", "text", "Leading Adversary")
        self.UI.setAttribute("supportingHeader", "visibility", "")
        self.UI.setAttribute("supportingRow", "visibility", "")
        checkRandomDifficulty(true)
        self.UI.setAttribute("blightCardRow", "visibility", "Invisible")
        self.UI.setAttribute("optionalCell", "visibility", "")
        self.UI.setAttribute("toggles", "visibility", "")
        showUI()

        Global.setVar("showPlayerButtons", true)
        Global.call("updateAllPlayerAreas", nil)
    end
end
function toggleOptionalRules()
    local checked = self.UI.getAttribute("optionalRules", "isOn")
    if checked == "true" then
        self.UI.setAttribute("optionalRules", "isOn", "false")
        self.UI.setAttribute("panelOptional", "visibility", "Invisible")
    else
        self.UI.setAttribute("optionalRules", "isOn", "true")
        self.UI.setAttribute("panelOptional", "visibility", "")
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
function toggleChallenge()
    if challengeConfig == nil then
        challengeConfig = getWeeklyChallengeConfig()
    end
    weeklyChallenge = not weeklyChallenge
    if weeklyChallenge then
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
        self.UI.setAttribute("simpleMode", "visibility", "Invisible")
        self.UI.setAttribute("panelSpirit", "visibility", "Invisible")
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
        self.UI.setAttribute("simpleMode", "visibility", "")
        self.UI.setAttribute("panelSpirit", "visibility", "")
        self.UI.setAttribute("panelChallenge", "visibility", "Invisible")
    end
    self.UI.setAttribute("challenge", "isOn", weeklyChallenge)
end
function toggleChallengeTier(_, value)
    if value == "0" then
        challengeTier = 1
    elseif value == "1" then
        challengeTier = 2
    end
    challengeConfig = getWeeklyChallengeConfig()
end

function toggleMinDifficulty(_, value)
    local maxDifficulty = Global.getVar("maxDifficulty")
    local minDifficulty = tonumber(value)
    if minDifficulty > maxDifficulty then
        Global.setVar("minDifficulty", maxDifficulty)
        self.UI.setAttribute("minDifficulty", "text", "Min Random Difficulty: "..maxDifficulty)
        self.UI.setAttribute("minDifficultySlider", "value", maxDifficulty)
        return
    end

    Global.setVar("minDifficulty", minDifficulty)
    self.UI.setAttribute("minDifficulty", "text", "Min Random Difficulty: "..value)
    self.UI.setAttribute("minDifficultySlider", "value", value)
end
function toggleMaxDifficulty(_, value)
    local minDifficulty = Global.getVar("minDifficulty")
    local maxDifficulty = tonumber(value)
    if maxDifficulty < minDifficulty  then
        Global.setVar("maxDifficulty", minDifficulty)
        self.UI.setAttribute("maxDifficulty", "text", "Max Random Difficulty: "..minDifficulty)
        self.UI.setAttribute("maxDifficultySlider", "value", minDifficulty)
        return
    end

    Global.setVar("maxDifficulty", maxDifficulty)
    self.UI.setAttribute("maxDifficulty", "text", "Max Random Difficulty: "..value)
    self.UI.setAttribute("maxDifficultySlider", "value", value)
end
function enableRandomDifficulty()
    self.UI.setAttribute("minTextRow", "visibility", "")
    self.UI.setAttribute("minRow", "visibility", "")
    self.UI.setAttribute("maxTextRow", "visibility", "")
    self.UI.setAttribute("maxRow", "visibility", "")
end
function checkRandomDifficulty(enable, force)
    local visibility = ""
    if not enable then
        visibility = "Invisible"
    end
    local random = Global.getVar("useRandomAdversary")
            or Global.getVar("useSecondAdversary")
            or Global.getVar("includeThematic")
            or Global.getVar("useRandomScenario")
    if random == enable or force then
        self.UI.setAttribute("minTextRow", "visibility", visibility)
        self.UI.setAttribute("minRow", "visibility", visibility)
        self.UI.setAttribute("maxTextRow", "visibility", visibility)
        self.UI.setAttribute("maxRow", "visibility", visibility)
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
    if #getObjectFromGUID(Global.getVar("PlayerBags")[player.color]).getObjects() == 0 then
        Player[player.color].broadcast("You already picked a spirit", Color.Red)
        return
    end

    local tags = getSpiritTags()
    if tags == nil then
        Player[player.color].broadcast("You have no expansions selected", Color.Red)
        return
    end
    local complexities = getSpiritComplexities()
    if complexities == nil then
        Player[player.color].broadcast("You have no complexities selected", Color.Red)
        return
    end

    local guid = spiritGuids[math.random(1,#spiritGuids)]
    local count = 0
    while((not tags[spiritTags[guid]] or not complexities[spiritComplexities[guid]]) and count < 100) do
        guid = spiritGuids[math.random(1,#spiritGuids)]
        count = count + 1
    end
    if count >= 100 then
        Player[player.color].broadcast("No suitable spirit was found", Color.Red)
        return
    end
    local spirit = getObjectFromGUID(guid)
    sourceSpirit.call("PickSpirit", {obj = spirit, color = player.color, aspect = "Random"})
    Player[player.color].broadcast("Your randomized spirit is "..spirit.getName(), "Blue")
end
function gainSpirit(player)
    local obj = getObjectFromGUID(Global.getVar("elementScanZones")[player.color])
    if obj.getButtons() ~= nil and #obj.getButtons() ~= 0 then
        Player[player.color].broadcast("You already have Spirit options", Color.SoftYellow)
        return
    elseif #getObjectFromGUID(Global.getVar("PlayerBags")[player.color]).getObjects() == 0 then
        Player[player.color].broadcast("You already picked a spirit", Color.Red)
        return
    end
    local tags = getSpiritTags()
    if tags == nil then
        Player[player.color].broadcast("You have no expansions selected", Color.Red)
        return
    end
    local complexities = getSpiritComplexities()
    if complexities == nil then
        Player[player.color].broadcast("You have no complexities selected", Color.Red)
        return
    end

    local count = 0
    for i = 1,4 do
        local spirit, aspect = getNewSpirit(tags, complexities)
        if spirit then
            count = count + 1
            local label = spirit.getName()
            if aspect ~= nil and aspect ~= "" then
                label = label.."-"..aspect
            end
            obj.createButton({
                click_function = "pickSpirit" .. i,
                function_owner = self,
                label = label,
                position = Vector(0,0,0.3 - 0.15*i),
                rotation = Vector(0,180,0),
                scale = Vector(0.1,0.1,0.1),
                width = 4850,
                height = 600,
                font_size = 290,
            })
        end
    end
    if count > 0 then
        Player[player.color].broadcast("Your randomized spirits to choose from are in your play area", Color.SoftBlue)
    else
        Player[player.color].broadcast("No suitable spirits were found", Color.Red)
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
    local aspect = sourceSpirit.call("RandomAspect", {obj = spirit})
    spiritChoices[spirit.getName()] = {guid=spirit.guid, aspect=aspect}
    spiritChoicesLength = spiritChoicesLength + 1
    return spirit, aspect
end
function pickSpirit1(obj, color)
    if Global.getVar("elementScanZones")[color] ~= obj.guid then return end
    pickSpirit(obj, 0, color)
end
function pickSpirit2(obj, color)
    if Global.getVar("elementScanZones")[color] ~= obj.guid then return end
    pickSpirit(obj, 1, color)
end
function pickSpirit3(obj, color)
    if Global.getVar("elementScanZones")[color] ~= obj.guid then return end
    pickSpirit(obj, 2, color)
end
function pickSpirit4(obj, color)
    if Global.getVar("elementScanZones")[color] ~= obj.guid then return end
    pickSpirit(obj, 3, color)
end
function pickSpirit(obj, index, color)
    local name = obj.getButtons()[index+1].label
    local start,_ = string.find(name, "-")
    if start ~= nil then
        name = string.sub(name, 1, start-1)
    end
    local data = spiritChoices[name]
    if isSpiritPickable({guid = data.guid}) then
        sourceSpirit.call("PickSpirit", {obj = getObjectFromGUID(data.guid), color = color, aspect = data.aspect})
        obj.clearButtons()
    else
        local tags = getSpiritTags()
        if tags == nil then
            Player[color].broadcast("You have no expansions selected", Color.Red)
            return
        end
        local complexities = getSpiritComplexities()
        if complexities == nil then
            Player[color].broadcast("You have no complexities selected", Color.Red)
            return
        end
        local spirit = getNewSpirit(tags, complexities)
        if spirit ~= nil then
            Player[color].broadcast("Spirit unavailable getting new one", Color.SoftYellow)
            obj.editButton({
                index = index,
                label = spirit.getName(),
            })
        else
            Player[color].broadcast("No suitable replacment was found", Color.Red)
            obj.editButton({
                index = index,
                label = "",
                width = 0,
                height = 0,
            })
        end
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

    if Global.getVar("gameStarted") then
        for _, zone in pairs(params.spirit.getZones()) do
            if playerZones[zone.guid] then
                return
            end
        end
    end

    -- In case of state change, update existing choice with new guid
    for name,_ in pairs(spiritChoices) do
        if name == params.spirit.getName() then
            spiritChoices[name].guid = params.spirit.guid
            break
        end
    end

    table.insert(spiritGuids, params.spirit.guid)

    local expansion = ""
    if params.spirit.hasTag("Base") then
        expansion = "Base"
    elseif params.spirit.hasTag("BnC") then
        expansion = "BnC"
    elseif params.spirit.hasTag("JE") then
        expansion = "JE"
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
end
function removeSpirit(params)
    for i,guid in pairs(spiritGuids) do
        if guid == params.spirit then
            table.remove(spiritGuids, i)
            break
        end
    end
    for _, data in pairs(spiritChoices) do
        if data.guid == params.spirit then
            spiritChoicesLength = spiritChoicesLength - 1
            break
        end
    end
    spiritTags[params.spirit] = nil
    spiritComplexities[params.spirit] = nil
end

function toggleSoloBlight()
    optionalSoloBlight = not optionalSoloBlight
    self.UI.setAttribute("soloBlight", "isOn", optionalSoloBlight)
end
function toggleStrangeMadness()
    optionalStrangeMadness = not optionalStrangeMadness
    self.UI.setAttribute("strangeMadness", "isOn", optionalStrangeMadness)
end
function toggleSlaveRebellion()
    local checked = self.UI.getAttribute("slaveRebellion", "isOn")
    local obj = getObjectFromGUID(adversaries.France)
    if checked == "true" then
        checked = "false"
        if obj ~= nil then
            obj.setVar("thematicRebellion", false)
        end
    else
        checked = "true"
        if obj ~= nil then
            obj.setVar("thematicRebellion", true)
        end
    end
    self.UI.setAttribute("slaveRebellion", "isOn", checked)
end
function toggleEngland6()
    local checked = self.UI.getAttribute("england6", "isOn")
    local obj = getObjectFromGUID(adversaries.England)
    if checked == "true" then
        checked = "false"
        if obj ~= nil then
            obj.setTable("difficulty", {[0] = 1, 3, 4, 6, 7, 9, 10})
            updateDifficulty()
        end
    else
        checked = "true"
        if obj ~= nil then
            obj.setTable("difficulty", {[0] = 1, 3, 4, 6, 7, 9, 11})
            updateDifficulty()
        end
    end
    self.UI.setAttribute("england6", "isOn", checked)
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
    if optionalExtraBoard and numPlayers > 5 then
        toggleNumPlayers(nil, 5)
    else
        -- Stop previous timer and start a new one
        if updateLayoutsID ~= 0 then
            Wait.stop(updateLayoutsID)
        end
        updateLayoutsID = Wait.time(function() updateXml{updateBoardLayouts(numPlayers)} end, 0.5)
    end
end
function toggleThematicRedo()
    optionalThematicRedo = not optionalThematicRedo
    self.UI.setAttribute("thematicRedo", "isOn", optionalThematicRedo)
end
function toggleCarpetRedo()
    local seaTile = Global.getVar("seaTile")
    if seaTile.getStateId() == 1 then
        seaTile.setState(2)
    else
        seaTile.setState(1)
    end
end
function toggleBoardPairings()
    optionalBoardPairings = not optionalBoardPairings
    self.UI.setAttribute("boardPairings", "isOn", optionalBoardPairings)
end
function toggleDigitalEvents()
    optionalDigitalEvents = not optionalDigitalEvents
    self.UI.setAttribute("digitalEvents", "isOn", optionalDigitalEvents)
end

function toggleExploratoryAll()
    local checked = self.UI.getAttribute("exploratoryAll", "isOn")
    if checked == "true" then
        checked = "false"
        if exploratoryVOTD then toggleVOTD() end
        if exploratoryBODAN then toggleBODAN() end
        if exploratoryWar then toggleWar() end
        if exploratoryAid then toggleAid() end
    else
        checked = "true"
        if not exploratoryVOTD then toggleVOTD() end
        if not exploratoryBODAN then toggleBODAN() end
        if not exploratoryWar then toggleWar() end
        if not exploratoryAid then toggleAid() end
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

--- Update the UI XML of the current object.
-- This takes a list of function to use to update the XML table.
-- Each function should take a table element, update it with any relevant changes
-- and return `true` if updateXml should recurse into the children of the element.
-- Note: The functions should be prepared to be called on child elements, even if
-- recursion was not requested.
-- @param updateFunctions The list of functions to use to update the table
function updateXml(updateFunctions)
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
    local t = self.UI.getXmlTable()
    for _,v in pairs(t) do
        recurse(v)
    end
    self.UI.setXmlTable(t, {})
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
                t.children[i].attributes.selected = "true"
            end
        end
    end)
end
--- Update a dropdown list selection
-- @param id The id of the dropdown to update
-- @param selectedValue The value to mark as selected.
function updateDropdownSelection(id, value)
    return matchRecurse(id, function (t)
        for _,v in pairs(t.children) do
            if v.value == value then
                v.attributes.selected = "true"
            elseif v.attributes.selected == "true" then
                v.attributes.selected = "false"
            end
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
function getWeeklyChallengeConfig()
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
    local config = {boards = {}, spirits = {}, expansions = {"bnc", "je"}, events = {}, broadcast = ""}
    local numPlayers = Global.getVar("numPlayers")

    -- Requires two adversaries
    local leadingAdversary = math.random(1, numAdversaries)
    config.adversary = indexTable(adversaries, leadingAdversary)
    local leadingAdversaryLevel = math.random(0, 419)
    config.adversaryLevel = leadingAdversaryLevel % 7
    local supportingAdversary = math.random(1, numAdversaries - 1)
    if supportingAdversary >= leadingAdversary then
        supportingAdversary = supportingAdversary + 1
    end
    config.adversary2 = indexTable(adversaries, supportingAdversary)
    local supportingAdversaryLevel = math.random(0, 419)
    config.adversaryLevel2 = supportingAdversaryLevel % 7
    local scenario = math.random(-2, numScenarios)
    -- <= 0 means no scenario is selected
    if scenario > 0 then
        config.scenario = indexTable(scenarios, scenario)
    end

    -- Make extra board more likely on higher tier
    local extraBoard = math.random(-2, 1)
    if challengeTier == 1 then
        config.extraBoard = extraBoard == 1
    elseif challengeTier == 2 then
        config.extraBoard = extraBoard >= -1
    end
    if numPlayers == 6 then
        -- There's currently only 6 island boards in the game
        config.extraBoard = false
    end

    local setups = Global.getTable("boardLayouts")
    local numBoards = numPlayers
    if config.extraBoard then
        numBoards = numPlayers + 1
    end
    if math.random(-2, 1) == 1 then
        config.boardLayout = "Thematic"
    else
        local layoutsCount = 0
        for _,_ in pairs(setups[numBoards]) do
            layoutsCount = layoutsCount + 1
        end
        -- Thematic layout is always first index, so skip it
        config.boardLayout = indexTable(setups[numBoards], math.random(2, layoutsCount))
    end

    local events = math.random(1, 4)
    if events == 1 or events >= 3 then
        table.insert(config.events, "bnc")
    end
    if events == 2 or events >= 3 then
        table.insert(config.events, "je")
    end

    -- Copy spiritGuids table so we can remove elements from it
    local spiritGuidsCopy = {table.unpack(spiritGuids)}
    local boardsCount
    local boards
    if config.boardLayout == "Thematic" then
        boards = {}
        for _,board in pairs(setups[numBoards]["Thematic"]) do
            boards[board.board] = false
        end
        boardsCount = numBoards
    else
        boards = {A = false, B = false, C = false, D = false, E = false, F = false}
        boardsCount = 6
    end
    local function findBoard(picked)
        local board = math.random(1, boardsCount - picked)
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
    for i=1,numPlayers do
        local index = math.random(1, #spiritGuidsCopy)
        local spirit = getObjectFromGUID(spiritGuidsCopy[index])

        local aspects = sourceSpirit.call("FindAspects", {obj=spirit})
        local aspect = ""
        if aspects == nil then
            -- noop
        elseif aspects.type == "Deck" then
            local cards = aspects.getObjects()
            local aspectIndex = math.random(0,#cards)
            if aspectIndex ~= 0 then
                aspect = cards[aspectIndex].name
            end
        elseif aspects.type == "Card" then
            if math.random(0,1) == 1 then
                aspect = aspects.getName()
            end
        end

        config.spirits[spirit.getName()] = aspect
        table.remove(spiritGuidsCopy, index)
        local boardName = findBoard(i - 1)
        table.insert(config.boards, boardName)
        if i ~= 1 then
            config.broadcast = config.broadcast.."\n"
        end
        config.broadcast = config.broadcast..boardName.." - "..spirit.getName()
    end
    if config.extraBoard then
        table.insert(config.boards, findBoard(numPlayers))
    end

    -- Makes sure difficulty is in acceptable range for the tier of challenge
    local difficulty = difficultyCheck(config)
    while difficulty > 12 do
        if config.adversaryLevel > 0 then
            config.adversaryLevel = leadingAdversaryLevel % config.adversaryLevel
        end
        if config.adversaryLevel2 > 0 then
            config.adversaryLevel2 = supportingAdversaryLevel % config.adversaryLevel2
        end
        difficulty = difficultyCheck(config)
    end
    if challengeTier == 2 then
        -- Store tier 1's levels and reset back to initial levels
        local leadingAdversaryLevelTier1 = config.adversaryLevel
        local supportingAdversaryLevelTier1 = config.adversaryLevel2
        config.adversaryLevel = leadingAdversaryLevel % 7
        config.adversaryLevel2 = supportingAdversaryLevel % 7
        difficulty = difficultyCheck(config)

        while difficulty <= 12 do
            if config.adversaryLevel < 6 then
                local leadingDiff = 6 - config.adversaryLevel
                config.adversaryLevel = leadingAdversaryLevel % leadingDiff + config.adversaryLevel + 1
            end
            if config.adversaryLevel < 6 then
                local supportingDiff = 6 - config.adversaryLevel2
                config.adversaryLevel2 = supportingAdversaryLevel % supportingDiff + config.adversaryLevel2 + 1
            end
            difficulty = difficultyCheck(config)
        end

        -- Make sure adversary levels never go down when you increase difficulty
        if config.adversaryLevel < leadingAdversaryLevelTier1 then
            config.adversaryLevel = leadingAdversaryLevelTier1
        end
        if config.adversaryLevel2 < supportingAdversaryLevelTier1 then
            config.adversaryLevel2 = supportingAdversaryLevelTier1
        end
        difficulty = difficultyCheck(config)
    end

    setWeeklyChallengeUI(config, difficulty)
    math.randomseed(os.time())
    return config
end
function setWeeklyChallengeUI(config, difficulty)
    self.UI.setAttribute("challengeLeadingAdversary", "text", "Leading Adversary: "..config.adversary.." "..config.adversaryLevel)
    self.UI.setAttribute("challengeSupportingAdversary", "text", "Supporting Adversary: "..config.adversary2.." "..config.adversaryLevel2)
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
            local expansionString
            if expansion == "bnc" then
                expansionString = "B&C"
            else
                expansionString = expansion:upper()
            end
            events = events..expansionString..", "
        end
        self.UI.setAttribute("challengeEvents", "text", events:sub(1,-3))
    end
    self.UI.setAttribute("challengeLayout", "text", "Layout: "..config.boardLayout)
    if config.extraBoard then
        self.UI.setAttribute("challengeExtraBoard", "text", "Extra Board: "..config.boards[#config.boards])
        self.UI.setAttribute("challengeExtraBoardRow", "visibility", "")
    else
        self.UI.setAttribute("challengeExtraBoardRow", "visibility", "Invisible")
    end
    self.UI.setAttribute("challengeDifficulty", "text", "Difficulty: "..difficulty)

    local i = 1
    for spirit,aspect in pairs(config.spirits) do
        local spiritText = spirit
        if aspect ~= "" then
            spiritText = spiritText.. " - "..aspect
        end
        self.UI.setAttribute("challengeSpirit"..i, "text", config.boards[i]..": "..spiritText)
        self.UI.setAttribute("challengeSpiritRow"..i, "visibility", "")
        i = i + 1
    end
    while i <= 6 do
        self.UI.setAttribute("challengeSpiritRow"..i, "visibility", "Invisible")
        i = i + 1
    end
end
