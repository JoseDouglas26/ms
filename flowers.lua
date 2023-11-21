-- ms/flowers.lua
local S = minetest.get_translator("ms")

local new_data = {
    {
        "daisy",
        S("@1 Daisy", S("Grey")),
        {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25},
        {color_grey = 1}
    },
    {
        "iris",
        S("@1 Iris", S("Brown")),
        {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25},
        {color_brown = 1}
    },
    {
        "lily",
        S("@1 Lily", S("Light Blue")),
        {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25},
        {color_light_blue = 1}
    },
    {
        "orchid",
        S("@1 Orchid", S("Cyan")),
        {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25},
        {color_cyan = 1}
    },
    {
        "peony",
        S("@1 Peony", S("Magenta")),
        {-0.125, -0.5, -0.125, 0.125, 0.25, 0.125},
        {color_magenta = 1}
    },
    {
        "tulip_pink",
        S("@1 Tulip", S("Pink")),
        {-0.125, -0.5, -0.125, 0.125, 0.1875, 0.125},
        {color_pink = 1}
    },
}

local function add_simple_flower(name, description, selectionbox, groups)
    groups.attached_node = 1
    groups.flammable = 1
    groups.flora = 1
    groups.flower = 1
    groups.snappy = 3

    minetest.register_node(
        ":flowers:" .. name,
        {
            buildable_to = true,
            description = description,
            drawtype = "plantlike",
            groups = groups,
            inventory_image = "ms_flowers_" .. name .. ".png",
            paramtype = "light",
            selection_box = {type = "fixed", fixed = selectionbox},
            sounds = default.node_sound_leaves_defaults(),
            sunlight_propagates = true,
            tiles = {"ms_flowers_" .. name .. ".png"},
            walkable = false,
            waving = 1,
            wield_image = "ms_flowers_" .. name .. ".png"
        }
    )
end

local function register_mgv6_flower(flower_name)
	minetest.register_decoration({
		name = "flowers:" .. flower_name,
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.006,
			spread = {x = 100, y = 100, z = 100},
			seed = 436,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 1,
		decoration = "flowers:" .. flower_name,
	})
end

local function register_flower(seed, flower_name)
	minetest.register_decoration({
		name = "flowers:" .. flower_name,
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.02,
			scale = 0.04,
			spread = {x = 200, y = 200, z = 200},
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"grassland", "deciduous_forest"},
		y_max = 31000,
		y_min = 1,
		decoration = "flowers:" .. flower_name,
	})
end

local mg_name = minetest.get_mapgen_setting("mg_name")

for _, item in pairs(new_data) do
    local name = item[1]

    add_simple_flower(unpack(item))

    if mg_name == "v6" then
        register_mgv6_flower(name)
    else
        register_flower(math.random(100, 1000000), name)
    end
end
