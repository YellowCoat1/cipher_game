local node = require 'node'
local node_procedural = {}

function node_procedural.genNext(node_list)
	local initial_node_list_num = #node_list.nodes
	local latest_y = node_list.nodes[#node_list.nodes].y
	local top_row_indexes = {}
	local next_index = #node_list.nodes
	repeat
		table.insert(top_row_indexes, next_index)
		next_index = next_index - 1
	until node_list.nodes[next_index].y ~= latest_y
	

	local num_next = math.random(2, 4)

	local new_edges = {}
	for next_node=1,num_next do
		for _,top_row in ipairs(top_row_indexes) do
			if math.random() > 0.5 then
				table.insert(new_edges, {top_row, next_node})
			end
		end
	end

	for _,top_row in ipairs(top_row_indexes) do
		local edge_includes = false
		for _,edge in ipairs(new_edges) do
			if edge[1] == top_row then edge_includes = true end
		end
		if not edge_includes then
			table.insert(new_edges, {top_row, math.random(1, num_next)})
		end
	end


	-- add new vertices
	for i=1,num_next do
		local x = (i-3)*200
		node_list:insert_node(node(x, latest_y-300, 3))
	end


	-- translate edges into node_list's notation
	for i=1,#new_edges do
		new_edges[i][2] = new_edges[i][2] + initial_node_list_num
	end
	-- insert the edges in
	for _,v in ipairs(new_edges) do
		node_list:insert_connection(v[1], v[2], false)
	end

end





return node_procedural
