-- 多语言 取配置 文件
Lang = {
    data = {
        language = "zh_cn",
        config = {}
    }
}

function Lang:init(args)

    if args and args.language then
        self.data.language = args.language
    end

    if self.data.language == "zh_cn" then
        self.data.config[self.data.language] = require("/lib/language/" .. self.data.language)
    end

end

function Lang:Lang(args1, args2)
    local dataConfig = self.data.config[self.data.language]
    return self.getConfig(dataConfig, args1, args2)
end

--function Lang.Lang(args1, args2)
--    local dataConfig = Lang.data.config[self.data.language]
--    return Lang.getConfig(dataConfig, args1, args2)
--end

function Lang.getConfig(dataConfig, args1, args2)
    if dataConfig then
        if args1 and dataConfig[args1] then
            if args2 then
                if dataConfig[args1][args2] then
                    return dataConfig[args1][args2]
                end
            else
                return dataConfig[args1]
            end
        end
    end
    return "null"
end

return Lang