local key = ngx.var.model_name

if key then

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
            ngx.log(ngx.ERR, "fail, model not found: "..key)
            ngx.say("fail, model not found: "..key)
            return
        else
            --            require 'reset_model_path'
            local mysql = require "resty.mysql"
            local db, err = mysql:new()
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

            path = model_path:get(key)
            --            ngx.log(ngx.ERR, "78787878787: "..path)
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
        ngx.log(ngx.ERR, "fail, model not found: "..key)
        ngx.say("fail, model not found: "..key)
    end
else
    ngx.log(ngx.ERR, "no model name given")
    ngx.say("no model name given")
end
