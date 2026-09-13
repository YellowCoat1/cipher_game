local node_list = {}
node_list.nodes = {}
node_list.node_connections = {}
node_list.active_node = nil

function node_list:insert_node(node)
	node.active = false
	table.insert(self.nodes, node)
end

function node_list:insert_nodes(...)
	local args = {...}
	for _,arg in ipairs(args) do
		self:insert_node(arg)
	end
end

function node_list:focused_node(index)
	if self.active_node then
		self.nodes[self.active_node].active = false
	end
	self.active_node = index
	self.nodes[index].active = true
end

function node_list:get_focused_node()
	if not self.active_node then return nil end
	return self.nodes[self.active_node]
end

function node_list:completed()
	if self.active_node then
		if self.nodes[self.active_node]:completed() then
			return true
		end
	end
	return false
end

function node_list:delete_node(index)
	table.remove(self.nodes, index)
	for _,connection in ipairs(self.node_connections) do
		if connection[1] > index then
			connection[1] = connection[1] - 1
		end
		if connection[2] > index then
			connection[2] = connection[2] - 1
		end
	end
	if self.active_node == index then
		self.active_node = nil
	end
end

function node_list:insert_connection(index1, index2)
	table.insert(self.node_connections, {index1, index2})
end
function node_list:delete_connection(connection_index)
	table.remove(self.node_connections, connection_index)
end

function node_list:draw()
		self:draw_node_connections()
		for _,single_node in ipairs(self.nodes) do
			single_node:draw()
		end
end

function node_list:update(dt)
	for _,single_node in ipairs(self.nodes) do
		single_node:update(dt)
	end
end

function node_list:draw_node_connections()
	for _, node_connection in ipairs(self.node_connections) do
		local nodec1, nodec2 = self.nodes[node_connection[1]], self.nodes[node_connection[2]]
		love.graphics.line(nodec1.x, nodec1.y, nodec2.x, nodec2.y)
	end
end


return node_list
