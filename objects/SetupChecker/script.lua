expansions = {}
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

weeklyChallenge = false

randomMin = 0
randomMax = 11
randomAdversary = false
randomAdversary2 = false
randomScenario = false
randomBoard = false
randomBoardThematic = false

optionalStrangeMadness = false
optionalDigitalEvents = false
optionalBlightCard = true
optionalSoloBlight = true
optionalBlightSetup = true
optionalExtraBoard = false
optionalBoardPairings = true
optionalThematicRebellion = false
optionalEngland6 = true
optionalThematicRedo = false
optionalScaleBoard = true -- not currently hooked up into UI

exploratoryVOTD = false
exploratoryBODAN = false
exploratoryWar = false
exploratoryAid = false

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
challengeConfig = nil
expansionsAdded = 0
expansionsSetup = 0

function onSave()
    local data_table = {}

    data_table.toggle = {}
    data_table.toggle.variant = self.UI.getAttribute("variant", "isOn") == "true"
    data_table.toggle.exploratory = self.UI.getAttribute("exploratory", "isOn") == "true"
    data_table.toggle.playtest = self.UI.getAttribute("playtesting", "isOn") == "true"
    data_table.toggle.challenge = weeklyChallenge
    data_table.toggle.advanced = self.UI.getAttribute("simpleMode", "isOn") == "true"

    data_table.variant = {}
    data_table.variant.strangeMadness = optionalStrangeMadness
    data_table.variant.digitalEvents = optionalDigitalEvents
    data_table.variant.blightCard = optionalBlightCard
    data_table.variant.soloBlight = optionalSoloBlight
    data_table.variant.blightSetup = optionalBlightSetup
    data_table.variant.extraBoard = optionalExtraBoard
    data_table.variant.boardPairings = optionalBoardPairings
    data_table.variant.thematicRebellion = optionalThematicRebellion
    data_table.variant.england6 = optionalEngland6
    data_table.variant.thematicRedo = optionalThematicRedo

    data_table.exploratory = {}
    data_table.exploratory.votd = exploratoryVOTD
    data_table.exploratory.bodan = exploratoryBODAN
    data_table.exploratory.war = exploratoryWar
    data_table.exploratory.aid = exploratoryAid

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

        -- This will get flipped by toggleChallenge()
        weeklyChallenge = not loaded_data.toggle.challenge

        optionalStrangeMadness = loaded_data.variant.strangeMadness
        optionalDigitalEvents = loaded_data.variant.digitalEvents
        optionalBlightCard = loaded_data.variant.blightCard
        optionalSoloBlight = loaded_data.variant.soloBlight
        optionalBlightSetup = loaded_data.variant.blightSetup
        optionalExtraBoard = loaded_data.variant.extraBoard
        optionalBoardPairings = loaded_data.variant.boardPairings
        optionalThematicRebellion = loaded_data.variant.thematicRebellion
        optionalEngland6 = loaded_data.variant.england6
        optionalThematicRedo = loaded_data.variant.thematicRedo

        exploratoryVOTD = loaded_data.exploratory.votd
        exploratoryBODAN = loaded_data.exploratory.bodan
        exploratoryWar = loaded_data.exploratory.war
        exploratoryAid = loaded_data.exploratory.aid

        playtestExpansion = loaded_data.playtest.expansion
        playtestFear = loaded_data.playtest.fear
        playtestEvent = loaded_data.playtest.event
        playtestBlight = loaded_data.playtest.blight
        playtestMinorPower = loaded_data.playtest.minorPower
        playtestMajorPower = loaded_data.playtest.majorPower

        randomMin = loaded_data.random.min
        randomMax = loaded_data.random.max
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
            self.UI.setAttribute("variant", "isOn", tostring(loaded_data.toggle.variant))
            self.UI.setAttribute("exploratory", "isOn", tostring(loaded_data.toggle.exploratory))
            self.UI.setAttribute("playtesting", "isOn", tostring(loaded_data.toggle.playtest))
            self.UI.setAttribute("challenge", "isOn", tostring(loaded_data.toggle.challenge))
            -- set this to opposite boolean so that toggleSimpleMode() will handle all the UI panels easily
            self.UI.setAttribute("simpleMode", "isOn", tostring(not loaded_data.toggle.advanced))

            self.UI.setAttribute("strangeMadness", "isOn", optionalStrangeMadness)
            self.UI.setAttribute("digitalEvents", "isOn", optionalDigitalEvents)
            self.UI.setAttribute("blightCard", "isOn", optionalBlightCard)
            self.UI.setAttribute("blightCard2", "isOn", optionalBlightCard)
            self.UI.setAttribute("soloBlight", "isOn", optionalSoloBlight)
            self.UI.setAttribute("blightSetup", "isOn", optionalBlightSetup)
            self.UI.setAttribute("extraBoard", "isOn", optionalExtraBoard)
            self.UI.setAttribute("boardPairings", "isOn", optionalBoardPairings)
            local adversary = getObjectFromGUID(adversaries.France)
            if adversary ~= nil then
                adversary.setVar("thematicRebellion", optionalThematicRebellion)
            end
            self.UI.setAttribute("slaveRebellion", "isOn", optionalThematicRebellion)
            adversary = getObjectFromGUID(adversaries.England)
            if adversary ~= nil then
                if optionalEngland6 then
                    adversary.setTable("difficulty", {[0] = 1, 3, 4, 6, 7, 9, 11})
                else
                    adversary.setTable("difficulty", {[0] = 1, 3, 4, 6, 7, 9, 10})
                end
            end
            self.UI.setAttribute("england6", "isOn", optionalEngland6)
            self.UI.setAttribute("thematicRedo", "isOn", optionalThematicRedo)
            self.UI.setAttribute("carpetRedo", "isOn", Global.getVar("seaTile").getStateId() == 1)

            self.UI.setAttribute("votd", "isOn", exploratoryVOTD)
            self.UI.setAttribute("bodan", "isOn", exploratoryBODAN)
            self.UI.setAttribute("war", "isOn", exploratoryWar)
            self.UI.setAttribute("aid", "isOn", exploratoryAid)

            togglePlaytestFear(nil, playtestFear, "playtestFear")
            togglePlaytestEvent(nil, playtestEvent, "playtestEvent")
            togglePlaytestBlight(nil, playtestBlight, "playtestBlight")
            togglePlaytestMinorPower(nil, playtestMinorPower, "playtestMinorPower")
            togglePlaytestMajorPower(nil, playtestMajorPower, "playtestMajorPower")

            toggleMinDifficulty(nil, randomMin)
            toggleMaxDifficulty(nil, randomMax)
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
            self.UI.setAttribute("numPlayersSlider", "value", numPlayers)

            -- queue up all dropdown changes at once
            Wait.frames(function()
                local funcList = {
                    updateAdversaryList(),
                    updateScenarioList(),
                    updateBoardLayouts(numPlayers),
                    updatePlaytestExpansionList(expansions),
                }
                for expansion,guid in pairs(expansions) do
                    local hasEvents = false
                    for _,obj in pairs(getObjectFromGUID(guid).getObjects()) do
                        if obj.name == "Events" then
                            hasEvents = true
                            break
                        end
                    end
                    table.insert(funcList, addExpansionToggle(expansion))
                    if hasEvents then
                        table.insert(funcList, addEventToggle(expansion))
                    end
                end
                updateXml(funcList)
                Wait.frames(function()
                    toggleSimpleMode()
                    toggleChallenge()
                    local events = Global.getTable("events")
                    for expansion, enabled in pairs(Global.getTable("expansions")) do
                        if enabled then
                            self.UI.setAttribute(expansion, "isOn", "true")
                            if events[expansion] then
                                self.UI.setAttribute(expansion.." Events", "isOn", "true")
                            end
                        end
                    end

                    updateDifficulty()
                end, 2)
            end, 2)
        end
    end
    sourceSpirit = getObjectFromGUID("SourceSpirit")
