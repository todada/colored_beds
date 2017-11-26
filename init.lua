-- unified dyes thingies

local modpath = minetest.get_modpath("colored_beds")
local creative_mode = minetest.settings:get_bool("creative_mode")

colored_beds = {}


-- Load files
dofile(modpath .. "/common.lua")
dofile(modpath .. "/beds_lib.lua")
dofile(modpath .. "/beds.lua")

print("[Colored beds] Loaded!")

