difficulty=4
postSetup = true
postSetupComplete = false

checkLossID = 0

function onLoad()
    if Global.getVar("gameStarted") then
        checkLossID = Wait.time(checkLoss, 5, -1)
    end
end

function PostSetup()
    checkLossID = Wait.time(checkLoss, 5, -1)
    postSetupComplete = true
end

function checkLoss()
    local dahan = #getObjectsWithTag("Dahan")
    if dahan < 2 * Global.getVar("numBoards") then
        broadcastToAll("Invaders wins via Scenario Additional Loss Condition!", "Red")
        Wait.stop(checkLossID)
    end
end