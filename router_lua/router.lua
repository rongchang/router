local key = ngx.var.model_name

local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000) -- 1 second
local ok, err = red:connect("127.0.0.1", 6379)

ngx.log(ngx.ERR, "test-----------", ngx.shared.path:get("path"))
ngx.log(ngx.ERR, "model_name: ", key, ";  rest_path: ", ngx.var.rest_path)

if not ok then
  ngx.log(ngx.ERR, "failed to connect to redis: ", err)
  return ngx.exit(500)
end

local host, err = red:get(key)
-- local host, err = red:get("host")


if not host then
  ngx.log(ngx.ERR, "failed to get redis key: ", err)
  return ngx.exit(500)
end

if host == ngx.null then
  ngx.log(ngx.ERR, "no host found for key ", key)
  return ngx.exit(400)
end

-- ngx.var.target = host .. "/" .. ngx.var.model_name .. ngx.var.rest_path
-- if ngx.var.args then
--   ngx.var.target = ngx.var.target .. "?" .. ngx.var.args
-- end

ngx.var.target = host .. ngx.var.request_uri

ngx.log(ngx.ERR, "final_path: ", ngx.var.target)