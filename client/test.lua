RegisterCommand('hasrolecl', function(source)
    print(exports[GetCurrentResourceName()]:GetPlayerData(1155938745124667413).HasRole) 
end)

RegisterCommand('returnrolescl', function(source)
    local roles = exports[GetCurrentResourceName()]:GetPlayerData().Roles
    for _, role in pairs(roles) do
        print(role)
    end
end)

RegisterCommand('datacl', function()
    print(exports[GetCurrentResourceName()]:GetPlayerData().Avatar)
    print(exports[GetCurrentResourceName()]:GetPlayerData().Banner)
    print(exports[GetCurrentResourceName()]:GetPlayerData().Username)
    print(exports[GetCurrentResourceName()]:GetPlayerData().Discord)
end)
RegisterCommand('IsPermsLoadedcl', function()
    while not exports[GetCurrentResourceName()]:IsPermsLoaded(source) do
        print("LOADING")
    end
    print('yea')
end)