return {
    --================================
    --condition
    --================================
    {
        name = "is_crossroads", 
        type = "conditionals",
        desc = "是否在路口",
        supposeType = "demo_traffic"
    },
    {
        name = "is_light_signal", 
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
        name  = "is_front_car", 
        type = "conditionals", 
        desc = "是否有前车",
        supposeType = "demo_traffic"
    }, 
    --================================
    --action
    --================================
    {
        name = "do_car_turnleft",
        type = "action", 
        desc ="左转", 
        supposeType = "demo_traffic"
    },
    {
        name = "do_car_turnright",
        type = "action", 
        desc = "右转", 
        supposeType = "demo_traffic"
    }
}