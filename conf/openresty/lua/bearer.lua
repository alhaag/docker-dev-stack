--[[
 Access token validation middleware (JWT - Json Web Token).

 Handling HTTP requests for token validation and verify privilege to access
 resource.

 Token example:
   HEADER
   {
     "typ": "JWT",
     "alg": "HS256"
   }
   PAYLOAD
   {
     "iss": "dsc-api-projectname",
     "iat": 1488219526,
     "exp": 1488219856,
     "user": "58a62b4f81393ae29b39017d",
     "privileges": ["admin"]
   }
   VERIFY SIGNATURE
   {
      HMACSHA256(
        base64UrlEncode(header) + "." +
        base64UrlEncode(payload),
        secret
      )
   }
  @author André Luiz Haag <andreluizhaag@gmail.com>
  @author Diego Wagner    <diegowagner4@gmail.com>

  @see https://tools.ietf.org/html/rfc7519
--]]

local jwt = require "resty.jwt"
local cjson = require "cjson"

-- first try to find JWT token as url parameter e.g. ?token=BLAH
local token = ngx.var.arg_token

-- next try to find JWT token as Cookie e.g. token=BLAH
if token == nil then
    token = ngx.var.cookie_token
end

-- try to find JWT token in Authorization header Bearer string
if token == nil then
    local auth_header = ngx.var.http_Authorization
    if auth_header then
        _, _, token = string.find(auth_header, "Bearer%s+(.+)")
    end
end

-- finally, if still no JWT token, kick out an error and exit
if token == nil then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say('{"error": "Proxy: missing JWT token or Authorization header"}')
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- validate any specific claims you need here
-- https://github.com/SkyLothar/lua-resty-jwt#jwt-validators
local validators = require "resty.jwt-validators"
local claim_spec = {
    --[[ __jwt = function(val, claim, jwt_json)
        for _, value in pairs(cjson.decode(val.payload.privileges)) do
            if value == "admin" then return true end
        end
        error("Need privilege 'admin'")
    end --]]
    -- validators.set_system_leeway(15), -- time in seconds
    exp = validators.is_not_expired(),
    iat = validators.is_not_before(),
    -- iss = validators.opt_matches("^http[s]?://yourdomain.auth0.com/$"),
    -- sub = validators.opt_matches("^[0-9]+$"),
    -- name = validators.equals_any_of({ "John Doe", "Mallory", "Alice", "Bob" }),
}

-- make sure to set and put "env JWT_SECRET;" in nginx.conf
local jwt_secret = os.getenv("JWT_SECRET")
local jwt_obj = jwt:verify(jwt_secret, token, claim_spec)
if not jwt_obj["verified"] then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.log(ngx.WARN, jwt_obj.reason)
    ngx.log(ngx.WARN, token)
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say('{"error": "Proxy: ' .. jwt_obj.reason .. '"}')
    -- {"error": "Proxy: "'iat' claim not valid until Thu, 14 Aug 49119 09:15:10 GMT"}
    -- ngx.say("{\"error\": \"Proxy: " .. jwt_obj.reason .. "\", \"secret\": \"" .. jwt_secret .. "\", \"token\": \"" .. token .. "\" }")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- optionally set Authorization header Bearer token style regardless of how token received
-- if you want to forward it by setting your nginx.conf something like:
--     proxy_set_header Authorization $http_authorization;`
-- ngx.req.set_header("Authorization", "Bearer " .. token)