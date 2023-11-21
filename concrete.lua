-- ms/concrete.lua
local S = minetest.get_translator("ms")

local function on_place(itemstack, placer, pointed_thing)
    local position = minetest.get_pointed_thing_position(pointed_thing)
    local pointed_node = minetest.get_node(position)
    local color_name = itemstack:get_name():sub(10, -8)

    if pointed_node.name:find("water") then
        minetest.swap_node(position, {name = "concrete:" .. color_name})
    else
        minetest.set_node(pointed_thing.above, {name = itemstack:get_name()})
        minetest.check_for_falling(pointed_thing.above)
    end

    if not minetest.is_creative_enabled(placer:get_player_name()) then
        itemstack:take_item()
    end

    return itemstack
end

for i = 1, #ms.colors do
    local color_name, color_desc, color_code = unpack(ms.colors[i])

    minetest.register_node(
        ":concrete:" .. color_name,
        {
            color = color_code,
            description = S("@1 Concrete", S(color_desc)),
            groups = {concrete = 1, cracky = 2},
            is_ground_content = false,
            sounds = default.node_sound_stone_defaults(),
            tiles = {"ms_concrete.png"}
        }
    )

    minetest.register_node(
        ":concrete:" .. color_name .. "_powder",
        {
            color = color_code,
            description = S("@1 Powder", S("@1 Concrete", S(color_desc))),
            groups = {
                concrete_powder = 1,
                crumbly = 2,
                falling_node = 1,
                float = 1,
                oddly_breakable_by_hand = 2
            },
            is_ground_content = false,
            liquids_pointable = true,
            on_place = on_place,
            sounds = default.node_sound_sand_defaults(),
            tiles = {"ms_concrete_powder.png"}
        }
    )

    minetest.register_craft({
        output = "concrete:" .. color_name .. "_powder 8",
        recipe = {
            "group:sand",
            "group:sand",
            "group:sand",
            "group:sand",
            "default:gravel",
            "default:gravel",
            "default:gravel",
            "default:gravel",
            "group:dye,color_" .. color_name
        },
        type = "shapeless"
    })
end

local function action(pos, node)
    local neighbors = {
        minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}).name,
        minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}).name,
        minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name,
        minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name,
        minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}).name,
        minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}).name
    }

    local color_name = node.name:sub(10, -8)

    for i = 1, #neighbors do
        if neighbors[i]:find("water") then
            minetest.swap_node(pos, {name = "concrete:" .. color_name})
        end
    end
end

minetest.register_abm({
    action = action,
    chance = 1,
    interval = 0,
    neighbors = {"default:water_source", "default:water_flowing"},
    nodenames = {"group:concrete_powder"}
})
