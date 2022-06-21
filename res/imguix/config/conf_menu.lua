return {
    menu_main = {
        --file
        {
            title = "file",
            ln_key = "file",
            children = {
                {
                    title = "new",
                    ln_key = "new",

                },
                {
                    title = "proj",
                    ln_key = "proj",
                },
                {
                    title = "import",
                    ln_key = "import",

                },
                {
                    title = "export",
                    ln_key = "export",

                },
                {
                    title = "save",
                    ln_key = "save",

                },
                {
                    title = "quit",
                    ln_key = "quit",

                },
            }
        },
        --view
        {
            title = "view",
            ln_key = "view",
            children = {
                {
                    title = "show_treenodes",
                    ln_key = "show_treenodes",
                },
                {
                    title = "show_node_info",
                    ln_key = "show_node_info",
                }
            }
        },
        {
            title = "node",
            ln_key = "node",
            children = {
                {
                    ln_key = "add_node",
                    title = "add_node"
                },
                {
                    ln_key = "fetch_node",
                    title = "fetch_node"
                },
            }
        }

        --debug
        --node

    },
}