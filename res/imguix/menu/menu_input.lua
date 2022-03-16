local Lang = require("res/lib/language/Lang")
local enum = require("enum")

-- node菜单
local tabInputNode = {
    data = {
        _isShow = false,
        _posX = 100,
        _posY = 100,
        _finishFunc = nil,
        _typeinput = nil,
        _isInputed = false,
        _lab = nil,
        _isEnd = false,
    },
    enuminput = {
        int,
        float,
        text,
    },
}

--显示菜单
function tabInputNode:show(args)
    --print("显示 tabInputNode")
    self.data._isShow = true
    if args then
        --if args.posX then
        --    self.data._posX = args.posX
        --else
        --    self.data._posX = 0
        --end
        --if args.posY then
        --    self.data._posY = args.posY
        --else
        --    self.data._posY = 0
        --end
        if args.finishFunc then
            self.data._finishFunc = args.finishFunc
        end
        if args.typeinput then
            self.data._typeinput = args.typeinput
        else
            self.data._typeinput = self.enuminput.int
        end
        self.data._isInputed = false
        self.data._lab = nil
        self.data._isEnd = false
    end
end
--隐藏菜单
function tabInputNode:hide()
    --print("隐藏 tabInputNode")
    self.data._finishFunc = nil
    self.data._isInputed = false
    self.data._lab = nil
    self.data._isEnd = true
    self.data._isShow = false
end

-- 是否在显示
function tabInputNode:isShow()
    return self.data._isShow
end

function tabInputNode.render()
    if tabInputNode.data._isShow then
        ImGui.SetNextWindowPos(tabInputNode.data._posX, tabInputNode.data._posY, ImGui.ImGuiCond.Always)
        ImGui.Begin("tabInputNode", true, ImGui.ImGuiWindowFlags.NoTitleBar)
        if tabInputNode.data._typeinput == tabInputNode.enuminput.float then
            local curNum = 0
            if tabInputNode.data._lab ~= nil then
                curNum = tabInputNode.data._lab
            end
            local lab,isInputed = ImGui.InputFloat("float", curNum, 0.1, 1);
            if not tabInputNode.data._isEnd then
                if isInputed then
                    tabInputNode.data._isInputed = true
                    tabInputNode.data._lab = lab
                else
                    if tabInputNode.data._isInputed then
                        tabInputNode.data._isEnd = true
                        tabInputNode:hide()
                        if tabInputNode.data._finishFunc then
                            tabInputNode.data._finishFunc(tabInputNode.data._lab)
                        end
                    end
                end
            end

        elseif tabInputNode.data._typeinput == tabInputNode.enuminput.text then

        else

        end

        --local num,isF = ImGui.InputText("input float", "0", 12)
        --if isF then
        --print(num, isF)

        ImGui.End()
    end

end

if ImGuiDraw then
    print("注册 tabInputNode")
    ImGuiDraw(tabInputNode.render)
end

return tabInputNode