--local cjson = require "cjson"
local args = ngx.req.get_uri_args()
local const = ngx.shared.const
local model_path = ngx.shared.model_path

if args.model_name and args.server_name and args.host and args.path then

    --if model_path:get(arg.modle_name) ==

    local mysql = require "resty.mysql"
    local db, err = mysql:new()
    if not db then
        ngx.say("failed to instantiate mysql: ", err)
        return
    end

    db:set_timeout(1000) -- 1 sec

    -- or connect to a unix domain socket file listened
    -- by a mysql server:
    --     local ok, err, errno, sqlstate =
    --           db:connect{
    --              path = "/path/to/mysql.sock",
    --              database = "ngx_test",
    --              user = "ngx_test",
    --              password = "ngx_test" }

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

    local res, err, errno, sqlstate =
        db:query("INSERT INTO model_paths (model_name, server_name, host, path, created_at, updated_at) VALUES (".."'"..args.model_name.."','"..args.server_name.."','"..args.host.."','"..args.path.."','"..ngx.localtime().."','"..ngx.localtime().."') ON DUPLICATE KEY UPDATE server_name='"..args.server_name.."', host='"..args.host.."', path='"..args.path.."', updated_at='"..ngx.localtime().."'")
    if not res then
        ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
        return
    else
        model_path:set(args.model_name, args.host..args.path)
    end

    ngx.say("success")

else
    ngx.say("model_name, server_name, host and path must be present all together")
    return
end