-- ms/walls.lua
local S = minetest.get_translator("ms")
local T = minetest.get_translator("default")

local fence_collision_extra = minetest.settings:get_bool("enable_fence_tall") and 3/8 or 0

local materials = {
    {"brick", "Brick Block"},
    {"desert_sandstone", "Desert Sandstone"},
    {"desert_sandstone_block", "Desert Sandstone Block"},
    {"desert_sandstone_brick", "Desert Sandstone Brick"},
    {"desert_stone", "Desert Stone"},
    {"desert_stone_block", "Desert Stone Block"},
    {"desert_stone_brick", "Desert Stone Brick"},
    {"obsidian", "Obsidian"},
    {"obsidian_block", "Obsidian Block"},
    {"obsidian_brick", "Obsidian Brick"},
    {"stone", "Stone"},
    {"stone_block", "Stone Block"},
    {"stone_brick", "Stone Brick"},
    {"sandstone", "Sandstone"},
    {"sandstone_block", "Sandstone Block"},
    {"sandstone_brick", "Sandstone Brick"},
    {"silver_sandstone", "Silver Sandstone"},
    {"silver_sandstone_block", "Silver Sandstone Block"},
    {"silver_sandstone_brick", "Silver Sandstone Brick"}
}

for i = 1, #materials do
    local name, desc = unpack(materials[i])

    walls.register(
        ":walls:" .. name,
        S("@1 Wall", T(desc)),
        "default_" .. name .. ".png",
        "default:" .. name,
        default.node_sound_stone_defaults()
    )

    ms.register_wall_connection(
        name,
        S("@1 Wall", T(desc)),
        fence_collision_extra,
        {"default_" .. name .. ".png"}
    )
end