end

function onObjectSpawn(obj)
    if not setupStarted then
        if obj.type == "Card" then
            local objType = type(obj.getVar("difficulty"))
            if objType == "table" then
                addAdversary(obj)
            elseif objType == "number" then
                -- Scenario
            end
        end
        if obj.hasTag("Expansion") then
            addExpansion(obj)
        end
    end
end
function addExpansion(bag)
    local hasEvents = false
    for _,obj in pairs(bag.getObjects()) do
        if obj.name == "Events" then
            hasEvents = true
            break
        end
    end
    if not expansions[bag.getName()] then
        local funcList = {addExpansionToggle(bag.getName())}
        if hasEvents then
            table.insert(funcList, addEventToggle(bag.getName()))
        end
        updateXml(funcList)
    end
    expansions[bag.getName()] = bag.guid
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
    elseif not setupStarted then
        if obj.type == "Card" then
            local objType = type(obj.getVar("difficulty"))
            if objType == "table" then
                removeAdversary(obj)
            elseif objType == "number" then
                removeScenario(obj)
            end
        end
        if obj.hasTag("Expansion") then
            removeExpansion(obj)
        end
    end
end
function removeExpansion(bag)
    local exps = Global.getTable("expansions")
    exps[bag.getName()] = nil
    Global.setTable("expansions", exps)
    expansions[bag.getName()] = nil

    local funcList = {
        removeToggle("expansionsRow", bag.getName()),
        removeToggle("events", "Use "..bag.getName().." Events"),
    }
    if playtestExpansion == bag.getName() then
        table.insert(funcList, updatePlaytestExpansionList(exps))
    end
    updateXml(funcList)
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
function toggleNumPlayers(_, value)
    updateNumPlayers(value, true)
