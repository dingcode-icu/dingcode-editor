local DataBase = require("data/database")

local dataManager = {
    data = {
        dataList = {},                      -- 创建的数据
    },
    isInit = false,                         -- 是否已经初始化
}

function dataManager:init(config, isNotResetHistory)
    print("datamanager init")
    --dump(config)
    if config and config.data then
        if config.data.dataList then
            for i, v in pairs(config.data.dataList) do
                local data = DataBase.new()
                data:setData(v)
                self.data.dataList[data:getuuid()] = data
            end
        end
    end

    self.isInit = true

    local ViewManager = require("render/viewmanager")
    ViewManager:init(config, isNotResetHistory)
end

function dataManager:reset()

    self.data.dataList = {}

end

function dataManager:getList()
    return self.data.dataList
end

function dataManager:getDataForId(uuid)
    return self.data.dataList[uuid]
end
-- 获取导出的工程数据
function dataManager:get_alldata()
    local real = {
        dataList={}
    }
    for i, v in pairs(self.data.dataList) do
        real.dataList[i] = table.clone(v:getData())
    end
    return real
end
-- 排序子节点
function dataManager:sortChild(childlist)
    local ViewManager = require("render/viewmanager")
    local sortFunc = function(left, right)
        local viewLeft = nil
        local viewRight = nil
        if left.uuid then
            viewLeft = ViewManager:getNodeViewForId(left.uuid)
            viewRight = ViewManager:getNodeViewForId(right.uuid)
        else
            if left.id then
                viewLeft = ViewManager:getNodeViewForId(left.id)
                viewRight = ViewManager:getNodeViewForId(right.id)
            end
        end
        --print(viewLeft, viewRight)
        if viewLeft and viewRight and viewLeft:getPositionX() < viewRight:getPositionX() then
            return true
        end
        return false
    end
    table.sort(childlist, sortFunc)
end
function dataManager:buildChildData(data)
    local childlist = data.lineidlist[enum.dropnode_key.child]
    if childlist and #childlist > 0 then
        data.childdatalist = {}
        for i, v in ipairs(childlist) do
            local tempChild = self:getDataForId(v.id)
            if tempChild then
                local tempChildSave = table.clone(tempChild:getData())
                table.insert(data.childdatalist, tempChildSave)
                self:buildChildData(tempChildSave)
            end
        end
        self:sortChild(data.childdatalist)
    end
end
-- 获取导出的 行为树解析数据
function dataManager:get_export_tree()
    local real = {
        tree = {}
    }
    for i, v in pairs(self.data.dataList) do
        local dataReal = v:getData()
        --if #v:getParentIdList() <= 0 then
        if v:gettype() == enum.enum_node_type.root then
            local dataSave = table.clone(dataReal)
            self:buildChildData(dataSave)

            real.tree[i] = dataSave
        end
    end
    return real
end
function dataManager:createData(nodeType)

    local data = DataBase.new(nodeType)

    self.data.dataList[data:getuuid()] = data

    return data
end

function dataManager:removeData(id)
    if id then
        self.data.dataList[id] = null
    end
end

return dataManager