-- ms/light_blue.lua
local S = minetest.get_translator("ms")

minetest.register_craftitem(
    ":dye:light_blue",
    {
        description = S("@1 Dye", S("Light Blue")),
        groups = {dye = 1, color_light_blue = 1},
        inventory_image = "ms_dye_light_blue.png",
        wield_image = "ms_dye_light_blue.png"
    }
)

minetest.register_craft({
    output = "dye:light_blue 2",
    recipe = {"dye:blue", "dye:white"},
    type = "shapeless"
})

minetest.register_craft({
    output = "dye:light_blue 4",
    recipe = {"group:flower,color_light_blue"},
    type = "shapeless"
})

minetest.register_node(
    ":wool:light_blue",
    {
        color = "#33ABF9",
        description = S("@1 Wool", S("Light Blue")),
        groups = {
            choppy = 2,
            color_light_blue = 1,
            flammable = 3,
            oddly_breakable_by_hand = 2,
            snappy = 2,
            wool = 1
        },
        is_ground_content = false,
        sounds = default.node_sound_wool_defaults(),
        tiles = {"wool_white.png"}
    }
)

minetest.register_craft({
    output = "wool:light_blue",
    recipe = {"group:dye,color_light_blue", "group:wool"},
    type = "shapeless"
})

minetest.register_node(
    ":carpets:light_blue",
    {
        color = "#33ABF9",
        description = S("@1 Carpet", S("Light Blue")),
        drawtype = "nodebox",
        groups = ms.carpets_groups,
        node_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.375, 0.5}},
        on_flood = ms.carpets_on_flood,
        paramtype = "light",
        sounds = default.node_sound_wool_defaults(),
        sunlight_propagates = true,
        tiles = {"wool_white.png"},
        wield_image = "wool_white.png"
    }
)

ms.carpets_craft_recipes("light_blue")
