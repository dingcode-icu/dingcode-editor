return {
	--[[==============================action==============================]]
	{
	    name = "action_movenode",
	    type = "action",
	    desc = "移动",
	    supposeType = "graph",
	    input = {
	        in_int_1 = {
	            direct = "left",
	            key = "in_int",
	            numMax = 1,
	        },
	        in_float_2 = {
	            direct = "left",
	            key = "in_float",
	            numMax = 1,
	        },
	        in_text_3 = {
	            direct = "left",
	            key = "in_text",
	            numMax = 1,
	        },
	    },
	},
	--[[==============================other==============================]]
	{
		
	}
}