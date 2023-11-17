---@param source | player source
RegisterCommand('hasrolesv', function(source)
    local role = 1155938745124667413
    local player = tonumber(source)
    local Api = exports[GetCurrentResourceName()]:GetPlayerData(player,role)
    local HasRole = Api.HasRole
    if HasRole then
        print("Yea")
    else
        print("No!")
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
RegisterCommand('getbannersv', function(source)
    local player = tonumber(source)
    local data = exports[GetCurrentResourceName()]:GetPlayerData(player)
    local banner = data.Banner
    print(string.format("Returned Banner: %s",banner))
end)

RegisterCommand('GetDiscordsv', function(source)
    print(exports[GetCurrentResourceName()]:GetPlayerData(source).DiscordName)
    print(exports[GetCurrentResourceName()]:GetPlayerData(source).DiscordID)
end)

RegisterCommand('IsPermsLoadedsv', function()
    while not exports[GetCurrentResourceName()]:IsPermsLoaded(source) do
        print("LOADING")
    end
    print('yea')
end)

RegisterCommand('Request_Patch_SetNickNAme', function(source)
    local discordId = exports[GetCurrentResourceName()]:GetPlayerData(source).DiscordID
    local guildId = ServerApi.Data.ServerId
    if discordId then
        local name = "Testing New Name"
        local endpoint = ("guilds/%s/members/%s"):format(guildId, discordId)
        local Error,member = exports[GetCurrentResourceName()]:RequestApi("PATCH", endpoint, json.encode({nick = tostring(name)}), "Phans Development")
        if Error ~= 204 and Error ~= 200 then
            print('An Error Code Was Recieved, Please Try Again Later Or Contact Support')
        end
    end
end)

RegisterCommand('sendlog', function()
    exports['Phans-Permissions']:DiscordLogs('webhooks/1174927032367460452/wCCkybboX5wVVonvTkebIssXTdUkFpJImlV7yMXSQ4W3FJqZ_K4ma77SMYkXdR1L6DPl', 'Title', ' Description .gg/phans #Ad')
end)