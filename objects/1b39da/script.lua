difficulty=0
setupBlightTokens=1
blightTokens=-1
broadcast="Remember, Invaders get an additional set of Actions at the end of Setup - Blitz"

postSetup=true
postSetupComplete=false

function PostSetup()
    Global.setVar("fastDiscount", 1)
    postSetupComplete = true
end