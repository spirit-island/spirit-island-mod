difficulty=4

customVictory = true
automatedVictoryDefeat = true

checkLossID = 0

function AutomatedVictoryDefeat()
    if checkLossID ~= nil then
        Wait.stop(checkLossID)
        checkLossID = nil
    end
    checkLossID = Wait.time(checkLoss, 5, -1)
end
function checkLoss()
    local dahan = #getObjectsWithTag("Dahan")
    if dahan < 2 * Global.call("getMapCount", {norm = true, them = true}) then
        Wait.stop(checkLossID)
        Global.call("Defeat", {scenario = self.getName()})
    end
end
