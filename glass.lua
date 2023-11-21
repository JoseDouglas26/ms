-- ms/glass.lua
local S = minetest.get_translator("ms")

for i = 1, #ms.colors do
    local color_name, color_desc, color_code = unpack(ms.colors[i])

    minetest.register_node(
        ":default:glass_" .. color_name,
        {
            description = S("@1 Glass", S(color_desc)),
            drawtype = "glasslike_framed_optional",
            groups = {cracky = 3, oddly_breakable_by_hand = 3},
            paramtype = "light",
	        sounds = default.node_sound_glass_defaults(),
            sunlight_propagates = true,
            tiles = {
                "ms_stained_glass_" .. color_name .. ".png",
                "ms_stained_glass_detail_" .. color_name .. ".png"
            },
            use_texture_alpha = "blend",
        }
    )

    minetest.register_craft({
        output = "default:glass_" .. color_name .. " 8",
        recipe = {
            "default:glass",
            "default:glass",
            "default:glass",
            "default:glass",
            "default:glass",
            "default:glass",
            "default:glass",
            "default:glass",
            "group:dye,color_" .. color_name
        },
        type = "shapeless"
    })

    local glass = "default:glass_" .. color_name

    xpanes.register_pane(
        "pane_flat_" .. color_name,
        {
            description = S("@1 Pane", S("@1 Glass", S(color_desc))),
            groups = {snappy=2, cracky=3, oddly_breakable_by_hand=3},
            inventory_image = "ms_stained_glass_" .. color_name .. ".png",
            recipe = {
                {glass, glass, glass},
                {glass, glass, glass}
            },
            sounds = default.node_sound_glass_defaults(),
            textures = {
                "ms_stained_glass_" .. color_name .. ".png",
                "",
                "xpanes_edge.png^[colorize:" .. color_code .. ":191"
            },
            wield_image = "ms_stained_glass_" .. color_name .. ".png",
            use_texture_alpha = "blend"
        }
    )
end
