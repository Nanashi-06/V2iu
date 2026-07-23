local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local NoclipConnection = nil
local NoclipModule = {}

local COLLISION_NAMES = {
    string.char(67, 104, 97, 114, 97, 99, 116, 101, 114, 67, 111, 108, 108, 105, 115, 105, 111, 110),
    string.char(99, 104, 97, 114, 67, 111, 108, 108, 105, 115, 105, 111, 110),
    string.char(99, 104, 101, 99, 107, 67, 111, 108, 108, 105, 115, 105, 111, 110),
    string.char(99, 111, 108, 108, 105, 115, 105, 111, 110),
    string.char(67, 97, 110, 67, 111, 108, 108, 105, 100, 101),
    string.char(115, 101, 116, 67, 111, 108, 108, 105, 115, 105, 111, 110),
    string.char(97, 110, 116, 105, 78, 111, 99, 108, 105, 112),
    string.char(97, 110, 116, 105, 78, 111, 99, 108, 105, 112, 112, 105, 110, 103),
    string.char(110, 111, 67, 108, 105, 112),
    string.char(110, 111, 67, 108, 105, 112, 112, 105, 110, 103),
    string.char(110, 111, 99, 108, 105, 112),
    string.char(110, 111, 99, 108, 105, 112, 99, 104, 101, 99, 107),
}

function NoclipModule.Enable()
    if NoclipConnection then NoclipConnection:Disconnect() end
    
    local hook = newcclosure(function() return end)
    
    for _, obj in getgc(false) do 
        if typeof(obj) == "function" then 
            local success, info = pcall(debug.info, obj, "s")
            if success and info then
                local source = info:lower()
                for _, pattern in ipairs(COLLISION_NAMES) do
                    if source:find(pattern:lower()) then
                        pcall(hookfunction, obj, hook)
                        break
                    end
                end
            end
        end
    end
    
    NoclipConnection = RunService.Stepped:Connect(function()
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
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
  
    local character = LocalPlayer.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

return NoclipModule
