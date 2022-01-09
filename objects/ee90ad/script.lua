difficulty=4
postSetup = true
postSetupComplete = false
customVictory = true

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
    if dahan < 2 * Global.call("getMapCount", {norm = true, them = true}) then
        Wait.stop(checkLossID)
        Global.call("Defeat", {scenario = self.getName()})
    end
end