end
function updateNumPlayers(value, updateUI)
    local numPlayers = tonumber(value)
    if numPlayers > 5 and optionalExtraBoard and Global.getVar("boardLayout") == "Thematic" then
        numPlayers = 5
    end
    Global.setVar("numPlayers", numPlayers)
    if updateUI then
        self.UI.setAttribute("numPlayers", "text", "Number of Players: "..numPlayers)
        self.UI.setAttribute("numPlayersSlider", "value", numPlayers)
        if self.UI.getAttribute("challenge", "isOn") == "true" then
            challengeConfig = nil
            for i=1,challengeTier do
                challengeConfig = getWeeklyChallengeConfig(i, challengeConfig)
            end
            setWeeklyChallengeUI(challengeConfig)
        end

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
    if numPlayers > 5 and optionalExtraBoard then
        -- Remove layouts that reference thematic since that isn't supported currently
        table.remove(layoutNames, 4)
        table.remove(layoutNames, 2)
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
    getXml{updateDropdownSelection("scenario", name)}
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
        Global.setVar("adversaryCard", getObjectFromGUID(adversaries[value]))
        randomAdversary = false
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
    getXml{updateDropdownSelection("leadingAdversary", name)}
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
        Global.setVar("adversaryCard2", getObjectFromGUID(adversaries[value]))
        randomAdversary2 = false
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
    getXml{updateDropdownSelection("supportingAdversary", name)}
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

function toggleExpansion(_, _, id)
    local exps = Global.getTable("expansions")
    local bool
    if exps[id] then
        exps[id] = nil
        bool = false
    else
        exps[id] = true
        bool = true
    end
    Global.setTable("expansions", exps)
    self.UI.setAttribute(id, "isOn", bool)
    local events = Global.getTable("events")
    events[id] = exps[id]
    Global.setTable("events", events)
    self.UI.setAttribute(id.." Events", "isOn", bool)
    updateDifficulty()
    Wait.frames(function () updateXml{updatePlaytestExpansionList(exps)} end, 1)
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
    else
        events[exp] = true
        bool = true
    end
    Global.setTable("events", events)
    self.UI.setAttribute(id, "isOn", bool)
end

