RegisterCommand('getavatarcl', function()
    local data = exports[GetCurrentResourceName()]:phans_api()
    local avatar = data.Avatar
    if avatar then
        print(string.format("Returned Avatar: %s",avatar))
    else
        print("No Avatar Found. Not Even Defualy one.")
    end
end)

RegisterCommand('getusernamecl', function()
    local playerData = exports[GetCurrentResourceName()]:phans_api()
    print("Username: " .. playerData.Username)
end)

RegisterCommand('getbannercl', function()
    local player = tonumber(source)
    local data = exports[GetCurrentResourceName()]:phans_api(player)
    local banner = data.Banner
    print(banner)
end)

RegisterCommand('getdiscordidcl', function()
    local playerData = exports[GetCurrentResourceName()]:phans_api()
    print("ID: " .. playerData.Discord)
end)