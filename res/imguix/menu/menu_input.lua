local Lang = require("lib/language/Lang")
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
        _valueOld = nil,
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
            self.data._typeinput = enum.dropnode_key.input_text
        end
        if args.valueOld then
            self.data._valueOld = args.valueOld
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
    self.data._valueOld = nil
end

-- 是否在显示
function tabInputNode:isShow()
    return self.data._isShow
end

function tabInputNode.render()
    if tabInputNode.data._isShow then
        ImGui.SetNextWindowPos(tabInputNode.data._posX, tabInputNode.data._posY, ImGui.ImGuiCond.Always)
        ImGui.SetNextWindowSize(800, 300, ImGui.ImGuiCond.Once)
        ImGui.Begin("tabInputNode", true, ImGui.ImGuiWindowFlags.NoTitleBar)

        -- 当前值
        local strOldValue = "当前值： "
        if tabInputNode.data._valueOld then
            strOldValue = strOldValue .. tabInputNode.data._valueOld
        else
            strOldValue = strOldValue .. "未输入"
        end
        ImGui.Text(strOldValue);
        ImGui.Separator();

        local curNum = nil
        local lab,isInputed
        if tabInputNode.data._typeinput == enum.dropnode_key.input_float then
            curNum = 0
            lab,isInputed = ImGui.InputFloat("float", curNum);
        elseif tabInputNode.data._typeinput == enum.dropnode_key.input_text then
            curNum = ""
            lab,isInputed = ImGui.InputText("text", curNum, 100);
        elseif tabInputNode.data._typeinput == enum.dropnode_key.input_int then
            curNum = 0
            lab,isInputed = ImGui.InputInt("int", curNum);
        end

        if not tabInputNode.data._isEnd then
            if isInputed then
                tabInputNode.data._isInputed = true
                tabInputNode.data._lab = lab
            else
                if tabInputNode.data._isInputed then
                    if tabInputNode.data._finishFunc then
                        tabInputNode.data._finishFunc(tabInputNode.data._lab)
                    end

                    tabInputNode.data._isEnd = true
                    tabInputNode:hide()
                end
            end
        end

        ImGui.End()
    end

end

if ImGuiDraw then
    print("注册 tabInputNode")
    ImGuiDraw(tabInputNode.render)
end

return tabInputNode