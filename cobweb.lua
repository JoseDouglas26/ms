-- ms/cobweb.lua
local S = minetest.get_translator("ms")

local function on_dig(pos, node, digger)
    local item = digger:get_wielded_item()
    local inv = digger:get_inventory()

    if item:get_name() == "default:shears" then
        if inv:room_for_item("main", node.name) then
            inv:add_item("main", node.name)
            minetest.remove_node(pos)
        else
            minetest.remove_node(pos)
            minetest.add_item(pos, node.name)
        end
    elseif minetest.get_item_group(item:get_name(), "sword") == 1 then
        local num_drop = math.random(1, 3)
        inv:add_item("main", "farming:string " .. tostring(num_drop))
        minetest.remove_node(pos)

        if not minetest.is_creative_enabled(digger:get_player_name()) then
            item:add_wear()
        end
    else
        minetest.remove_node(pos)
    end

    return true
end

minetest.register_node(
    ":default:cobweb",
    {
        description = S("Cobweb"),
        drawtype = "plantlike",
        groups = {
            choppy = 1,
            cracky = 1,
            crumbly = 1,
            flammable = 2,
            oddly_breakable_by_hand = 1,
            snappy = 2
        },
        inventory_image = "ms_cobweb.png",
        move_resistance = 7,
        on_dig = on_dig,
        paramtype = "light",
        sunlight_propagates = true,
        tiles = {"ms_cobweb.png"},
        walkable = false,
        wield_image = "ms_cobweb.png"
    }
)

minetest.register_decoration({
    biomes = {
        "coniferous_forest_under",
        "deciduous_forest_under",
        "desert_under",
        "grassland_under",
        "rainforest_under",
        "sandstone_desert_under",
        "savanna_under",
        "snowy_grassland_under",
        "taiga_under",
        "tundra_under",
    },
    deco_type = "simple",
    decoration = "default:cobweb",
    fill_ratio = 0.075,
    flags = {"all_ceilings", "all_floors"},
    height = 1,
    noise_params = {
        octaves = 2,
        offset = 0.1,
        persistence = 0.55,
        scale = 0.23,
        seed = 2608,
        spread = {x = 5, y = 5, z = 5},
    },
    place_on = {"default:cobble", "default:desert_cobble", "default:stone", "default:mossycobble"},
    sidelen = 8,
    y_max = -10,
    y_min = -1500,
})
