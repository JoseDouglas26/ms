-- ms/fireworks.lua
local S = minetest.get_translator("ms")

local function create_sphere_explosion(color, pos)
    local texture = "ms_firework_particle.png^[colorize:" .. ms.get_code(color) .. ":255"

    local num_particles = 1024
    local explosion_duration = 0.15
    local initial_radius = 0.1
    local final_radius = 2.5

    for i = 1, num_particles do
        minetest.after(i * explosion_duration / num_particles, function()
            local theta = math.random(0, 360)
            local phi = math.random(0, 180)

            local progress = i / num_particles
            local current_radius = initial_radius + progress * (final_radius - initial_radius)

            local x = pos.x + current_radius * math.sin(math.rad(phi)) * math.cos(math.rad(theta))
            local y = pos.y + current_radius * math.sin(math.rad(phi)) * math.sin(math.rad(theta))
            local z = pos.z + current_radius * math.cos(math.rad(phi))

            minetest.add_particle({
                acceleration = {x = 0, y = 0, z = 0},
                expirationtime = explosion_duration,
                glow = 30,
                pos = {x = x, y = y, z = z},
                size = 2,
                texture = texture,
                velocity = {x = 0, y = 0, z = 0},
            })
        end)
    end
end

local function on_activate(self, staticdata)
    self.timer = 0

    if staticdata ~= "" then
        self._star = minetest.deserialize(staticdata)
    end
end

local function on_place(itemstack, placer, pointed_thing)
    local star = itemstack:get_meta():get_string("star")
    local initial_pos = pointed_thing.above

    if not star then
        star = ""
    end

    if minetest.add_entity(initial_pos, itemstack:get_name() .. "_ent", star) then
        if minetest.is_creative_enabled(placer:get_player_name()) then
            itemstack:take_item()
        end
    end

    return itemstack
end

local function on_step(self, dtime)
    self.timer = self.timer + dtime
    local pos = self.object:get_pos()

    if self.timer < self._max_timer then
        pos.y = pos.y + 7 * dtime
        self.object:set_pos(pos)

        minetest.add_particle({
            acceleration = {x = 0.1, y = 0.2, z = 0.1},
            collisiondetection = true,
            expirationtime = 0.75,
            glow = 20,
            pos = {x = pos.x, y = pos.y - 0.5, z = pos.z},
            size = 2,
            texture = "ms_firework_particle.png^[colorize:#FDFF6D:255",
            velocity = {x = math.random(), y = -1, z = math.random()},
            vertical = false
        })
    else
        if self._star then
            if self._star.format == "default" then
                create_sphere_explosion(self._star.color, pos)
            end
        end

        self.object:remove()
    end
end

minetest.register_craftitem(
    ":fireworks:firework",
    {
        description = S("Firework"),
        groups = {not_in_creative_inventory = 1},
        inventory_image = "ms_rocket.png",
        on_place = on_place,
        wield_image = "ms_rocket.png"
    }
)

minetest.register_craftitem(
    ":fireworks:rocket",
    {
        description = S("Rocket"),
        inventory_image = "ms_rocket.png",
        on_place = on_place,
        wield_image = "ms_rocket.png"
    }
)

for i = 1, #ms.colors do
    local color_name, color_desc, color_code = unpack(ms.colors[i])

    minetest.register_craftitem(
        ":fireworks:star_" .. color_name,
        {
            color = color_code,
            description = S("@1 Firework Star", S(color_desc)),
            groups = {firework_star = 1},
            inventory_image = "ms_firework_star.png",
            wield_image = "ms_firework_star.png"
        }
    )

    minetest.register_craft({
        output = "fireworks:star_" .. color_name,
        recipe = {
            "tnt:gunpowder",
            "group:dye,color_" .. color_name
        },
        type = "shapeless"
    })
end

minetest.register_craft({
    output = "fireworks:firework",
    recipe = {
        "fireworks:rocket",
        "group:firework_star"
    },
    type = "shapeless"
})

minetest.register_craft({
    output = "fireworks:firework",
    recipe = {
        "fireworks:rocket",
        "group:firework_star",
        "group:firework_modifier"
    },
    type = "shapeless"
})

minetest.register_craft({
    output = "fireworks:rocket 3",
    recipe = {
        {"", "default:paper", ""},
        {"", "tnt:gunpowder", ""},
        {"", "farming:string", ""},
    }
})

minetest.register_entity(
    ":fireworks:firework_ent",
    {
        _max_timer = 2.5,
        _star = {},
        glow = 14,
        on_activate = on_activate,
        on_step = on_step,
        physical = true,
        pointable = false,
        textures = {"ms_rocket.png"},
        visual = "sprite",
    }
)

minetest.register_entity(
    ":fireworks:rocket_ent",
    {
        _max_timer = 2.5,
        glow = 14,
        on_activate = on_activate,
        on_step = on_step,
        physical = true,
        pointable = false,
        textures = {"ms_rocket.png"},
        visual = "sprite",
    }
)

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
    local color_name = ""
    local format_name = ""

    for i = 1, #old_craft_grid do
        local stack = old_craft_grid[i]

        if stack then
            local stack_name = stack:get_name()

            if minetest.get_item_group(stack_name, "firework_star") == 1 then
                color_name = string.sub(stack_name, 16)
            end

            if minetest.get_item_group(stack_name, "firework_modifier") == 1 then
                format_name = ms.get_format(stack_name:sub(9))
            end
        end
    end

    if color_name ~= "" then
        if format_name == "" then
            format_name = "default"
        end

        local item_meta = itemstack:get_meta()
        local string = minetest.serialize({format = format_name, color = color_name})
        item_meta:set_string("star", string)
    end
end)

for item_name, item_def in pairs(minetest.registered_items) do
    local coal_groups = {coal = 1, firework_modifier = 1, flammable = 1}
    local new_groups = {firework_modifier = 1}
    if string.find(item_name, "lump") and not string.find(item_name, "clay") then
        if string.find(item_name, "coal") then
            minetest.override_item(item_name, {groups = coal_groups})
        else
            minetest.override_item(item_name, {groups = new_groups})
        end
    end
end
