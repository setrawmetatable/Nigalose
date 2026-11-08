local Api = {
    Players = game:GetService("Players"),
    Run = game:GetService("RunService"),
    Uis = game:GetService("UserInputService"),
    Vim = game:GetService("VirtualInputManager"),
    Tween = game:GetService("TweenService"),
    Light = game:GetService("Lighting"),
    Http = game:GetService("HttpService"),
    Market = game:GetService("MarketplaceService"),
    Rep = game:GetService("ReplicatedStorage"),

    Player = game:GetService("Players").LocalPlayer,
    Name = game:GetService("Players").LocalPlayer.Name,
    Camera = workspace.CurrentCamera,
    PlaceId = game.PlaceId,

    Mouse = game:GetService("Players").LocalPlayer:GetMouse(),
	Core = gethui and gethui() or cloneref(game:GetService("CoreGui")),

    Esp = {},
    Circle = {},
    Effect = {},
}

local Load = {
    Esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/setrawmetatable/Nigalose/refs/heads/main/Module/Esp.lua")),
	Circle = loadstring(game:HttpGet("https://raw.githubusercontent.com/setrawmetatable/Nigalose/refs/heads/main/Module/Circle.lua")),
	Effect = loadstring(game:HttpGet("https://raw.githubusercontent.com/setrawmetatable/Nigalose/refs/heads/main/Module/Effect.lua")),
}

function Api:JoinDiscord()
    if Api.Request then
        pcall(function()
            Api.Request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = Api.Http:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {code = "Gc5QkQCdFA"},
                    nonce = Api.Http:GenerateGUID(true)
                })
            })
        end)
    end
end

function Api:LoadEsp()
    Load.Esp()
    if getgenv().Esp then
        Api.Esp = getgenv().Esp
    end
end

function Api:LoadCircle()
    Load.Circle()
    if getgenv().Circle then
        Api.Circle = getgenv().Circle
    end
end

function Api:LoadEffect()
    Load.Effect()
    if getgenv().Effect then
        Api.Effect = getgenv().Effect
    end
end

return Api