function updatePlaytestExpansionList(exps)
    local playtestExpansions = {"None"}
    local found = false
    for name,enabled in pairs(exps) do
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
    getXml{updateDropdownSelection("boardLayout", name)}
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
        if Global.call("usingSpiritTokens") then
            difficulty = difficulty + 1
        else
            difficulty = difficulty + 3
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
        config = challengeConfig
    else
        config = getNotebookConfig()
    end
    if config ~= nil then
        loadConfig(config)
    end
    if not Global.call("CanSetupGame") then
        return
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

    Wait.condition(function() Global.call("SetupGame") end, function() return expansionsAdded == expansionsSetup end)
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
        if config.variant.strangeMadness ~= nil then
            optionalStrangeMadness = config.variant.strangeMadness
        end
        if config.variant.digitalEvents ~= nil then
            optionalDigitalEvents = config.variant.digitalEvents
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
            optionalThematicRebellion = config.variant.thematicRebellion
        end
        if config.variant.england6 ~= nil then
            optionalEngland6 = config.variant.england6
        end
        if config.variant.thematicRedo ~= nil then
            optionalThematicRedo = config.variant.thematicRedo
        end
        if config.variant.carpetRedo ~= nil then
            local seaTile = Global.getVar("seaTile")
            if config.variant.carpetRedo then
                seaTile.setState(1)
            else
                seaTile.setState(2)
            end
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
                getObjectFromGUID(Global.getVar("fearDeckSetupZone")).getObjects()[1].putObject(fearDeck)
            elseif obj.name == "Minor Powers" then
                local minorPowers = bag.takeObject({guid = obj.guid})
                getObjectFromGUID(Global.getVar("minorPowerZone")).getObjects()[1].putObject(minorPowers)
            elseif obj.name == "Major Powers" then
                local majorPowers = bag.takeObject({guid = obj.guid})
                getObjectFromGUID(Global.getVar("majorPowerZone")).getObjects()[1].putObject(majorPowers)
            elseif obj.name == "Blight Cards" then
                local blightCards = bag.takeObject({guid = obj.guid})
                getObjectFromGUID("b38ea8").getObjects()[1].putObject(blightCards)
            elseif obj.name == "Events" then
                if Global.getTable("events")[bag.getName()] then
                    eventsStarted = true
                    local eventDeckZone = getObjectFromGUID(Global.getVar("eventDeckZone"))
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
        self.UI.setAttribute("blightCardRow", "visibility", "Invisible")
        self.UI.setAttribute("toggles", "visibility", "")
        self.UI.setAttribute("toggles2", "visibility", "")
        showUI()

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
    if challengeConfig == nil then
        for i=1,challengeTier do
            challengeConfig = getWeeklyChallengeConfig(i, challengeConfig)
        end
        setWeeklyChallengeUI(challengeConfig)
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
        self.UI.setAttribute("toggles3", "visibility", "Invisible")
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
        self.UI.setAttribute("toggles3", "visibility", "")
        self.UI.setAttribute("panelSpirit", "visibility", "")
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
    challengeConfig = nil
    for i=1,challengeTier do
        challengeConfig = getWeeklyChallengeConfig(i, challengeConfig)
    end
    setWeeklyChallengeUI(challengeConfig)
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
    local random = randomAdversary or randomAdversary2 or randomBoardThematic or randomScenario
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
        Player[player.color].broadcast("You already have Spirit options", Color.Red)
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
function replaceSpirit(obj, index, color)
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
        Player[color].broadcast("Spirit unavailable getting new one", Color.Red)
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
        replaceSpirit(obj, index, color)
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
    spiritTags[params.spirit] = nil
    spiritComplexities[params.spirit] = nil
    for name, data in pairs(spiritChoices) do
        if data.guid == params.spirit then
            spiritChoicesLength = spiritChoicesLength - 1

            local found = false
            for color,guid in pairs(Global.getVar("elementScanZones")) do
                local zone = getObjectFromGUID(guid)
                local buttons = zone.getButtons()
                if buttons ~= nil then
                    for index,button in pairs(buttons) do
                        local label = button.label
                        local start,_ = string.find(label, "-")
                        if start ~= nil then
                            label = string.sub(label, 1, start-1)
                        end
                        if name == label then
                            replaceSpirit(zone, index-1, color)
                            found = true
                            break
                        end
                    end
                    if found then
                        break
                    end
                end
            end
            break
        end
    end
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
    optionalThematicRebellion = not optionalThematicRebellion
    local obj = getObjectFromGUID(adversaries.France)
    if obj ~= nil then
        obj.setVar("thematicRebellion", optionalThematicRebellion)
    end
    self.UI.setAttribute("slaveRebellion", "isOn", optionalThematicRebellion)
