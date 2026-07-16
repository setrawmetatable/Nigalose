local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/setrawmetatable/Scripts/refs/heads/main/Notification"))()

local Api = {
    Players = game:GetService("Players"),
    Run = game:GetService("RunService"),
    Uis = game:GetService("UserInputService"),
    Vim = game:GetService("VirtualInputManager"),
    Tween = game:GetService("TweenService"),
    Core = game:GetService("CoreGui"),
    Light = game:GetService("Lighting"),
    Http = game:GetService("HttpService"),
    Market = game:GetService("MarketplaceService"),
    Rep = game:GetService("ReplicatedStorage"),
    Text = game:GetService("TextService"),
    
    Player = game:GetService("Players").LocalPlayer,
    Name = game:GetService("Players").LocalPlayer.Name,
    Camera = workspace.CurrentCamera,
    PlaceId = game.PlaceId,
    
    Mouse = game:GetService("Players").LocalPlayer:GetMouse(),
    Screen = Instance.new("ScreenGui"),

    Mobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").MouseEnabled,
    Executor = identifyexecutor() or getexecutorname() or "Unknown",

}  

local Function = {
    {name = "Drawing", present = type(Drawing) == "table" or type(Drawing) == "userdata"},
    {name = "hookmetamethod", present = type(hookmetamethod) == "function"},
    {name = "getnamecallmethod", present = type(getnamecallmethod) == "function"},
    {name = "checkcaller", present = type(checkcaller) == "function"},
    {name = "getgc", present = type(getgc) == "function" and pcall(getgc) and type(getgc()) == "table"},
}

function Api:Kick(text)
    Api.Player:Kick(text)
    return
end

function Api:CheckSupport()
    for i, sup in ipairs(Function) do
        if not sup.present then
            Api:Kick("[Executor unsupported] " .. Api.executor .. " is not supported")
            return false
        end
    end
    return true
end

function Api:Random()
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local name = ""
	local lenght = math.random(5, 10)
	for i = 1, lenght do 
		local rand = math.random(1, #chars)
		name = name .. string.sub(chars, rand, rand)
	end
	return name
end

function Api:Notification(text, time)
    Notification:Notification(text, time, Color3.fromRGB(255, 255, 255))
end

function Api:CheckDevice()
    if Api.mobile then
        Api:Kick("[Device unsupported] Mobile is not supported")
        return true
    end
    return false
end

function Api:PrintNiga()
    print([[
             _   ___             __              
                        / | / (_)___ _____ _/ /___  ________ 
                       /  |/ / / __ `/ __ `/ / __ \/ ___/ _ \
                      / /|  / / /_/ / /_/ / / /_/ (__  )  __/
                     /_/ |_/_/\__, /\__,_/_/\____/____/\___/ 
                             /____/   
    ]])
end

return Api
