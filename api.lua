-- ms/api.lua
ms = {}

-- Sounds
---------------------------------------------------------------------------------------------------
function default.node_sound_wool_defaults(table)
    table = table or {}
    table.dig = table.dig or
        {name = "ms_wool_dig", pitch = 1.35}
    table.dug = table.dug or
        {name = "ms_wool_dug"}
    table.footstep = table.footstep or
        {name = "ms_wool_footstep", gain = 0.35, pitch = 1.35}
    table.place = table.place or
        {name = "ms_wool_place", pitch = 1.35}
    return table
end
---------------------------------------------------------------------------------------------------
-- Colors
---------------------------------------------------------------------------------------------------
local code_by_color = {
    ["black"] = "#202020",
    ["blue"] = "#003173",
    ["brown"] = "#964B00",
    ["cyan"] = "#00A3AB",
    ["dark_green"] = "#1D6000",
    ["dark_grey"] = "#5A5A5A",
    ["green"] = "#69D923",
    ["grey"] = "#808080",
    ["light_blue"] = "#33ABF9",
    ["magenta"] = "#E0048B",
    ["orange"] = "#D95617",
    ["pink"] = "#FF8787",
    ["red"] = "#C51818",
    ["violet"] = "#6000B1",
    ["white"] = "#FFFFFF",
    ["yellow"] = "#FFFF00"
}

local dyes = dye.dyes
ms.colors = table.copy(dyes)

table.insert(ms.colors, 9, {"light_blue", "Light Blue"})

for i = 1, #ms.colors do
    table.insert(ms.colors[i], code_by_color[ms.colors[i][1]])
end

function ms.get_code(color)
    return code_by_color[color]
end
---------------------------------------------------------------------------------------------------
-- Carpets
---------------------------------------------------------------------------------------------------
ms.carpets_groups = {
    attached_node = 3,
    carpet = 1,
    flammable = 4,
    oddly_breakable_by_hand = 2,
    snappy = 3
}

function ms.carpets_on_flood(pos, oldnode, newnode)
    local node_def = minetest.registered_items[newnode.name]

    if (node_def and node_def.groups and node_def.groups.igniter and node_def.groups.igniter > 0) then
        minetest.sound_play("default_cool_lava", {pos = pos, max_hear_distance = 8, gain = 0.05}, true)
    else
        minetest.add_item(pos, ItemStack(oldnode.name))
    end

    return false
end

function ms.carpets_craft_recipes(color)
    minetest.register_craft({
        output = "carpets:" .. color .. " 6",
        recipe = {{":wool:" .. color, "wool:" .. color}}
    })

    minetest.register_craft({
        output = "carpets:" .. color,
        recipe = {"group:carpet", "group:dye,color_" .. color},
        type = "shapeless"
    })

    minetest.register_craft({
        output = "wool:" .. color,
        recipe = {
            {"carpets:" .. color, "carpets:" .. color},
            {"carpets:" .. color, "carpets:" .. color}
        }
    })

    minetest.register_craft({
        burntime = 9,
        recipe = "carpets:" .. color,
        type = "fuel",
    })
end
---------------------------------------------------------------------------------------------------
-- Renames and redefinitions
---------------------------------------------------------------------------------------------------
local renames = {
    ["desert_stonebrick"] = "desert_stone_brick",
    ["obsidianbrick"] = "obsidian_brick",
    ["sandstonebrick"] = "sandstone_brick",
    ["stonebrick"] = "stone_brick",
}

for name, defs in pairs(minetest.registered_nodes) do
    if name:find("stonebrick") or name:find("obsidianbrick") then
        minetest.clear_craft({output = name})
        minetest.unregister_item(name)

        if name:find("default") then
            minetest.register_node(":default:" .. renames[name:sub(9)], defs)
        elseif name:find("stairs:stair") then
            if not (name:find("inner") or name:find("outer")) then
                minetest.register_node(":stairs:stair_" .. renames[name:sub(14)], defs)
            else
                if name:find("inner") then
                    minetest.register_node(":stairs:stair_inner_" .. renames[name:sub(20)], defs)
                elseif name:find("outer") then
                    minetest.register_node(":stairs:stair_outer_" .. renames[name:sub(20)], defs)
                end
            end
        elseif name:find("stairs:slab") then
            minetest.register_node(":stairs:slab_" .. renames[name:sub(13)], defs)
        end
    end
end