end
function toggleEngland6()
    optionalEngland6 = not optionalEngland6
    local obj = getObjectFromGUID(adversaries.England)
    if obj ~= nil then
        if optionalEngland6 then
            obj.setTable("difficulty", {[0] = 1, 3, 4, 6, 7, 9, 11})
        else
            obj.setTable("difficulty", {[0] = 1, 3, 4, 6, 7, 9, 10})
        end
        updateDifficulty()
    end
    self.UI.setAttribute("england6", "isOn", optionalEngland6)
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
function getXml(updateFunctions)
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

function addExpansionToggle(value)
    return matchRecurse("expansionsRow", function (t)
        table.insert(t.children[1].children[1].children, {
            tag="Toggle",
            value=value,
            attributes={id = value, onValueChanged = "toggleExpansion"},
            children={},
        })
        local count = #t.children[1].children[1].children
        t.attributes["preferredHeight"] = math.floor((count + 1) / 2) * 60
    end)
end
function addEventToggle(value)
    return matchRecurse("events", function (t)
        table.insert(t.children[1].children[1].children, {
            tag="Toggle",
            value=value.." Events",
            attributes={id = value.." Events", onValueChanged = "toggleEvents"},
            children={},
        })
        local count = #t.children[1].children[1].children
        t.attributes["preferredHeight"] = math.floor((count + 1) / 2) * 60
    end)
