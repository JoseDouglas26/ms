-- ms/wire.lua
local S = minetest.get_translator("ms")

minetest.register_node(
    ":default:wire",
    {
        collision_box = {type = "fixed", fixed = {0, 0, 0, 0, 0, 0}},
        description = S("Wire"),
        drawtype = "nodebox",
        drop = "farming:string",
        groups = {flammable = 4, not_in_creative_inventory = 1, oddly_breakable_by_hand = 3, snappy = 3},
        node_box = {type = "fixed", fixed = {-0.03125, -0.5, -0.5, 0.03125, -0.4999, 0.5}},
        paramtype = "light",
        paramtype2 = "facedir",
        selection_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}},
        sunlight_propagates = true,
        tiles = {"ms_wire.png"},
        use_texture_alpha = "blend",
        walkable = true
    }
)

minetest.register_node(
    ":default:wire_connected",
    {
        collision_box = {type = "fixed", fixed = {0, 0, 0, 0, 0, 0}},
        connect_sides = {"front", "back", "left", "right"},
        connects_to = {"default:wire", "default:wire_connected"},
        description = S("Wire"),
        drawtype = "nodebox",
        drop = "farming:string",
        groups = {flammable = 4, not_in_creative_inventory = 1, oddly_breakable_by_hand = 3, snappy = 3},
        node_box = {
            type = "connected",
            fixed = {-0.03125, -0.5, -0.03125, 0.03125, -0.4999, 0.03125},
            connect_left = {-0.5, -0.5, -0.03125, 0.03125, -0.4999, 0.03125},
            connect_right = {0.03125, -0.5, -0.03125, 0.5, -0.4999, 0.03125},
            connect_front = {-0.03125, -0.5, -0.5, 0.03125, -0.4999, 0.03125},
            connect_back = {-0.03125, -0.5, 0.03125, 0.03125, -0.4999, 0.5},
        },
        paramtype = "light",
        paramtype2 = "facedir",
        selection_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}},
        sunlight_propagates = true,
        tiles = {"ms_wire_connected.png"},
        use_texture_alpha = "blend",
        walkable = true
    }
)

local function on_place(itemstack, placer, pointed_thing)
    local lookdir = placer:get_look_dir()
    local fdir = minetest.dir_to_facedir(lookdir)

    if fdir == 0 then
        fdir = 3
    else
        fdir = fdir - 1
    end

    minetest.swap_node(pointed_thing.above, {name = "default:wire", param2 = fdir})

    if not minetest.is_creative_enabled(placer:get_player_name()) then
        itemstack:take_item()
    end

    return itemstack
end

minetest.override_item("farming:string", {on_place = on_place})

local function action(pos, node)
    local neighbors = {}

    table.insert(neighbors, minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
    table.insert(neighbors, minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
    table.insert(neighbors, minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
    table.insert(neighbors, minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))

    if node.name == "default:wire" then
        for _, neighbor in ipairs(neighbors) do
            if neighbor.name ~= "air" and
               (neighbor.name == "default:wire" or
                neighbor.name == "default:wire_connected") then
                    minetest.swap_node(pos, {name = "default:wire_connected", param2 = node.param2})
            end
        end
    elseif node.name == "default:wire_connected" then
        if neighbors[1].name == "air" and neighbors[2].name == "air" and
            neighbors[3].name == "air" and neighbors[4].name == "air" then
                minetest.swap_node(pos, {name = "default:wire", param2 = node.param2})
        end
    end
end

minetest.register_abm({
    action = action,
    chance = 1,
    interval = 0,
    nodenames = {"default:wire", "default:wire_connected"}
})
