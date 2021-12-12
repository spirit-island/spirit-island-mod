difficulty=4
postSetup = true
postSetupComplete = false

checkLossID = 0

function onLoad()
    Color.Add("SoftYellow", Color.new(0.9,0.7,0.1))
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
    if dahan < 2 * Global.call("getMapCount", {norm = true, them = true}) then
        broadcastToAll("Invaders wins via Scenario Additional Loss Condition!", Color.SoftYellow)
        Wait.stop(checkLossID)
    end
end
