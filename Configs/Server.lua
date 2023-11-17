ServerApi = {}
ServerApi.Data = {
    ServerId = '919834361447186462',
    Debugs = true, --Prints errors etc in console
    RefreshTime = 120000, --Milliseconds
    Token = 'TOKEN',
    chatMessage = function(user, title, msg)
        TriggerClientEvent('chat:addMessage', user, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 1); border-radius: 10px;">'..title..' {1}<br></div>',
            args = { user, msg }
        })
    end,
}
return ServerApi