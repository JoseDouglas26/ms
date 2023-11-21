-- ms/carpets.lua
local S = minetest.get_translator("ms")

for i = 1, #dye.dyes do
    local name, desc = unpack(dye.dyes[i])

    minetest.register_node(
        ":carpets:" .. name,
        {
            description = S("@1 Carpet", S(desc)),
            drawtype = "nodebox",
            floodable = true,
            groups = ms.carpets_groups,
            node_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.375, 0.5}},
            on_flood = ms.carpets_on_flood,
            paramtype = "light",
            sounds = default.node_sound_wool_defaults(),
            sunlight_propagates = true,
            tiles = {"wool_" .. name .. ".png"},
            wield_image = "wool_" .. name .. ".png"
        }
    )

    ms.carpets_craft_recipes(name)
end
