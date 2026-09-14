local node = require 'node'
local node_procedural = {}

local random = love.math.random
function node_procedural.genNext(node_list)

	local initial_node_list_num = #node_list.nodes
	local latest_y = node_list.nodes[#node_list.nodes].y
	local top_row_indexes = {}
	local next_index = #node_list.nodes
	repeat
		table.insert(top_row_indexes, next_index)
		next_index = next_index - 1
	until node_list.nodes[next_index].y ~= latest_y

	-- forget about nodes at the top row that have an x-value far away from the main one
	local to_remove = {}
	if node_list.active_node then
		for i,top_row_node in ipairs(top_row_indexes) do
			if math.abs(node_list.nodes[top_row_node].x - node_list.nodes[node_list.active_node].x) > 1900 then
				table.insert(to_remove, i)
			end
		end
		for i=#to_remove,1,-1 do
			table.remove(top_row_indexes, to_remove[i])
		end
	end




	local function clamp(n, min, max)
		return math.min(math.max(n, min), max)
	end
	local num_next = clamp(random(#top_row_indexes-2, #top_row_indexes+2), 3, 10)

	-- find the possible spaces to place the next nodes
	local spaces = {}
	for _,top_row_node in ipairs(top_row_indexes) do
		local xLeft = node_list.nodes[top_row_node].x - 200
		local xCenter = node_list.nodes[top_row_node].x
		local xRight = node_list.nodes[top_row_node].x + 200
		if not spaces[tostring(xLeft)] then
			spaces[tostring(xLeft)] = {top_row_node}
		else
			table.insert(spaces[tostring(xLeft)], top_row_node)
		end

		if not spaces[tostring(xCenter)] then
			spaces[tostring(xCenter)] = {top_row_node}
		else
			table.insert(spaces[tostring(xCenter)], top_row_node)
		end

		if not spaces[tostring(xRight)] then
			spaces[tostring(xRight)] = {top_row_node}
		else
			table.insert(spaces[tostring(xRight)], top_row_node)
		end
	end

	-- find number and list of spaces
	local spaces_x_list = {}
	for space,_ in pairs(spaces) do
		table.insert(spaces_x_list, space)
	end

	-- select spaces for the nums
	if num_next > #spaces_x_list then
		num_next = #spaces_x_list
	end
	local selected_x_vals = {} -- in the format x_val = node_index
	for i=1,num_next do
		local selected_space = random(1, #spaces_x_list)
		local x_val = table.remove(spaces_x_list, selected_space)
		selected_x_vals[tostring(x_val)] = i
	end

	-- make sure there's no stranded nodes
	for _,top_node in ipairs(top_row_indexes) do
		local top_node_x = node_list.nodes[top_node].x
		if not selected_x_vals[tostring(top_node_x-200)] and not selected_x_vals[tostring(top_node_x)] and not selected_x_vals[tostring(top_node_x+200)] then
			num_next = num_next + 1
			selected_x_vals[tostring(top_node_x)] = num_next
		end

	end

	-- add a edge from each top node to a node in its range
	local edge_lists = {}

	for _,top_node in ipairs(top_row_indexes) do
		local top_node_x = node_list.nodes[top_node].x
		local connecting_top_nodes = {}
		if selected_x_vals[tostring(top_node_x-200)] then
			table.insert(connecting_top_nodes, selected_x_vals[tostring(top_node_x-200)])
		end
		if selected_x_vals[tostring(top_node_x)] then
			table.insert(connecting_top_nodes, selected_x_vals[tostring(top_node_x)])
		end
		if selected_x_vals[tostring(top_node_x+200)] then
			table.insert(connecting_top_nodes, selected_x_vals[tostring(top_node_x+200)])
		end

		if #connecting_top_nodes >= 1 then
			local connecting_part = random(1, #connecting_top_nodes)
			local connecting_part_node = table.remove(connecting_top_nodes, connecting_part)
			table.insert(edge_lists, {top_node, connecting_part_node})
		else
			print("stranded node!")
		end
		if #connecting_top_nodes >= 1 then
			local connecting_part = random(1, #connecting_top_nodes)
			local connecting_part_node = table.remove(connecting_top_nodes, connecting_part)
			table.insert(edge_lists, {top_node, connecting_part_node})
		end


	end


	-- remove every new node without an edge to it
	local connected_node = {}
	local num_to_remove = 0
	local nodes_to_remove = {}
	for _,edge in ipairs(edge_lists) do
		connected_node[edge[2]] = true
	end
	for i=1,num_next do
		if not connected_node[i] then
			num_to_remove = num_to_remove + 1
			table.insert(nodes_to_remove, i)
		end
	end
	table.sort(nodes_to_remove)
	for i=#nodes_to_remove,1,-1 do
		local node_to_remove = nodes_to_remove[i]
		for _,edge in ipairs(edge_lists) do
			if edge[2] > node_to_remove then
				edge[2] = edge[2] - 1
			end
		end
		for j,v in pairs(selected_x_vals) do
			if v > node_to_remove then
				selected_x_vals[j] = v-1
			elseif v == node_to_remove then
				selected_x_vals[j] = nil
			end
		end
		num_next = num_next - 1

	end


	-- make a new list sorted by node index
	--
	-- add new nodes
	local node_list_len = #node_list.nodes
	for x_val,node_index in pairs(selected_x_vals) do
		node_list.nodes[node_index+node_list_len] = node(tonumber(x_val), latest_y-300, 3)
	end


	-- translate edges into node_list's notation
	for i=1,#edge_lists do
		edge_lists[i][2] = edge_lists[i][2] + initial_node_list_num
	end
	-- insert the edges in
	for _,v in ipairs(edge_lists) do
		node_list:insert_connection(v[1], v[2], false)
	end

end





return node_procedural
