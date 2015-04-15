local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000) -- 1 second
local ok, err = red:connect("127.0.0.1", 6379)

if not ok then
  return false
else
  return red
end