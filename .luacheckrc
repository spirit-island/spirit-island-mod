-- This is a list of globals defined by Tabletop Simulator (currently incomplete).
read_globals = {
    "Color",
    "Global",
    "Hands",
    "JSON",
    "Notes",
    "Physics",
    "Player",
    "Table",
    "UI",
    "Vector",
    "Wait",
    "addContextMenuItem",
    "addHotkey",
    "broadcastToAll",
    "clearHotkeys",
    "destroyObject",
    "getObjects",
    "getObjectFromGUID",
    "getObjectsWithAllTags",
    "getObjectsWithAnyTags",
    "getObjectsWithTag",
    "group",
    "printToAll",
    "setLookingForPlayers",
    "spawnObject",
    "spawnObjectData",
    "spawnObjectJSON",
    "startLuaCoroutine",
}
-- Additionally `self` and `Hands` have mutable fields.
files["objects/**/*.lua"] = {
    globals = {"self", "Hands"},
}

-- Don't have a maximum line length.
max_line_length = false

-- Ignores.
allow_defined_top = true
ignore = {
    "131", -- unused global variable, we should annotate the ones we expect
    "542", -- empty if branch  (usually has a comment)
    "212", -- unused argument; name is used as documentation
}