local function register_missing_crafts(block)
    local material = block:sub(1, -7)

    minetest.register_craft({
        output = block .. " 4",
        recipe = {
            {material, material},
            {material, material}
        }
    })

    material = block:sub(9)

    minetest.register_craft({
        output = "stairs:stair_" .. material .. " 8",
        recipe = {
            {"", "", block},
            {"", block, block},
            {block, block, block}
        }
    })

    minetest.register_craft({
        output = "stairs:stair_inner_" .. material .. " 7",
        recipe = {
            {"", block, ""},
            {block, "", block},
            {block, block, block}
        }
    })

    minetest.register_craft({
        output = "stairs:stair_outer_" .. material .. " 6",
        recipe = {
            {"", block, ""},
            {block, block, block}
        }
    })

    minetest.register_craft({
        output = "stairs:slab_" .. material .. " 6",
        recipe = {
            {block, block, block}
        }
    })
end

local materials = {
    "default:desert_stone_brick",
    "default:obsidian_brick",
    "default:sandstone_brick",
    "default:stone_brick",
}

for i = 1, #materials do
    register_missing_crafts(materials[i])
end
---------------------------------------------------------------------------------------------------
-- Walls
---------------------------------------------------------------------------------------------------
function ms.register_wall_connection(name, desc, fence_collision_extra, tiles)
    minetest.register_node(
        ":walls:" .. name .. "_connection_x",
        {
            collision_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.1875, 0.5, 0.375 + fence_collision_extra, 0.1875}
            },
            connects_to = {"group:wall"},
            description = desc,
            drawtype = "nodebox",
            drop = "walls:" .. name,
            groups = {cracky = 2, not_in_creative_inventory = 1, wall = 1, wall_connection = 1},
            node_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.1875, 0.5, 0.375, 0.1875}
            },
            paramtype = "light",
            sounds = default.node_sound_stone_defaults(),
            sunlight_propagates = true,
            tiles = tiles
        }
    )

    minetest.register_node(
        ":walls:" .. name .. "_connection_z",
        {
            collision_box = {
                type = "fixed",
                fixed = {-0.1875, -0.5, -0.5, 0.1875, 0.375 + fence_collision_extra, 0.5}
            },
            connects_to = {"group:wall"},
            description = desc,
            drawtype = "nodebox",
            drop = "walls:" .. name,
            groups = {cracky = 2, not_in_creative_inventory = 1, wall = 1, wall_connection = 1},
            node_box = {
                type = "fixed",
                fixed = {-0.1875, -0.5, -0.5, 0.1875, 0.375, 0.5}
            },
            paramtype = "light",
            sounds = default.node_sound_stone_defaults(),
            sunlight_propagates = true,
            tiles = tiles
        }
    )
end

local function action(pos, node)
    local material = node.name:sub(7)
    local neig_xmin = minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z})
    local neig_xmax = minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z})
    local neig_zmin = minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1})
    local neig_zmax = minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1})

    if not node.name:find("_connection_") then
        if (minetest.get_item_group(neig_xmin.name, "wall") == 1 or
        minetest.get_item_group(neig_xmin.name, "wall_connection") == 1) and
        (minetest.get_item_group(neig_xmax.name, "wall") == 1 or
        minetest.get_item_group(neig_xmax.name, "wall_connection") == 1) then
            if (minetest.get_item_group(neig_zmin.name, "wall") == 1 or
            minetest.get_item_group(neig_zmin.name, "wall_connection") == 1) or
            (minetest.get_item_group(neig_zmax.name, "wall") == 1 or
            minetest.get_item_group(neig_zmax.name, "wall_connection") == 1) then
                return
            end

            minetest.swap_node(pos, {name = "walls:" .. material .. "_connection_x"})
        end

        if (minetest.get_item_group(neig_zmin.name, "wall") == 1 or
        minetest.get_item_group(neig_zmin.name, "wall_connection") == 1) and
        (minetest.get_item_group(neig_zmax.name, "wall") == 1 or
        minetest.get_item_group(neig_zmax.name, "wall_connection") == 1) then
            if (minetest.get_item_group(neig_xmin.name, "wall") == 1 or
            minetest.get_item_group(neig_xmin.name, "wall_connection") == 1) or
            (minetest.get_item_group(neig_xmax.name, "wall") == 1 or
            minetest.get_item_group(neig_xmax.name, "wall_connection") == 1) then
                return
            end

            minetest.swap_node(pos, {name = "walls:" .. material .. "_connection_z"})
        end
    end
end

minetest.register_abm({
    action = action,
    chance = 1,
    interval = 0,
    nodenames = {"group:wall"}
})
---------------------------------------------------------------------------------------------------
