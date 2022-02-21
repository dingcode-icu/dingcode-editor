print('lua entry')


--todo

-- local lua_ex = require("ding")
-- local config = require("config")

local resRootPath = cc.FileUtils:getInstance():getDefaultResourceRootPath()
print('res root:'..resRootPath)
print(os.time())

package.path = package.path..string.format('%s/?.lua', resRootPath)..string.format(';%s/res/?.lua', resRootPath)

local sc = cc.Scene.create()



print(ImGui, "-->>imgui")
print(sc, "-->>scene")

 local _drawList = {}
 function ImGuiDraw(func)
     _drawList[func] = func
 end

local function test_svg()
        local  svgSprite = ding.SVGSprite.create("tiger.svg");
    sc:addChild(svgSprite)

end

 function ImGuiRenderer()

     for k,v in pairs(_drawList) do
         if v then v() end
     end
 end


 local function createDefaultWindow()
     ImGui.Separator()
     ImGui.Text('Hello from Lua')
 end
 --ImGuiDraw(createDefaultWindow)
-- data

local buf = "Quick brown fox"
local float = 3
local isToolbarOpened = true

-- draw
ImGuiDraw(function ( )
    print("lua window")
    ImGui.Begin('Lua Window 222')
    --ImGui.Text("Hello, world!");
    --f = ImGui.SliderFloat("float", f, 0.0, 1.0)
    --color = ImGui.ColorEdit3("clear color", color);
    --if (ImGui.Button("Test Window")) then
    --    print('click Test Window')
    --end
    --
    --if (ImGui.Button("Another Window")) then
    --    print('click another window')
    --end

    ImGui.End()

end)
cc.Director:getInstance():runWithScene(sc)

--test_svg()