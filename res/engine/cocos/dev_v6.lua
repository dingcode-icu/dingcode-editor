return {
    --================================
    --condition
    --================================
    {
        name = "is in touch",
        type = "conditionals",
        desc = "是否在点击范围内",
        supposeType = "dev_v6"
    },
    --================================
    --action
    --================================
    {
        name = "new fire bullet",
        type = "action", 
        desc ="创建一个新的子弹",
        supposeType = "dev_v6",
        input = {
            prefab= {

            }
        }
    },
    {
        name = "rotate to touch",
        type = "action",
        desc = "转向到点击的方向",
        supposeType = "dev_v6",
    },
    {
        name = "move forward2d",
        type = "action",
        desc = "向转向的方向移动",
        supposeType = "dev_v6",
        input ={
            time = {
                direct = "left",
                key = "input_float",
                desc ="time"
            },
            dis = {
                direct = "left",
                key = "input_float",
                desc = "dis"
            }
        }
    }
}