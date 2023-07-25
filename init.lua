local players = {}

local function vdistance(a, b)
	local x, y, z = a.x - b.x, a.y - b.y, a.z - b.z
	return x*x + y*y + z*z
end

local function set_checkpoint(player, pos)
	local name = player:get_player_name()
	local ppos = player:getpos()

	if vdistance(pos, ppos) <= 10 then
		players[name] = ppos
		minetest.sound_play({name="checkpoint_checkpoint", gain=0.75},
				{to_player=name})
		minetest.chat_send_player(name, "Checkpoint set.")
	else
		minetest.chat_send_player(name, "Out of range!")
	end
end

minetest.register_node("d53_checkpoint:checkpoint_button", {
	description = "Checkpoint button.",
	tiles = {"checkpointbtn.png"},
	drawtype = "mesh",
	light_source = 6,
	paramtype = "light",
	mesh = "checkpointbtn.obj",
	collision_box = {
		type = "fixed",
		fixed = {0.2, 0.55, 0.2, -0.2, -1, -0.2},
	},
	selection_box = {
		type = "fixed",
		fixed = {0.2, 0.55, 0.2, -0.2, -1, -0.2},
	},
	on_rightclick = function(pos, _, clicker)
		set_checkpoint(clicker, pos)
	end,
	on_punch = function(pos, _, puncher)
		set_checkpoint(puncher, pos)
	end
})

minetest.register_chatcommand("checkpoint", {
	description = "Restore saved checkpoint.",
	func = function(name, param)
		local pos = players[name]
		if pos then
			local player = minetest.get_player_by_name(name)
			player:setpos(pos)
		else
			minetest.chat_send_player(name, "No checkpoint saved.")
		end
	end
})

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	players[name] = nil
end)
