---@param webhook string - webhook
---@param title string - title
---@param description string - description
local function DiscordLogs(webhook, title, description)
    local embedData = {
        color = 16711680,
        type = "rich",
        title = title,
        description = description,
        footer = {
            text = "MostWanted RP © 2023",
            icon_url = "https://cdn.discordapp.com/attachments/1152154696304304198/1154462827684319373/PFP_-_Phans_Development.png?ex=6543d64b&is=6531614b&hm=6c67d9c3c1d7849987102a4b14dfa6645d6ed4f1341054a26c09e2cd81d9b32f&"
        },
        thumbnail = {
            url = "https://cdn.discordapp.com/attachments/1152154696304304198/1154462827684319373/PFP_-_Phans_Development.png?ex=6543d64b&is=6531614b&hm=6c67d9c3c1d7849987102a4b14dfa6645d6ed4f1341054a26c09e2cd81d9b32f&"
        }
    }
    local Error, request = exports[GetCurrentResourceName()]:RequestApi('POST', webhook, json.encode({
        username = 'Phans Logs\'s',
        avatar_url = 'https://cdn.discordapp.com/attachments/1168331951552344125/1174528296835354624/DISCORD_PFP.png?ex=6567ebb7&is=655576b7&hm=4892a7155eedd00ef620f164ac8600a515fe02e8b82e0c1f1e7cdd9e019af2bb&',
        embeds = {embedData}
    }))
end

---@param method string - Method To Use EITHER GET OR PATCH
---@param endpoint string - Endpoint To Request
---@param jsondata table - data
local function RequestApi(method, endpoint, jsondata)
    local formattedToken = string.format("Bot %s", ServerApi.Data.Token)
    local formattedEndpoint = "https://discord.com/api/" .. endpoint
    local data, result = nil, nil
    PerformHttpRequest(formattedEndpoint, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            print(string.format("API Request successful for %s", endpoint))
        else
            print(string.format("Error in API request for %s (Error Code: %d)", endpoint, errorCode))
            if resultData then
                print("Error response data:", json.encode(resultData))
            end
        end
        result = { errorCode = errorCode, resultData = resultData }
    end, method, #jsondata > 0 and jsondata or "", {
        ["Content-Type"] = "application/json",
        ["Authorization"] = formattedToken,
        ['X-Audit-Log-Reason'] = 'Phans Development',
    })
    while result == nil do
        Wait(0)
    end
    return result.errorCode, result.resultData
end

--#Exports
exports('DiscordLogs', DiscordLogs)
exports('RequestApi', RequestApi)