difficulty=0
setupBlightTokens=1
blightTokens=-1

hasBroadcast = true

function Broadcast(params)
    return "Blitz - Remember, Invaders get an additional set of Actions at the end of Setup"
end

modifyCostPriority = 10
function modifyCost(params)
    if Global.getVar("gameStarted") and Global.getVar("scenarioCard") ~= nil and Global.getVar("scenarioCard").guid == self.guid then
        for guid,cost in pairs(params.costs) do
            local card = getObjectFromGUID(guid)
            if (card.hasTag("Fast") and not card.hasTag("Temporary Slow")) or card.hasTag("Temporary Fast") then
                params.costs[guid] = cost-1
            end
        end
    end
    return params.costs
end
