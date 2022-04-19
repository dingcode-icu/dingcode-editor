return {
    --================================
    --condition
    --================================
    {
        name = "is crossing",
        type = "conditionals",
        desc = "是否在路口",
        supposeType = "demo_traffic"
    },
    {
        name = "is light single",
        type = "conditionals", 
        desc = [[是否有灯信号(1-红灯，2-绿灯，3-黄灯)]],
        supposeType = "demo_traffic",
        input = {
            in_int_1 = {
                direct = "left", 
                key = "in_int", 
                numMax = 1
            }
        }
    },
    {
        name  = "is front car",
        type = "conditionals", 
        desc = "是否有前车",
        supposeType = "demo_traffic"
    }, 
    --================================
    --action
    --================================
    {
        name = "slow down",
        type = "action", 
        desc ="减速慢行",
        supposeType = "demo_traffic"
    },
    {
        name = "turn right",
        type = "action", 
        desc = "右转", 
        supposeType = "demo_traffic"
    },
    {
        name ="turn left",
        type = "action",
        desc = "左转",
        supposeType = "demo_traffic"
    }
}