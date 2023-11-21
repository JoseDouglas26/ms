-- ms/shears.lua
local S = minetest.get_translator("ms")

local sheared_leaves = {}

local sapling_by_leave = {
    ["leaves"] = "sapling",
    ["bush_leaves"] = "bush_sapling",
    ["aspen_leaves"] = "aspen_sapling",
    ["jungleleaves"] = "junglesapling",
    ["blueberry_bush_leaves"] = "blueberry_bush_sapling",
    ["blueberry_bush_leaves_with_berries"] = "blueberry_bush_sapling",
    ["acacia_leaves"] = "acacia_sapling",
    ["acacia_bush_leaves"] = "acacia_bush_sapling",
    ["pine_needles"] = "pine_sapling",
    ["pine_bush_needles"] = "pine_bush_sapling"
}

local function can_shear(pos)
    local current_time = os.time()

    for i, entry in ipairs(sheared_leaves) do
        local elapsed_time = current_time - entry.time

        if elapsed_time >= 30 * 60 then
            table.remove(sheared_leaves, i)
        end

        if vector.equals(entry.pos, pos) then
            return false
        end
    end

    return true
end

local function on_use(itemstack, placer, pointed_thing)
    local pos = minetest.get_pointed_thing_position(pointed_thing)
    local name = string.sub(minetest.get_node(pos).name, 9)

    if name:find("leaves") or name:find("needles") then
        if not can_shear(pos) then
            return itemstack
        end

        local inv = placer:get_inventory()
        local item = "default:" .. sapling_by_leave[name]

        if inv:room_for_item("main", item) then
            inv:add_item("main", ItemStack(item .. " 1"))
        else
            return itemstack
        end

        if not minetest.is_creative_enabled(placer:get_player_name()) then
            itemstack:add_wear_by_uses(120)
        end

        local current_time = os.time()
        table.insert(sheared_leaves, {pos = pos, time = current_time})
    end

    return itemstack
end

minetest.register_tool(
    ":default:shears",
    {
        description = S("Shears"),
        inventory_image = "ms_shears.png",
        on_use = on_use,
        wield_image = "ms_shears.png"
    }
)

minetest.register_craft({
    output = "default:shears",
    recipe = {
        {"", "default:steel_ingot", ""},
        {"default:steel_ingot", "", ""},
    }
})
