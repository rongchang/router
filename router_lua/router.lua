local key = ngx.var.model_name
local model_path = ngx.shared.model_path

--local redis = require "resty.redis"
--local red = redis:new()
--red:set_timeout(1000) -- 1 second
--local ok, err = red:connect("127.0.0.1", 6379)
--
--ngx.log(ngx.ERR, "test-----------", ngx.shared.path:get("path"))
--ngx.log(ngx.ERR, "model_name: ", key, ";  rest_path: ", ngx.var.rest_path)
--
--if not ok then
--  ngx.log(ngx.ERR, "failed to connect to redis: ", err)
--  return ngx.exit(500)
--end

local path = model_path:get(key)


if not path then
    if model_path:get("is_initialized") then
        ngx.log("fail, model not found: "..key)
        ngx.say("fail, model not found: "..key)
        return
    else
        require 'reset_model_path'
        local path = model_path:get(key)
    end
end

-- ngx.var.target = host .. "/" .. ngx.var.model_name .. ngx.var.rest_path
-- if ngx.var.args then
--   ngx.var.target = ngx.var.target .. "?" .. ngx.var.args
-- end

if path then
    ngx.var.target = path .. ngx.var.request_uri
    ngx.log(ngx.ERR, "final_path: ", ngx.var.target)
    return
else
    ngx.log("fail, model not found: "..key)
    ngx.say("fail, model not found: "..key)
end

