local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local NoclipConnection = nil
local NoclipModule = {}

function NoclipModule.Enable()
    if NoclipConnection then NoclipConnection:Disconnect() end
    
    local hook = newcclosure(function() return end)
    
    for _, obj in getgc(false) do 
        if typeof(obj) == "function" then 
            local success, info = pcall(debug.info, obj, "s")
            if success and info and info:find("CharacterCollision") then
                pcall(hookfunction, obj, hook)
            end
        end
    end
    
    NoclipConnection = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function NoclipModule.Disable()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

return NoclipModule
