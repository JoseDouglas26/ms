-- ms/food.lua
local S = minetest.get_translator("ms")
---------------------------------------------------------------------------------------------------
-- Default --
---------------------------------------------------------------------------------------------------
minetest.register_craftitem(
    ":default:bowl",
    {
        description = S("Bowl"),
        inventory_image = "ms_bowl.png",
        wield_image = "ms_bowl.png"
    }
)

minetest.register_craft({
    output = "default:bowl",
    recipe = {
        {"group:wood", "", "group:wood"},
        {"", "group:wood", ""}
    },
    type = "shaped"
})

minetest.register_craft({
    burntime = 12,
    recipe = "default:bowl",
    type = "fuel"
})

minetest.register_craftitem(
    ":default:sugar",
    {
        description = S("Sugar"),
        inventory_image = "ms_sugar.png",
        wield_image = "ms_sugar.png"
    }
)

minetest.register_node(
    ":default:sugar_cane",
    {
        after_dig_node = function(pos, node, metadata, digger)
            default.dig_up(pos, node, digger)
        end,
        description = S("Sugar Cane"),
        drawtype = "plantlike",
        groups = {snappy = 3, flammable = 2},
        inventory_image = "ms_sugar_cane.png",
        paramtype = "light",
        paramtype2 = "meshoptions",
        place_param2 = 3,
        selection_box = {type = "fixed", fixed = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}},
        sounds = default.node_sound_leaves_defaults(),
        sunlight_propagates = true,
        tiles = {"ms_sugar_cane.png"},
        walkable = false,
        wield_image = "ms_sugar_cane.png"
    }
)

minetest.register_craft({
    output = "default:sugar",
    recipe = {"default:sugar_cane"},
    type = "shapeless"
})
---------------------------------------------------------------------------------------------------
-- Farming --
---------------------------------------------------------------------------------------------------
farming.register_plant(
    ":farming:beetroot",
    {
        description = S("Beetroot Seed"),
        fertility = {"grassland", "rainforest"},
        groups = {flammable = 4},
        harvest_description = S("Beetroot"),
        inventory_image = "farming_beetroot_seed.png",
        maxlight = default.LIGHT_MAX,
        minlight = 10,
        paramtype2 = "meshoptions",
        place_param2 = 3,
        steps = 6,
    }
)

minetest.override_item(
    "farming:beetroot",
    {
        on_use = minetest.item_eat(1)
    }
)

minetest.register_node(
    ":farming:beetroot_wild",
    {
        buildable_to = true,
        description = S("Wild Beetroot"),
        drawtype = "plantlike",
        drop = "ms:seed_beetroot",
        groups = {attached_node = 1, flammable = 4, snappy = 3},
        inventory_image = "ms_beetroot_wild.png",
        paramtype = "light",
        paramtype2 = "meshoptions",
        place_param2 = 2,
        sounds = default.node_sound_leaves_defaults(),
        sunlight_propagates = true,
        tiles = {"ms_beetroot_wild.png"},
        walkable = false,
        waving = 1,
        wield_image = "ms_beetroot_wild.png"
    }
)
---------------------------------------------------------------------------------------------------
-- Food --
---------------------------------------------------------------------------------------------------
minetest.register_craftitem(
    ":food:pie_apple_raw",
    {
        description = S("Raw Apple Pie"),
        inventory_image = "ms_food_apple_pie.png^[colorize:#FFFFFF:63",
        wield_image = "ms_food_apple_pie.png^[colorize:#FFFFFF:63"
    }
)

minetest.register_craft({
    output = "food:pie_apple_raw",
    recipe = {
        "default:apple",
        "farming:flour",
        "default:sugar",
    },
    type = "shapeless"
})

minetest.register_craftitem(
    ":food:pie_apple",
    {
        description = S("Apple Pie"),
        inventory_image = "ms_food_apple_pie.png",
        on_use = minetest.item_eat(5),
        wield_image = "ms_food_apple_pie.png"
    }
)

minetest.register_craft({
    cooktime = 15,
    output = "food:pie_apple",
    recipe = "food:pie_apple_raw",
    type = "cooking"
})

minetest.register_craftitem(
    ":food:pie_berries_raw",
    {
        description = S("Raw Blueberries Pie"),
        inventory_image = "ms_food_berries_pie.png^[colorize:#FFFFFF:63",
        wield_image = "ms_food_berries_pie.png^[colorize:#FFFFFF:63"
    }
)

minetest.register_craft({
    output = "food:pie_berries_raw",
    recipe = {
        "default:blueberries",
        "farming:flour",
        "default:sugar",
    },
    type = "shapeless"
})

