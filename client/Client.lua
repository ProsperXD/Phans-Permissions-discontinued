local DiscordInfo = {}

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(0)
    end
    TriggerServerEvent('Phans:SendPerms')
end)

---@param data | returns player data
---@param debug | Boolean
RegisterNetEvent('Phans:ReturnData', function(data, debug)
    if debug then
        print(json.encode(data))
    end
    if type(data) == 'table' then
        DiscordInfo = {
            Avatar = data.AvatarURL,
            Username = data.Username,
            Banner = data.Banner,
            Discord = data.discord,
        }
    else
    end
end)

exports('phans_api', function()
    local Data = {
        Discord = DiscordInfo.Discord,
        Username = DiscordInfo.Username,
        Avatar = DiscordInfo.Avatar,
        Banner = DiscordInfo.Banner
    }
    return Data
end)