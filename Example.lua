local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/ESP-Library/main/Source.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function AddESP(Character)
    if not Character then return end
    if Library:HasESP(Character) then return end

    Library:Add(Character, {
        Model = Character
    })
end

for _, Player in ipairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then
        AddESP(Player.Character)
        Player.CharacterAdded:Connect(AddESP)
    end
end

Players.PlayerAdded:Connect(function(Player)
    if Player ~= LocalPlayer then
        Player.CharacterAdded:Connect(AddESP)
    end
end)
