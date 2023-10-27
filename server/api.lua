if not ServerApi then Debug("ERROR CONFIG NOT FOUND") return end
if (not ServerApi.Data.Token or type(ServerApi.Data.Token) ~= 'string') then Debug("ERROR TOKEN NOT FOUND") return end

---@type UserData
---@class UserData
---@field UserData

local UserData = {}
local Cooldowns = {}
local UserMetaTable = {}

function Debug(Type, Error)
    if not ServerApi.Data.Debugs then return end
    if Error then
        print(string.format("^1 Phans: %s (Error: %s)", Type, Error))
    else
        print(string.format("^1 Phans: %s", Type))
    end
end

function UserMetaTable:RequestRoles()
    if not self.discord then
        return "User Discord Not Found"
    end
    local currentTime = GetGameTimer()
    if Cooldowns[self.source] and Cooldowns[self.source] > currentTime then
        local remainingTime = (Cooldowns[self.source] - currentTime) / 1000
        ServerApi.Data.chatMessage(self.source, '[Phans Api]', string.format("Must Wait %s Seconds Before Requesting Api Again", math.floor(remainingTime)))
        return
    end
    PerformHttpRequest(string.format("https://discord.com/api/guilds/%s/members/%s", ServerApi.Data.ServerId, self.discord), function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local responseData = json.decode(resultData)
            if responseData and next(responseData.roles) ~= 0 then
                self.RoleIds = responseData.roles
                self.Username = responseData.user.username
                self.AvatarURL = "https://cdn.discordapp.com/avatars/" .. responseData.user.id .. "/" .. responseData.user.avatar .. ".gif"
                self.Banner = "https://cdn.discordapp.com/banners/" .. responseData.user.id .. "/" .. responseData.user.banner.. ".gif"
                print(string.format("Found Roles List for %s (%s): %s", GetPlayerName(self.source), self.source, json.encode(self.RoleIds)))
                TriggerClientEvent('Phans:ReturnData', self.source, self,ServerApi.Data.Debugs)
            else
                print("No roles found for user", self.source)
                TriggerClientEvent('Phans:ReturnData', self.source, self,ServerApi.Data.Debugs)
            end
        else
            TriggerClientEvent('Phans:ReturnData', self.source, self,ServerApi.Data.Debugs)
        end
        Cooldowns[self.source] = currentTime + ServerApi.Data.RefreshTime
    end, 'GET', '', {
        ["Content-Type"] = "application/json",
        ["Authorization"] = string.format("Bot %s", ServerApi.Data.Token),
    })
end

---@param self | Source of User
UserMetaTable.InitUserData = function(self)
    for _, id in pairs(GetPlayerIdentifiers(self.source)) do
        if string.match(id, 'discord:') then
            self.discord = string.gsub(id, 'discord:', "")
            break
        end
    end
    self:RequestRoles()
end

---@param self | Source of User
---@param roleid | Role That Checks
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
        UserData[self]:RequestRoles()
    end
end)

---@param player | Source of User
---@param roleid | Role That Goes for (HasRole)
exports('GetPlayerData', function(player, roleid)
    local Data = {
        Roles = UserData[player]:GetRoleList(),
        HasRole = UserData[player]:CheckIfHasRole(roleid),
        Avatar = UserData[player]:GetAvatar(player),
        Banner = UserData[player]:GetBanner(player)
    }
    return Data
end)