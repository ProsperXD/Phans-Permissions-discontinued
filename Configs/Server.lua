ServerApi = {}
ServerApi.Data = {
    ServerId = 'YOURGUILDID',
    Debugs = true, --Prints errors etc in console
    Token = 'YOURTOKEN',
    chatMessage = function(user, title, msg)
        TriggerClientEvent('chat:addMessage', user, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 1); border-radius: 10px;"><i class="fas fa-exclamation-triangle"></i> '..title..' {1}<br></div>',
            args = { user, msg }
        })
    end,
}
return ServerApi