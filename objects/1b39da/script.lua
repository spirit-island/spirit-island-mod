difficulty=0
setupBlightTokens=1
blightTokens=-1

postSetup=true
postSetupComplete=false
hasBroadcast = true

function PostSetup()
    Global.setVar("fastDiscount", 1)
    postSetupComplete = true
end

function Broadcast(params)
    return "Blitz - Remember, Invaders get an additional set of Actions at the end of Setup"
end
