local _p = class("PopupAddNode")

local Api = require("http/api")
local ViewManager = require("render/viewmanager")

function _p:ctor()
    self._pos_x = 0
    self._pos_y = 0

    self.name_ = ""
    self.desc_ = ""
    self.gType_ = "action"
    self.sType_ = ""

    self.is_show = false
end

function _p:show()
    self.is_show = true
end

function _p:hide()
    self.is_show = false
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
            local sel_items = table.keys(enum.enum_node_type)
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

            ImGui.Text("项目名称(default:common)：")

            self.sType_ = ImGui.InputText("", self.sType_, 100)

            ImGui.Separator()
            if (ImGui.Button("OK")) then
                ViewManager:showTip("requesting to add...")
                Api:addNode(self.name_, self.desc_, self.gType_, self.sType_, function()
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

