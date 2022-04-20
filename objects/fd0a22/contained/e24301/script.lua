function tryObjectEnter(enter_object)
    Global.call("cleanupObject", {obj=enter_object, fear=true, reason="Destroying"})
    return false
end
