local mysql = require "resty.mysql"
local db, err = mysql:new()
local model_path = ngx.shared.model_path
local const = ngx.shared.const

local ok, err, errno, sqlstate = db:connect{

    host = const:get("mysql_host"),
    port = const:get("mysql_port"),
    database = const:get("mysql_database"),
    user = const:get("mysql_user"),
    password = const:get("mysql_password"),
    max_packet_size = const:get("mysql_max_packet_size") }

if not ok then
    ngx.say("failed to connect: ", err, ": ", errno, " ", sqlstate)
    return
end

local res, err, errno, sqlstate = db:query("select * from model_paths")
if not res then
    ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    return
end

model_path:flush_all()

for i,v in pairs(res) do
    model_path:set(v.model_name,v.host..v.path)
end

model_path:set("is_initialized", true)
ngx.say("success")