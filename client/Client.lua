local playerData = {}

local function HasRole(roleId)
    local playerId = PlayerId()
    local roleIds = playerData.RoleIds
    if roleIds then
        for _, roleIdInData in pairs(roleIds) do
            if tonumber(roleIdInData) == tonumber(roleId) then
                return true
            end
        end
    end
    return false
end

local ReturnRoles = function()
    local playerId = PlayerId()
    local roleIds = playerData.RoleIds
    local rolesFound = {}
    if roleIds then
        for _, roleIdInData in pairs(roleIds) do
            table.insert(rolesFound, roleIdInData)
        end
    end

    return rolesFound
end

RegisterNetEvent('Phans:ReturnData', function(data) playerData = data end)

AddEventHandler('onClientResourceStart', function(resourceName)
	if resourceName ~= GetCurrentResourceName() then return end
    TriggerServerEvent('Phans:SendPerms')
end)
---@param roleid | Role That Goes for (HasRole)
exports('GetPlayerData', function(roleid)
    local Data = {
        HasRole = HasRole(roleid) or false,
        Roles = ReturnRoles() or 0,
        Avatar = playerData.AvatarURL or 'https://i.pinimg.com/originals/c6/16/fc/c616fca52915df67140d1ce0e002ce5a.gif',
        Banner = playerData.Banner or 'https://i.pinimg.com/originals/c6/16/fc/c616fca52915df67140d1ce0e002ce5a.gif',
        Username = playerData.Username or 'Not Found',
        Discord = playerData.discord or 0,
    }
    return Data
end)
