--[[ Cleaner mod
	License: MIT
]]


cleaner = {}
cleaner.modname = core.get_current_modname()

local cleaner_debug = core.settings:get_bool("enable_debug_mods", false)

function cleaner.log(lvl, msg)
	if lvl == "debug" and not cleaner_debug then return end

	msg = "[" .. cleaner.modname .. "] " .. msg
	if lvl == "debug" then
		msg = "[DEBUG] " .. msg
		lvl = nil
	end

	core.log(lvl, msg)
end


-- ENTITIES

local old_entities = {}

-- Populate entities list from file in world path
local e_list = nil
local e_path = core.get_worldpath() .. "/clean_entities.txt"
local e_file = io.open(e_path, "r")
if e_file then
	e_list = e_file:read("*a")
	e_file:close()
else
	-- Create empty file
	e_file = io.open(e_path, "w")
	if e_file then
		e_file:close()
	end
end

if e_list then
	cleaner.log("debug", "Loading entities to clean from file ...")

	e_list = string.split(e_list, "\n")
	for _, entity_name in ipairs(e_list) do
		table.insert(old_entities, entity_name)
	end
end

for _, entity_name in ipairs(old_entities) do
	cleaner.log("debug", "Cleaning entity: " .. entity_name)

    core.register_entity(":" .. entity_name, {
        on_activate = function(self, staticdata)
            self.object:remove()
        end,
    })
end


-- NODES

local old_nodes = {}

-- Populate nodes list from file in world path
local n_list = nil
local n_path = core.get_worldpath() .. "/clean_nodes.txt"
local n_file = io.open(n_path, "r")
if n_file then
	n_list = n_file:read("*a")
	n_file:close()
else
	-- Create empty file
	n_file = io.open(n_path, "w")
	if n_file then
		n_file:close()
	end
end

if n_list then
	cleaner.log("debug", "Loading nodes to clean from file ...")

	n_list = string.split(n_list, "\n")
	for _, node_name in ipairs(n_list) do
		table.insert(old_nodes, node_name)
	end
end

for _, node_name in ipairs(old_nodes) do
	cleaner.log("debug", "Cleaning node: " .. node_name)

    core.register_node(":" .. node_name, {
        groups = {old=1},
    })
end

core.register_abm({
    nodenames = {"group:old"},
    interval = 1,
    chance = 1,
    action = function(pos, node)
        core.remove_node(pos)
    end,
})
