print("init lib...")
require("lib/lua_ex")
require("lib/functions")
require("lib/display")
require("lib/display_ex")
require("lib/extends/node_ex")
require("lib/extends/sprite_ex")

local SHADER_RES = {
    outline = {"assets/shader/default.vert", "assets/shader/sp_outline.frag", {
        u_outlineColor = {
            x = 153,
            y = 0,
            z = 51
        },
        u_threshold = 1,
        u_radius = 0.01
    }}
}
_G.ShaderMgr = require("lib/inc/shader_inc")
ShaderMgr:getInc():init(SHADER_RES)
