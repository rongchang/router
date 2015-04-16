local mysql = require "resty.mysql"
local db, err = mysql:new()
local model_path = ngx.shared.model_path

local res, err, errno, sqlstate = db:query("select * from model_paths")
if not res then
    ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    return
end

model_path.flush_all()

for i,v in pairs(res) do
    model_path:set(v.model_name,v.host..v.path)
end

model_path:set("is_initialized", true)