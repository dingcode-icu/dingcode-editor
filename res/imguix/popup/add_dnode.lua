local _p = class("PopupAddNode")

local Api = require("net/api")
local ViewManager = require("render/viewmanager")
local json = require("lib/json")

function _p:ctor()
    self._pos_x = 0
    self._pos_y = 0

    self.name_ = ""
    self.desc_ = ""
    self.gType_ = "action"
    self.sType_ = ""

    self.is_show = false
    self.input_list = {}
    self.output_list = {}
end

function _p:show()
    self.is_show = true
    self.input_list = {}
    self.output_list = {}
end

function _p:hide()
    self.is_show = false
    self.input_list = {}
    self.output_list = {}
end

function _p:isShow()
    return self.is_show
end

function _p:render()
    if self.is_show then
        ImGui.OpenPopup("Add")
        if ImGui.BeginPopupModal("Add") then


            ImGui.Text("填写要添加的节点信息")

            --row

            ImGui.Text("名称:")
            ImGui.SameLine()
            self.name_ = ImGui.InputText("text1", self.name_, 20)

            ImGui.Text("描述:")
            ImGui.SameLine()
            self.desc_ = ImGui.InputText("text2", self.desc_, 100)


            ImGui.Text("节点类型:")
            local cur_index = 1
            local is_sel
            local sel_items = table.values(enum.enum_node_type)
            if (ImGui.BeginCombo("##custom combo", self.gType_)) then
                for i, v in ipairs(sel_items) do
                    is_sel = false
                    if self.gType_ == v then
                        cur_index = i
                        is_sel = true
                    end
                    if ImGui.Selectable(v, is_sel) then
                        self.gType_ = v
                    end
                    if is_sel then
                        ImGui.SetItemDefaultFocus()
                    end
                end
                ImGui.EndCombo()
            end
            ImGui.Text("输入: ")
            ImGui.SameLine()
            ImGui.HelpMarker("新增输入参数：\n inputKey: 输入对象的查找索引\n direct: 输入参数在节点中的摆放位置\n key: 输入的类型\n numMax: 可拖拽的节点最大拖拽数量\n desc: 描述信息")
            ImGui.SameLine()
            if (ImGui.Button("+##input")) then
                --ViewManager:showTip("新增")
                table.insert(self.input_list, {
                    inputKey = "",
                    direct = enum.node_direct.left,
                    key = enum.dropnode_key.input_text,
                    desc = "",
                    numMax = 0,
                })
            end
            if self.input_list and #self.input_list > 0 then
                for i, v in ipairs(self.input_list) do
                    local curKey = i
                    local curValue = v
                    if (ImGui.Button("-" .. "##" .. "addinput" .. curKey)) then
                        --ViewManager:showTip("" .. curKey)
                        table.remove(self.input_list, curKey)
                    end
                    ImGui.SameLine()
                    ImGui.Text("inputKey: ")
                    ImGui.SameLine()
                    ImGui.SetNextItemWidth(200)
                    curValue.inputKey = ImGui.InputText("" .. "##input_" .. "inputKey" .. curKey, curValue.inputKey or "", 100);

                    ImGui.SameLine()
                    ImGui.Text("      direct: ")
                    ImGui.SameLine()
                    --curValue.direct = ImGui.InputText("" .. "##input_" .. "direct" .. curKey, curValue.direct or "", 100);
                    ImGui.SetNextItemWidth(100)
                    local is_sel_direct = false
                    local sel_items_direct = table.values(enum.node_direct)
                    if (ImGui.BeginCombo("" .. "##input_" .. "direct" .. curKey, curValue.direct or enum.node_direct.left)) then
                        for i, v in ipairs(sel_items_direct) do
                            is_sel_direct = false
                            if curValue.direct == v then
                                is_sel_direct = true
                            end
                            if ImGui.Selectable(v, is_sel_direct) then
                                curValue.direct = v
                            end
                            if is_sel_direct then
                                ImGui.SetItemDefaultFocus()
                            end
                        end
                        ImGui.EndCombo()
                    end


                    ImGui.Text("      inputType: ")
                    ImGui.SameLine()
                    ImGui.SetNextItemWidth(200)
                    --curValue.key = ImGui.InputText("" .. "##input_" .. "inputType" .. curKey, curValue.key or "", 100);
                    local is_sel_inputType = false
                    local sel_items_inputType_all = table.values(enum.dropnode_key)
                    local sel_items_inputType = {}
                    for i, v in ipairs(sel_items_inputType_all) do
                        if string.find(v, "input_") or string.find(v, "in_") then
                            table.insert(sel_items_inputType, v)
                        end
                    end
                    if (ImGui.BeginCombo("" .. "##input_" .. "inputType" .. curKey, curValue.key or enum.dropnode_key.input_text)) then
                        for i, v in ipairs(sel_items_inputType) do
                            is_sel_inputType = false
                            if curValue.key == v then
                                is_sel_inputType = true
                            end
                            if ImGui.Selectable(v, is_sel_inputType) then
                                curValue.key = v
                            end
                            if is_sel_inputType then
                                ImGui.SetItemDefaultFocus()
                            end
                        end
                        ImGui.EndCombo()
                    end

                    ImGui.SameLine()
                    ImGui.Text("      numMax: ")
                    ImGui.SameLine()
                    ImGui.SetNextItemWidth(140)
                    curValue.numMax = ImGui.InputInt("" .. "##input_" .. "numMax" .. curKey, curValue.numMax or 0);

                    ImGui.Text("      desc: ")
                    ImGui.SameLine()
                    curValue.desc = ImGui.InputText("" .. "##input_" .. "desc" .. curKey, curValue.desc or "", 100);

                end
            end

            ImGui.Separator()


            ImGui.Text("输出: ")
            ImGui.SameLine()
            ImGui.HelpMarker("新增输出参数：\n outputKey: 输入对象的查找索引\n direct: 输入参数在节点中的摆放位置\n key: 输入的类型\n numMax: 可拖拽的节点最大拖拽数量\n desc: 描述信息")
            ImGui.SameLine()
            if (ImGui.Button("+##output")) then
                --ViewManager:showTip("新增")
                table.insert(self.output_list, {
                    outputKey = "",
                    direct = enum.node_direct.right,
                    key = enum.dropnode_key.out_text,
                    desc = "",
                    numMax = 0,
                })
            end
            if self.output_list and #self.output_list > 0 then
                for i, v in ipairs(self.output_list) do
                    local curKey = i
                    local curValue = v
                    if (ImGui.Button("-" .. "##" .. "addoutput" .. curKey)) then
                        --ViewManager:showTip("" .. curKey)
                        table.remove(self.output_list, curKey)
                    end
                    ImGui.SameLine()
                    ImGui.Text("outputKey: ")
                    ImGui.SameLine()
                    ImGui.SetNextItemWidth(200)
                    curValue.outputKey = ImGui.InputText("" .. "##output_" .. "outputKey" .. curKey, curValue.outputKey or "", 100);

                    ImGui.SameLine()
                    ImGui.Text("      direct: ")
                    ImGui.SameLine()
                    --curValue.direct = ImGui.InputText("" .. "##output_" .. "direct" .. curKey, curValue.direct or "", 100);
                    ImGui.SetNextItemWidth(100)
                    local is_sel_direct = false
                    local sel_items_direct = table.values(enum.node_direct)
                    if (ImGui.BeginCombo("" .. "##output_" .. "direct" .. curKey, curValue.direct or enum.node_direct.right)) then
                        for i, v in ipairs(sel_items_direct) do
                            is_sel_direct = false
                            if curValue.direct == v then
                                is_sel_direct = true
                            end
                            if ImGui.Selectable(v, is_sel_direct) then
                                curValue.direct = v
                            end
                            if is_sel_direct then
                                ImGui.SetItemDefaultFocus()
                            end
                        end
                        ImGui.EndCombo()
                    end


                    ImGui.Text("      outputType: ")
                    ImGui.SameLine()
                    ImGui.SetNextItemWidth(200)
                    --curValue.key = ImGui.InputText("" .. "##output_" .. "inputType" .. curKey, curValue.key or "", 100);
                    local is_sel_inputType = false
                    local sel_items_inputType_all = table.values(enum.dropnode_key)
                    local sel_items_inputType = {}
                    for i, v in ipairs(sel_items_inputType_all) do
                        if string.find(v, "out_") then
                            table.insert(sel_items_inputType, v)
                        end
                    end
                    if (ImGui.BeginCombo("" .. "##output_" .. "outputType" .. curKey, curValue.key or enum.dropnode_key.out_text)) then
                        for i, v in ipairs(sel_items_inputType) do
                            is_sel_inputType = false
                            if curValue.key == v then
                                is_sel_inputType = true
                            end
                            if ImGui.Selectable(v, is_sel_inputType) then
                                curValue.key = v
                            end
                            if is_sel_inputType then
                                ImGui.SetItemDefaultFocus()
                            end
                        end
                        ImGui.EndCombo()
                    end

                    ImGui.SameLine()
                    ImGui.Text("      numMax: ")
                    ImGui.SameLine()
                    ImGui.SetNextItemWidth(140)
                    curValue.numMax = ImGui.InputInt("" .. "##output_" .. "numMax" .. curKey, curValue.numMax or 0);

                    ImGui.Text("      desc: ")
                    ImGui.SameLine()
                    curValue.desc = ImGui.InputText("" .. "##output_" .. "desc" .. curKey, curValue.desc or "", 100);

                end
            end

            ImGui.Separator()

            ImGui.Text("项目名称(default:common)：")

            self.sType_ = ImGui.InputText("", self.sType_, 100)

            ImGui.Separator()
            if (ImGui.Button("OK")) then
                ViewManager:showTip("requesting to add...")

                local inputData = {}
                for i, v in ipairs(self.input_list) do
                    inputData[v.inputKey] = {
                        direct = v.direct,
                        key = v.key,
                        desc = v.desc,
                        numMax = v.numMax,
                    }
                end
                local outputData = {}
                for i, v in ipairs(self.output_list) do
                    outputData[v.outputKey] = {
                        direct = v.direct,
                        key = v.key,
                        desc = v.desc,
                        numMax = v.numMax,
                    }
                end

                local data = {
                    name = self.name_,
                    desc = self.desc_,
                    gType = self.gType_,
                    sType = self.sType_,
                    input = json.encode(inputData),
                    output = json.encode(outputData),
                }
                Api:addNode(data, function()
                    Api:initConfig()
                    ViewManager:showTip("done!")
                    ding.showToast("add suc!")
                end)
                self:hide()
            end
            if (ImGui.Button("Cancel")) then

                ImGui.CloseCurrentPopup()
                self:hide()
            end
            ImGui.EndPopup()
        end
    end
end

local PopupAddNode = {
}

function PopupAddNode:inc()
    if self._inc == nil then
        self._inc = _p.new()
    end
    return self._inc
end

function PopupAddNode:render()
    self:inc():render()
end

function PopupAddNode:isShow()
    return self:inc():isShow()
end

function PopupAddNode:show()
    self:inc().is_show = true
end

function PopupAddNode:hide()
    self:inc().is_show = false
end


if ImGuiDraw then
    print("注册 PopupAddNode")
    ImGuiDraw(c_func(PopupAddNode, PopupAddNode.render))
end

return PopupAddNode

