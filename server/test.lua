---@param source | player source
RegisterCommand('hasrolesv', function(source)
    local role = 1155938745124667413
    local player = tonumber(source)
    local Api = exports[GetCurrentResourceName()]:GetPlayerData(player,role)
    local HasRole = Api.HasRole
        if HasRole then
            print("YEA")
        else
            print("NO")
        end
end)

---@param source | player source
RegisterCommand('dataGetRolessv', function(source)
    local player = tonumber(source)
        local data = exports[GetCurrentResourceName()]:GetPlayerData(player)
        local roles = json.decode(data.Roles)
        for _, role in pairs(roles) do
            print("Role Id: " .. role)
        end
end)

---@param source | player source
RegisterCommand('getavatarsv', function(source)
    local player = tonumber(source)
    local data = exports[GetCurrentResourceName()]:GetPlayerData(player)
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
    local data = exports[GetCurrentResourceName()]:GetPlayerData(player)
    local banner = data.Banner
    print(string.format("Returned Banner: %s",banner))
end)