function tryObjectEnter(enter_object)
    Global.call("cleanupObject", {obj=enter_object, fear=true, color=enter_object.getVar("color"), reason="Destroying"})
    return false
end