end
function removeToggle(id, value)
    return matchRecurse(id, function (t)
        for i,child in pairs(t.children[1].children[1].children) do
            if child.value == value then
                table.remove(t.children[1].children[1].children, i)
                break
            end
        end
        local count = #t.children[1].children[1].children
        t.attributes["preferredHeight"] = math.floor((count + 1) / 2) * 60
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
    local config = {boards = {}, spirits = {}, expansions = {"Branch & Claw", "Jagged Earth"}, events = {}, broadcast = ""}
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

    -- 2/3 chance to get scenario
    local useScenario = math.random(1, 3)
    if useScenario == 1 then
        local scenario = math.random(1, numScenarios)
        config.scenario = indexTable(scenarios, scenario)
    else
        math.random(0,0)
    end

    -- Make extra board more likely on higher tier
    config.variant = {}
    local extraBoard = math.random(-2, 1)
    if tier == 1 then
        config.variant.extraBoard = false
    elseif tier == 2 then
        config.variant.extraBoard = extraBoard >= 0
    elseif tier == 3 then
        config.variant.extraBoard = true
    end

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

    local events = math.random(1, 4)
    if events == 1 or events >= 3 then
        table.insert(config.events, "Branch & Claw")
    end
    if events == 2 or events >= 3 then
        table.insert(config.events, "Jagged Earth")
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
            math.random(0,0)
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
    local extraBoardRandom = nil
    if config.variant.extraBoard then
        -- make sure the extra board added is always the same one the next player would use
        math.random(0,0)
        math.random(0,0)
        if numPlayers > 5 then
            boards = {A2 = false, B2 = false, C2 = false, D2 = false, E2 = false, F2 = false}
            table.insert(config.boards, findBoard(0))
        else
            table.insert(config.boards, findBoard(numPlayers))
        end
        extraBoardRandom = config.boards[numBoards]
    end

    -- DO NOT put any more math.random calls below this block of code
    -- Change up the order of boards so the extra board isn't always last
    local function shuffle(tbl)
        for i = #tbl, 2, -1 do
            local j = math.random(i)
            tbl[i], tbl[j] = tbl[j], tbl[i]
        end
    end
    shuffle(config.boards)
    if config.variant.extraBoard then
        for i, board in pairs(config.boards) do
            if board == extraBoardRandom then
                config.variant.extraBoardRandom = i
                break
            end
        end
    end

    -- Makes sure difficulty is in acceptable range for the tier of challenge
    local difficulty = difficultyCheck(config)
    if tier == 1 then
        while difficulty > 8 do
            if config.adversaryLevel > 0 then
                config.adversaryLevel = leadingAdversaryLevel % config.adversaryLevel
            end
            if config.adversaryLevel2 > 0 then
                config.adversaryLevel2 = supportingAdversaryLevel % config.adversaryLevel2
            end
            difficulty = difficultyCheck(config)
            if config.adversaryLevel == 0 and config.adversaryLevel2 == 0 then
                -- can't go any lower so we just have to take it
                break
            end
        end
    elseif tier == 2 then
        local adversaryLevelMax = 6
        local adversaryLevelMin = prevTierConfig.adversaryLevel
        local adversaryLevel2Max = 6
        local adversaryLevel2Min = prevTierConfig.adversaryLevel2
        while difficulty <= 8 or difficulty > 16 do
            if difficulty <= 8 then
                if config.adversaryLevel > adversaryLevelMin then
                    adversaryLevelMin = config.adversaryLevel
                end
                if config.adversaryLevel2 > adversaryLevel2Min then
                    adversaryLevel2Min = config.adversaryLevel2
                end
                if config.adversaryLevel < adversaryLevelMax then
                    local leadingDiff = adversaryLevelMax - config.adversaryLevel
                    config.adversaryLevel = leadingAdversaryLevel % leadingDiff + config.adversaryLevel + 1
                end
                if config.adversaryLevel2 < adversaryLevel2Max then
                    local supportingDiff = adversaryLevel2Max - config.adversaryLevel2
                    config.adversaryLevel2 = supportingAdversaryLevel % supportingDiff + config.adversaryLevel2 + 1
                end
            else
                -- difficulty > 16
                if config.adversaryLevel < adversaryLevelMax then
                    adversaryLevelMax = config.adversaryLevel
                end
                if config.adversaryLevel2 < adversaryLevel2Max then
                    adversaryLevel2Max = config.adversaryLevel2
                end
                if config.adversaryLevel > adversaryLevelMin then
                    local leadingDiff = config.adversaryLevel - adversaryLevelMin
                    config.adversaryLevel = leadingAdversaryLevel % leadingDiff + adversaryLevelMin
                end
                if config.adversaryLevel2 > adversaryLevel2Min then
                    local leadingDiff = config.adversaryLevel2 - adversaryLevel2Min
                    config.adversaryLevel2 = supportingAdversaryLevel % leadingDiff + adversaryLevel2Min
                end
            end
            difficulty = difficultyCheck(config)
        end
    elseif tier == 3 then
        while difficulty <= 16 do
            if config.adversaryLevel < 6 then
                local leadingDiff = 6 - config.adversaryLevel
                config.adversaryLevel = leadingAdversaryLevel % leadingDiff + config.adversaryLevel + 1
            end
            if config.adversaryLevel2 < 6 then
                local supportingDiff = 6 - config.adversaryLevel2
                config.adversaryLevel2 = supportingAdversaryLevel % supportingDiff + config.adversaryLevel2 + 1
            end
            difficulty = difficultyCheck(config)
            if config.adversaryLevel == 6 and config.adversaryLevel2 == 6 then
                -- can't go any higher so we just have to take it
                break
            end
        end
        -- Tier 2 could have raised adversary levels from starting point,
        -- so we should make sure that Tier 3 doesn't lower adversary levels
        if config.adversaryLevel < prevTierConfig.adversaryLevel then
            config.adversaryLevel = prevTierConfig.adversaryLevel
        end
        if config.adversaryLevel2 < prevTierConfig.adversaryLevel2 then
            config.adversaryLevel2 = prevTierConfig.adversaryLevel2
        end
    end

    math.randomseed(os.time())
    return config
end
function setWeeklyChallengeUI(config)
    difficulty = difficultyCheck(config)
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

function togglePlaytestExpansion(_, selected, id)
    playtestExpansion = selected
    getXml{updateDropdownSelection(id, selected)}
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