minetest.register_craftitem(
    ":food:pie_berries",
    {
        description = S("Blueberries Pie"),
        inventory_image = "ms_food_berries_pie.png",
        on_use = minetest.item_eat(5),
        wield_image = "ms_food_berries_pie.png"
    }
)

minetest.register_craft({
    cooktime = 15,
    output = "food:pie_berries",
    recipe = "food:pie_berries_raw",
    type = "cooking"
})

minetest.register_craftitem(
    ":food:soup_beetroot",
    {
        description = S("Beetroot Soup"),
        inventory_image = "ms_food_beetroot_soup.png",
        on_use = minetest.item_eat(5, ItemStack("default:bowl")),
        wield_image = "ms_food_beetroot_soup.png"
    }
)

minetest.register_craft({
    output = "food:soup_beetroot",
    recipe = {
        {"farming:beetroot", "farming:beetroot", "farming:beetroot"},
        {"farming:beetroot", "farming:beetroot", "farming:beetroot"},
        {"", "default:bowl", ""}
    },
    type = "shaped"
})

minetest.register_craftitem(
    ":food:soup_mushroom",
    {
        description = S("Mushroom Soup"),
        inventory_image = "ms_food_mushroom_soup.png",
        on_use = minetest.item_eat(5, ItemStack("default:bowl")),
        wield_image = "ms_food_mushroom_soup.png"
    }
)

minetest.register_craft({
    output = "food:soup_mushroom",
    recipe = {
        "default:bowl",
        "flowers:mushroom_brown",
        "flowers:mushroom_red",
    },
    type = "shapeless"
})
---------------------------------------------------------------------------------------------------
-- Decoration Section
---------------------------------------------------------------------------------------------------
local function register_mgv6_decorations()
    minetest.register_decoration({
        deco_type = "simple",
        decoration = "default:sugar_cane",
		height = 2,
		height_max = 4,
        name = "default:sugar_cane",
		noise_params = {
			offset = -0.3,
			scale = 0.7,
			spread = {x = 100, y = 100, z = 100},
			seed = 354,
			octaves = 3,
			persist = 0.7
		},
        num_spawn_by = 1,
        place_on = {"default:dirt_with_grass"},
		sidelen = 16,
        spawn_by = "default:water_source",
		y_max = 1,
		y_min = 1,
	})

    minetest.register_decoration({
        biomes = {"grassland", "rainforest"},
        deco_type = "simple",
        decoration = "farming:beetroot_wild",
        name = "farming:beetroot_wild",
        noise_params = {
            offset = -0.12,
            scale = 0.45,
            spread = {x = 85, y = 85, z = 85},
            seed = 95,
            octaves = 1,
            persist = 0.57
        },
        place_on = {"default:dirt_with_grass", "default:dirt_with_rainforest_litter"},
        sidelen = 16,
        y_max = 6005,
        y_min = 5,
    })
end

local function register_decorations()
    minetest.register_decoration({
        biomes = {"rainforest_swamp"},
        deco_type = "schematic",
        name = "default:sugar_cane_on_dirt",
        noise_params = {
			offset = -0.3,
			scale = 0.7,
			spread = {x = 200, y = 200, z = 200},
			seed = 354,
			octaves = 3,
			persist = 0.7
		},
		place_on = {"default:dirt"},
        schematic = minetest.get_modpath("ms") .. "/schematics/sugar_cane_on_dirt.mts",
		sidelen = 16,
		y_max = 0,
		y_min = 0,
    })

    minetest.register_decoration({
        biomes = {"savanna_shore"},
        deco_type = "schematic",
		name = "default:sugar_cane_on_dry_dirt",
        noise_params = {
			offset = -0.3,
			scale = 0.7,
			spread = {x = 200, y = 200, z = 200},
			seed = 354,
			octaves = 3,
			persist = 0.7
		},
		place_on = {"default:dry_dirt"},
		schematic = minetest.get_modpath("ms") .. "/schematics/sugar_cane_on_dry_dirt.mts",
		sidelen = 16,
		y_max = 0,
		y_min = 0,
	})

    minetest.register_decoration({
        biomes = {"grassland", "rainforest"},
        deco_type = "simple",
        decoration = "farming:beetroot_wild",
        name = "farming:beetroot_wild",
        noise_params = {
            offset = -0.12,
            scale = 0.45,
            spread = {x = 85, y = 85, z = 85},
            seed = 95,
            octaves = 1,
            persist = 0.57
        },
        place_on = {"default:dirt_with_grass", "default:dirt_with_rainforest_litter"},
        sidelen = 16,
        y_max = 6005,
        y_min = 5,
    })
end

local mg_name = minetest.get_mapgen_setting("mg_name")

if mg_name == "v6" then
	register_mgv6_decorations()
else
	register_decorations()
end
