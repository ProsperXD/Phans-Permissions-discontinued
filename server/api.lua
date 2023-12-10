if not ServerApi then Debug("ERROR CONFIG NOT FOUND") return end
if (not ServerApi.Data.Token or type(ServerApi.Data.Token) ~= 'string') then Debug("ERROR TOKEN NOT FOUND") return end
CreateThread(function() if (GetCurrentResourceName() ~= "Phans-Permissions") then Debug("Error Some Scripts Prosper Releases Might Not Work If This Is Renammed",true) end  end)

local UserData = {}
local Cooldowns = {}
local UserMetaTable = {}
local ServerData = {}

---@param type string - Message To Print
---@param Error string - Error print
function Debug(Type, Error)
    if not ServerApi.Data.Debugs then return end
    if Error then
        print(string.format("^1 Phans: %s (Error: %s)", Type, Error))
    else
        print(string.format("^1 Phans: %s", Type))
    end
end

function UserMetaTable:RequestUserData()
    ServerData = {}
    if not self.discord then
        return "User Discord Not Found"
    end
    local currentTime = GetGameTimer()
    if Cooldowns[self.source] and Cooldowns[self.source] > currentTime then
        local remainingTime = (Cooldowns[self.source] - currentTime) / 1000
        ServerApi.Data.chatMessage(self.source, '[Phans Api]', string.format("Must Wait %s Seconds Before Requesting Api Again", math.floor(remainingTime)))
        return
    end
    local errorCode, responseData = exports[GetCurrentResourceName()]:RequestApi('GET', string.format("guilds/%s/members/%s", ServerApi.Data.ServerId, self.discord), {})
    local errorCode2, responseData2 = exports[GetCurrentResourceName()]:RequestApi("GET", string.format("guilds/%s",ServerApi.Data.ServerId),{})
    table.insert(ServerData,{
        RoleCount = #json.decode(responseData2).roles or 0,
        ServerName = json.decode(responseData2).name or 'Not Found',
        ServerIcon = string.format('https://cdn.discordapp.com/icons/%s/%s%s',ServerApi.Data.ServerId,json.decode(responseData2).icon,CheckGifOrPng(json.decode(responseData2).icon)) or 'Not Found'
    })
    if responseData then
        local responseDataTable = json.decode(responseData)
        if responseDataTable and next(responseDataTable.roles) ~= 0 then
            if not responseDataTable.user.banner then
                responseDataTable.user.banner = ''
            end
            if not responseDataTable.user.AvatarURL then
                responseDataTable.user.AvatarURL = ''
            end
            self.RoleIds = responseDataTable.roles
            self.Username = responseDataTable.user.username
            self.DiscordID = responseDataTable.user.id
            self.Banner = string.format('https://cdn.discordapp.com/banners/%s/%s%s',self.DiscordID,responseDataTable.user.banner,CheckGifOrPng(responseDataTable.user.banner))
            self.AvatarURL = string.format('https://cdn.discordapp.com/avatars/%s/%s%s',self.DiscordID,responseDataTable.user.avatar,CheckGifOrPng(responseDataTable.user.avatar))
            print(string.format("Found Roles List for %s (%s): %s", GetPlayerName(self.source), self.source, json.encode(self.RoleIds)))
            TriggerClientEvent('Phans:ReturnData', self.source, self, ServerApi.Data.Debugs)
        else
            print("No roles found for user", self.source)
            TriggerClientEvent('Phans:ReturnData', self.source, self, ServerApi.Data.Debugs)
        end
    else
        print("Error in API request for user", self.source)
        TriggerClientEvent('Phans:ReturnData', self.source, self, ServerApi.Data.Debugs)
    end
    Cooldowns[self.source] = currentTime + ServerApi.Data.RefreshTime
end

---@param self | Source of User
UserMetaTable.InitUserData = function(self)
    for _, id in pairs(GetPlayerIdentifiers(self.source)) do
        if string.match(id, 'discord:') then
            self.discord = string.gsub(id, 'discord:', "")
            break
        end
    end
    self:RequestUserData()
end

---@param self | Source of User
UserMetaTable.ReturnDiscordId = function(self)
    if self.DiscordID then 
        return self.DiscordID
    else
        return 0
    end
end

---@param self | Source of User
UserMetaTable.ReturnDiscordName = function(self)
    if self.Username then
        return self.Username
    else return 'not found'
    end
end

---@param self | Source of User
---@param roleid | Role That Checks
---@param return boolean
UserMetaTable.CheckIfHasRole = function(self, roleid)
    if self.RoleIds then
        for k,v in ipairs(self.RoleIds) do
            if tonumber(v) == tonumber(roleid) then
                return true
            end
        end
    end
    return false
end

---@param hash string&Number - Data To Return
---@param return string
function CheckGifOrPng(hash)
    if not hash then return '.png' end
    if (hash:sub(1, 1) and hash:sub(2, 2) == "_") then
        return '.gif'
    else
        return '.png'
    end
end

---@param self | Source of User
UserMetaTable.GetAvatar = function(self)
    if self.AvatarURL then return self.AvatarURL else return 'https://media3.giphy.com/media/k2Da0Uzaxo9xe/giphy.gif' end
end

---@param self | Source of User
UserMetaTable.GetRoleList = function(self)
    if self.RoleIds then return json.encode(self.RoleIds) end  return false
end

---@param self | Source of User
UserMetaTable.GetBanner = function(self)
    if self.Banner then return self.Banner else return 'https://media3.giphy.com/media/k2Da0Uzaxo9xe/giphy.gif' end
end

---@param source | Source of User
local function CreateUser(source)
    local user = {
        source = source,
        discord = nil,
        RoleIds = nil,
    }
    setmetatable(user, { __index = UserMetaTable })
    return user
end

---@param Type | Message That is printed along with The Debug.
RegisterServerEvent('Phans:SendPerms', function()
    local source = source
    local user = CreateUser(source)
    UserData[source] = user
    user:InitUserData()
end)

---@param self | Source of User
RegisterCommand('refreshdapi', function(self)
    if UserData[self] then
        UserData[self]:RequestUserData()
    end
end)

---@param player | Source of User
---@param roleid | Role That Goes for (HasRole)
---@return Table - Returns Table With Data
exports('GetPlayerData', function(player, roleid)
    local Data = {
        Roles = UserData[player]:GetRoleList(),
        DiscordID = UserData[player]:ReturnDiscordId(),
        DiscordName = UserData[player]:ReturnDiscordName(),
        HasRole = UserData[player]:CheckIfHasRole(roleid),
        Avatar = UserData[player]:GetAvatar(player),
        Banner = UserData[player]:GetBanner(player),
        Server = {
            RoleCount = ServerData.RoleCount,
            ServerName = ServerData.ServerName,
            ServerIcon = ServerData.ServerIcon,
        }
    }
    return Data
end)