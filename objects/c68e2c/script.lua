function onLoad()
    Global.call("setupPlayerArea", {
        obj = self,
        elementBags = {
            getObjectFromGUID("3c232d"),
            getObjectFromGUID("c76e95"),
            getObjectFromGUID("7d4eec"),
            getObjectFromGUID("e5f502"),
            getObjectFromGUID("f9baa1"),
            getObjectFromGUID("5d8ff7"),
            getObjectFromGUID("b15155"),
            getObjectFromGUID("8c701f"),
        },
        zone = getObjectFromGUID("9fc5a4")
    })
end