local node_list = {}

local coal_color = {64/256, 64/256, 64/256}
local cipher_secondary_color = {107/255, 128/255, 255/255}

function node_list.new()
	local self = {}
	self.nodes = {}
	self.node_connections = {}
	self.active_node = nil

	function self:insert_node(node)
		node.active = false
		table.insert(self.nodes, node)
	end


	function self:insert_nodes(...)
		local args = {...}
		for _,arg in ipairs(args) do
			self:insert_node(arg)
		end
	end


	function self:focused_node(index)
		if self.active_node then
			self.nodes[self.active_node].active = false
		end
		self.active_node = index
		self.nodes[index].active = true
	end


	function self:get_focused_node()
		if not self.active_node then return nil end
		return self.nodes[self.active_node]
	end

	function self:connections_from(index)
		local list = {}
		for _,v in ipairs(self.node_connections) do
			if v[1] == index then
				table.insert(list, v)
			end
		end
		return list
	end

	function self:completed()
		if self.active_node then
			if self.nodes[self.active_node]:completed() then
				return true
			end
		end
		return false
	end

	function self:delete_node(index)
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

	function self:insert_connection(index1, index2, status)
		table.insert(self.node_connections, {index1, index2, status})
	end
	function self:delete_connection(connection_index)
		table.remove(self.node_connections, connection_index)
	end

	function self:draw()
			self:draw_node_connections()
			for _,single_node in ipairs(self.nodes) do
				single_node:draw()
			end
	end

	function self:update(dt)
		for _,single_node in ipairs(self.nodes) do
			single_node:update(dt)
		end
	end

	function self:draw_node_connections()
		for _, node_connection in ipairs(self.node_connections) do
			if not node_connection[3] then
				love.graphics.setColor(coal_color)
			else
				love.graphics.setColor(cipher_secondary_color)
			end
			local nodec1, nodec2 = self.nodes[node_connection[1]], self.nodes[node_connection[2]]
			love.graphics.line(nodec1.x, nodec1.y, nodec2.x, nodec2.y)
		end
	end

	function self:selected_edge() -- finds the selected edge, if any
		local selected
		local connections = self:connections_from(self.active_node)
		for i,connection in ipairs(connections) do
			if connection[3] then
				selected = i
			end
		end
		return connections, selected
	end

	function self:keyreleased(key)
		if key == "space" then
			if self:completed() then
				local connections, selected = self:selected_edge()
				if selected then
					local selected_target = connections[selected][2]
					self:focused_node(selected_target)
					self:jumpCallback()
				end
			end
		end

		if self.active_node then
			self.nodes[self.active_node]:keyreleased(key)
		end
	end

	function self:keypressed(key)
		if self:completed() then
			local connections = self:connections_from(self.active_node)
			if #connections == 1 then
				connections[1][3] = true
			elseif #connections <= 0 then
				return
			end
			local selectedInitial = 1
			for i,connection in ipairs(connections) do
				if connection[3] then
					selectedInitial = i
				end
			end
			local selected = selectedInitial
			if key == "left" or key == "a" then
				selected = math.max(1, selectedInitial-1)
			elseif key == "right" or key == "d" then
				selected = math.min(selectedInitial+1, #connections)
			end

			connections[selectedInitial][3] = false
			connections[selected][3] = true
		end
	end

	function self:jumpCallback() -- function stub

	end



	return self
end
return node_list
