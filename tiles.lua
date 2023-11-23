-- ms/tiles.lua
local S = minetest.get_translator("ms")
local T = minetest.get_translator("default")

local fence_collision_extra = minetest.settings:get_bool("enable_fence_tall") and 3/8 or 0

local materials = {
    {"desert_sandstone", "Desert Sandstone"},
    {"desert_stone", "Desert Stone"},
    {"obsidian", "Obsidian"},
    {"sandstone", "Sandstone"},
    {"silver_sandstone", "Silver Sandstone"},
    {"stone", "Stone"},
}

for i = 1, #materials do
    local name, desc = unpack(materials[i])

    minetest.register_node(
        ":default:" .. name .. "_tiles",
        {
            description = S("@1 Tiles", T(desc)),
            groups = {cracky = 2},
            is_ground_content = false,
            paramtype2 = "facedir",
            sounds = default.node_sound_stone_defaults(),
            tiles = {"ms_" .. name .. "_tiles.png"}
        }
    )

    minetest.register_craft({
        output = "default:" .. name .. "_tiles 4",
        recipe = {
            {"default:" .. name .. "_brick", "default:" .. name .. "_brick"},
            {"default:" .. name .. "_brick", "default:" .. name .. "_brick"},
        }
    })
end
