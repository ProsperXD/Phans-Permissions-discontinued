---@param source | player source
RegisterCommand('hasrole', function(source)
    local role = 1155938745124667413
    local player = tonumber(source)
    local hasrole = exports[GetCurrentResourceName()]:phans_api(player,role)
    if UserData[player] then
        if hasrole then
            print("YEA")
        else
            print("NO")
        end
    else
        print("No data")
    end
end)

---@param source | player source
RegisterCommand('dataGetRoles', function(source)
    local player = tonumber(source)
    if UserData[player] then
        local data = exports[GetCurrentResourceName()]:phans_api(player)
        local roles = json.decode(data.Roles)
        for _, role in pairs(roles) do
            print("Role Id: " .. role)
        end
    end
end)

---@param source | player source
RegisterCommand('getavatar', function(source)
    local player = tonumber(source)
    local data = exports[GetCurrentResourceName()]:phans_api(player)
    local avatar = data.Avatar
    if avatar then
        print(string.format("Returned Avatar: %s",avatar))
    else
        print("No Avatar Found. Not Even Defualy one.")
    end
end)

---@param source | player source
RegisterCommand('getbanner', function(source)
    local player = tonumber(source)
    local data = exports[GetCurrentResourceName()]:phans_api(player)
    local banner = data.Banner
    print(banner)
end)