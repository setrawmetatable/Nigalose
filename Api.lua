
local Api = {
    players = game:GetService("Players"),
    run = game:GetService("RunService"),
    uis = game:GetService("UserInputService"),
    vim = game:GetService("VirtualInputManager"),
    tween = game:GetService("TweenService"),
    core = game:GetService("CoreGui"),
    light = game:GetService("Lighting"),
    http = game:GetService("HttpService"),
    sound = game:GetService("SoundService"),
    market = game:GetService("MarketplaceService"),
    rep = game:GetService("ReplicatedStorage"),
    text = game:GetService("TextService"),
    
    player = game:GetService("Players").LocalPlayer,
    name = game:GetService("Players").LocalPlayer.Name,
    camera = workspace.CurrentCamera,
    placeid = game.PlaceId,
    
    mouse = game:GetService("Players").LocalPlayer:GetMouse(),
    screen = Instance.new("ScreenGui"),

    mobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").MouseEnabled,
    executor = identifyexecutor() or getexecutorname() or "Unknown",

}  

local Function = {
    {name = "Drawing", present = type(Drawing) == "table" or type(Drawing) == "userdata"},
    {name = "hookmetamethod", present = type(hookmetamethod) == "function"},
    {name = "getnamecallmethod", present = type(getnamecallmethod) == "function"},
    {name = "checkcaller", present = type(checkcaller) == "function"},
    {name = "getgc", present = type(getgc) == "function" and pcall(getgc) and type(getgc()) == "table"},
}

function Api:Kick(text)
    Api.player:Kick(text)
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

function Api:GetScript(name)
    local obj = game:FindFirstChild(name, true)
    if obj then
        return obj
    end
    return nil
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
    Notification:Notification(text, time)
end

function Api:JoinDiscord(dscode)
    local http = (syn and syn.request) or (psm and psm.request) or request
    if http then
        pcall(function()
            local HttpService = game:GetService("HttpService")
            http({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = HttpService:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {code = dscode},
                    nonce = HttpService:GenerateGUID(true)
                })
            })
        end)
    end
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
                                discord.gg/Gc5QkQCdFA
    ]])
end

return Api
