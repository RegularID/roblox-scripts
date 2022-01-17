local lex_str = _G.require('lexer')

local type_styles = _G.require('config/styles')
local tag_table = _G.require('config/tagtable')

local function get_style(type, global)
    local global_table = global or { }
    local internal_table = type_styles
    return global_table[type] or internal_table[type] or internal_table.default
end

local function escape_string(input)
    if not input then
        return input
    end
    local esc_seq = { lt = '<', gt = '>', quot = '"', apos = "'", amp = '&' }
    local escape_amp = '&amp'
    local pre_fix = '&'

    for seq_name, seq in pairs(esc_seq) do
        --[[ Remove any literal escapes in string ]]
        local exist_seq = pre_fix .. seq_name .. ';'
        local replace_seq = string.format('%s;%s;', escape_amp, seq_name)
        input = string.gsub(input, exist_seq, replace_seq)

        --[[ Actually ecape string ]]
        if seq ~= '&' then -- avoid re-escaping ampersand
            input = string.gsub(input, seq, exist_seq)
        end
    end

    return input
end

local function handle_tag_creation(internal, apply)
    local tag_node = ''
    local closing_tags = {}

    local add_str = function (str, close)
        tag_node = tag_node .. (str or '')
        if close then
            table.insert(closing_tags, close)
        end
    end

    local font_attribs_tab = apply.font -- font tag must be handled first
    local font_attribs_str = ''
    local applied_font = false
    
    for attr_name, attr_value in pairs(font_attribs_tab) do
        font_attribs_str = font_attribs_str .. (' %s="%s"'):format(attr_name, attr_value)
    end

    if font_attribs_str ~= '' then
        applied_font = true
        add_str(string.format('<font%s>', font_attribs_str))
    end

    apply.font = nil -- avoid re-adding tag

    for tag_name, tag_value in pairs(apply) do
        local rblx_tag_name = tag_table[tag_name]
        local close_tag = string.format('</%s>', rblx_tag_name)

        if tag_value then
            add_str(string.format('<%s>', rblx_tag_name), close_tag)
        end
    end

    internal = escape_string(internal)

    add_str(internal)
    
    if applied_font then
        add_str(nil, '</font>') -- close font tag
    end

    for _, close_tag in pairs(closing_tags) do
        add_str(close_tag) -- close other tags
    end

    return tag_node ~= '' and tag_node or internal
end

local function create_tag_node(type, value, global_styles)
    local type_style = get_style(type, global_styles)
    local default_style = type_styles.default
    local attributes = {
        font = { color = type_style.color, size = type_style.size, face = type_style.font },
        bold = type_style.bold or default_style.bold,
        italic = type_style.italic or default_style.italic,
        underline = type_style.underline or default_style.underline,
        strikethrough = type_style.strikethrough or default_style.strikethrough,
        smallcaps = type_style.smallcaps or default_style.smallcaps
    }

    return handle_tag_creation(value, attributes)
end

local function parse_tree(self, tree, style)
    local node_tree = { }

    for index, token in pairs(tree) do
        local tag_node = create_tag_node(token.type, token.value, style)
        table.insert(node_tree, tag_node)
     end
    
    return table.concat(node_tree, '')
end

function highlight(self, input, style)
    local tt_table = lex_str(input)
    
    if tt_table then
        return parse_tree(self, tt_table.lex_tree, style)
    end
    
    return nil
end

return highlight