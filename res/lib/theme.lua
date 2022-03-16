local theme = {
    _cur = "default"
}

function theme.texture(v)
    return string.format("texture/theme/%s/%s", theme._cur, v)
end

return theme