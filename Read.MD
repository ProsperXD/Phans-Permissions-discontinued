```txt
    Look at Server/test.lua for examples on how to Use This
```
```diff
    Commands('refreshdapi')
```


added:
    while not exports['Phans-Permissions']:IsPermsLoaded(player) do
        print("AJ")
        Wait(0)
    end