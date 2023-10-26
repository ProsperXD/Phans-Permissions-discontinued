ServerApi = {}
ServerApi.Data = {
    ServerId = '1155937996999249920',
    Debugs = true, --Prints errors etc in console
    Token = 'MTE1Mzk0NTEwMTY1NjEzNzc2OQ.GGbsZG.CCfDaoprz__wOjaSQlqCYYlKTSkldi_kZWG0Lo',
    chatMessage = function(user, title, msg)
        TriggerClientEvent('chat:addMessage', user, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 1); border-radius: 10px;"><i class="fas fa-exclamation-triangle"></i> '..title..' {1}<br></div>',
            args = { user, msg }
        })
    end,
}
return ServerApi