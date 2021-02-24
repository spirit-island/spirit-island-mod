-- This is a list of globals defined by Tabletop Simulator (currently incomplete).
read_globals = {
    "Color",
    "Global",
    "JSON",
    "Notes",
    "Physics",
    "Player",
    "Table",
    "UI",
    "Vector",
    "Wait",
    "addHotkey",
    "broadcastToAll",
    "clearHotkeys",
    "destroyObject",
    "getAllObjects",
    "getObjectFromGUID",
    "getObjectsWithTag",
    "group",
    "printToAll",
    "setLookingForPlayers",
    "startLuaCoroutine",
}
-- Additionally `self` is defined for object scripts, and it has mutable fields.
files["objects/**/*.lua"].globals = {"self"}


-- Don't have a maximum line length.
max_line_length = false

-- Ignores.

-- Allow implicitly defining globals in root modules.
files['script.lua'].allow_defined_top = true
files['objects/**/*.lua'].allow_defined_top = true

ignore = {
    "131", -- unused global variable, we should annotate the ones we expect
    "542", -- empty if branch  (usually has a comment)
    "212", -- unused argument; name is used as documentation
    -- To be triaged
    "412",
    "411",
    "421",
}
