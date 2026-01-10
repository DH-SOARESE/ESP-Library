local Obsidian = "https://raw.githubusercontent.com/DH-SOARESE/Obsidian/main/"
local basePath = "Obsidian Library"
local addonsPath = basePath .. "/addons"

if not isfolder(basePath) then makefolder(basePath) end
if not isfolder(addonsPath) then makefolder(addonsPath) end

local function ensureFile(filePath, url)
    if not isfile(filePath) then
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)

        if success and result then
            writefile(filePath, result)
        else
            warn("Falha ao baixar " .. filePath .. ": " .. tostring(result))
        end
    end
end

local FolderName = "ESP Library"
local FilePath = FolderName .. "/Source.luau"
local SourceURL = "https://raw.githubusercontent.com/DH-SOARESE/ESP-Library/main/Source.lua"

if not isfolder(FolderName) then
    makefolder(FolderName)
end

local function loadESPLibrary()
    local content

    if isfile(FilePath) then
        content = readfile(FilePath)
    else
        content = game:HttpGet(SourceURL)
        writefile(FilePath, content)
    end

    return loadstring(content)()
end


ensureFile(basePath .. "/Library.lua", Obsidian .. "Library.lua")
ensureFile(addonsPath .. "/SaveManager.lua", Obsidian .. "addons/SaveManager.lua")
ensureFile(addonsPath .. "/ThemeManager.lua", Obsidian .. "addons/ThemeManager.lua")

local Library = loadfile(basePath .. "/Library.lua")()
local SaveManager = loadfile(addonsPath .. "/SaveManager.lua")()
local ThemeManager = loadfile(addonsPath .. "/ThemeManager.lua")()

local FolderName = "ESP Library"
local FilePath = FolderName .. "/Source.luau"
local SourceURL = "https://raw.githubusercontent.com/DH-SOARESE/ESP-Library/main/Source.lua"

if not isfolder(FolderName) then
    makefolder(FolderName)
end

local function loadESPLibrary()
    local content

    if isfile(FilePath) then
        content = readfile(FilePath)
    else
        content = game:HttpGet(SourceURL)
        writefile(FilePath, content)
    end

    return loadstring(content)()
end

local ESPLibrary = loadESPLibrary()

ESPLibrary.Enabled = true
ESPLibrary.Config.Tracer = false
ESPLibrary.Config.Name = true
ESPLibrary.Config.Distance = true
ESPLibrary.Config.Outline = true
ESPLibrary.Config.Filled = true
ESPLibrary.Config.Arrow = true

ESPLibrary.Settings.TracerOrigin = "Bottom"
ESPLibrary.Settings.MaxDistance = 1000
ESPLibrary.Settings.MinDistance = 5
ESPLibrary.Settings.Decimal = false
ESPLibrary.Settings.FontSize = 12
ESPLibrary.Settings.Font = 2
ESPLibrary.Settings.Rainbow = false
ESPLibrary.Settings.RainbowDelay = 8
ESPLibrary.Settings.HighlightTransparency.Filled = 0.7
ESPLibrary.Settings.HighlightTransparency.Outline = 0.3

ESPLibrary:SetTemplate("Add", {
    PrefixDistance = "[",
    SuffixDistance = "m]",
    Color = Color3.fromRGB(255, 255, 255)
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer


local function AddESP(character)
    if not character then return end
    
    local player = Players:GetPlayerFromCharacter(character)
    if not player or player == LocalPlayer then return end
    
    if ESPLibrary:HasESP(player.Name) then
        ESPLibrary:Remove(player.Name)
    end
    
    ESPLibrary:Add(player.Name, {
        Model = character,
        Name = player.Name,
        Center = character:FindFirstChild("Head"),
    })
end

local function RemoveESP(player)
    if ESPLibrary:HasESP(player.Name) then
        ESPLibrary:Remove(player.Name)
    end
end

local function UpdateAllESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if ESPLibrary.Enabled then
                AddESP(player.Character)
            else
                RemoveESP(player)
            end
        end
    end
end


local Window = Library:CreateWindow({
    Title = "ESP Library",
    Footer = "Example Script",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("ESP", "eye"),
    Settings = Window:AddTab("Settings", "settings")
}


local ESPGroup = Tabs.Main:AddLeftGroupbox("ESP Controls", "boxes")
local ComponentsGroup = Tabs.Main:AddRightGroupbox("Components", "layers")


ESPGroup:AddToggle("EnableESP", {
    Text = "Enable ESP",
    Default = true,
    Tooltip = "Ativa/desativa todo o sistema ESP",
    Callback = function(Value)
        ESPLibrary.Enabled = Value
        if not Value then
            ESPLibrary:Clear()
        else
            UpdateAllESP()
        end
    end,
})

ESPGroup:AddToggle("RainbowMode", {
    Text = "Rainbow Mode",
    Default = false,
    Tooltip = "Ativa modo arco-íris",
    Callback = function(Value)
        ESPLibrary:RainbowMode(Value)
    end,
})

ESPGroup:AddSlider("RainbowSpeed", {
    Text = "Rainbow Speed",
    Default = 8,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Tooltip = "Velocidade da transição rainbow",
    Callback = function(Value)
        ESPLibrary:RainbowMode(nil, Value)
    end,
})

ESPGroup:AddDivider()

ESPGroup:AddLabel("ESP Color"):AddColorPicker("ESPColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Tooltip = "Cor padrão do ESP",
    Callback = function(Value)
        ESPLibrary:SetTemplate("Add", {
            Color = Value
        })
        
        for id, esp in pairs(ESPLibrary.ESPs) do
            esp:SetColor(Value)
        end
    end,
})


ComponentsGroup:AddToggle("Tracer", {
    Text = "Tracer",
    Default = false,
    Tooltip = "Linha até o alvo",
    Callback = function(Value)
        ESPLibrary.Config.Tracer = Value
    end,
})

ComponentsGroup:AddToggle("Name", {
    Text = "Name",
    Default = true,
    Tooltip = "Mostrar nome do jogador",
    Callback = function(Value)
        ESPLibrary.Config.Name = Value
    end,
})

ComponentsGroup:AddToggle("Distance", {
    Text = "Distance",
    Default = true,
    Tooltip = "Mostrar distância",
    Callback = function(Value)
        ESPLibrary.Config.Distance = Value
    end,
})

ComponentsGroup:AddToggle("Outline", {
    Text = "Outline",
    Default = true,
    Tooltip = "Contorno do modelo",
    Callback = function(Value)
        ESPLibrary.Config.Outline = Value
    end,
})

ComponentsGroup:AddToggle("Filled", {
    Text = "Filled",
    Default = true,
    Tooltip = "Preenchimento do modelo",
    Callback = function(Value)
        ESPLibrary.Config.Filled = Value
    end,
})

ComponentsGroup:AddToggle("Arrow", {
    Text = "Arrow",
    Default = true,
    Tooltip = "Seta quando fora da tela",
    Callback = function(Value)
        ESPLibrary.Config.Arrow = Value
    end,
})


local DistanceGroup = Tabs.Settings:AddLeftGroupbox("Distance", "ruler")
local TextGroup = Tabs.Settings:AddLeftGroupbox("Text", "type")
local TracerGroup = Tabs.Settings:AddRightGroupbox("Tracer", "git-branch")
local TransparencyGroup = Tabs.Settings:AddRightGroupbox("Transparency", "eye-off")


DistanceGroup:AddSlider("MaxDistance", {
    Text = "Max Distance",
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Suffix = " studs",
    Tooltip = "Distância máxima para renderizar",
    Callback = function(Value)
        ESPLibrary.Settings.MaxDistance = Value
    end,
})

DistanceGroup:AddSlider("MinDistance", {
    Text = "Min Distance",
    Default = 5,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = " studs",
    Tooltip = "Distância mínima para renderizar",
    Callback = function(Value)
        ESPLibrary.Settings.MinDistance = Value
    end,
})

DistanceGroup:AddToggle("Decimal", {
    Text = "Show Decimals",
    Default = false,
    Tooltip = "Mostrar casas decimais na distância",
    Callback = function(Value)
        ESPLibrary.Settings.Decimal = Value
    end,
})

DistanceGroup:AddInput("PrefixDistance", {
    Text = "Prefix",
    Default = "[",
    Placeholder = "Prefixo",
    Tooltip = "Prefixo da distância",
    Callback = function(Value)
        ESPLibrary:SetTemplate("Add", {
            PrefixDistance = Value
        })
        for _, v in pairs(ESPLibrary.ESPs) do
            v:SetPrefixDistance(Value)
        end
    end,
})

DistanceGroup:AddInput("SuffixDistance", {
    Text = "Suffix",
    Default = "m]",
    Placeholder = "Sufixo",
    Tooltip = "Sufixo da distância",
    Callback = function(Value)
        ESPLibrary:SetTemplate("Add", {
            SuffixDistance = Value
        })
        for _, v in pairs(ESPLibrary.ESPs) do
            v:SetSuffixDistance(Value)
        end
    end,
})


TextGroup:AddSlider("FontSize", {
    Text = "Font Size",
    Default = 12,
    Min = 8,
    Max = 24,
    Rounding = 0,
    Tooltip = "Tamanho da fonte",
    Callback = function(Value)
        ESPLibrary.Settings.FontSize = Value
    end,
})

TextGroup:AddDropdown("Font", {
    Text = "Font",
    Values = {"UI", "System", "Plex", "Monospace"},
    Default = 3,
    Tooltip = "Tipo de fonte",
    Callback = function(Value)
        local fonts = {UI = 0, System = 1, Plex = 2, Monospace = 3}
        ESPLibrary.Settings.Font = fonts[Value]
    end,
})


TracerGroup:AddDropdown("TracerOrigin", {
    Text = "Origin",
    Values = {"Top", "Bottom", "Left", "Right", "Center", "Mouse"},
    Default = 2,
    Tooltip = "Origem da linha tracer",
    Callback = function(Value)
        ESPLibrary.Settings.TracerOrigin = Value
    end,
})


TransparencyGroup:AddSlider("FilledTransparency", {
    Text = "Filled",
    Default = 0.7,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Tooltip = "Transparência do preenchimento",
    Callback = function(Value)
        ESPLibrary.Settings.HighlightTransparency.Filled = Value
    end,
})

TransparencyGroup:AddSlider("OutlineTransparency", {
    Text = "Outline",
    Default = 0.3,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Tooltip = "Transparência do contorno",
    Callback = function(Value)
        ESPLibrary.Settings.HighlightTransparency.Outline = Value
    end,
})


Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(AddESP)
end)

Players.PlayerRemoving:Connect(RemoveESP)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            AddESP(player.Character)
        end
        player.CharacterAdded:Connect(AddESP)
    end
end


SaveManager:SetLibrary(Library)
SaveManager:SetFolder("ESP-Library")
SaveManager:BuildConfigSection(Tabs.Settings)

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("ESP-Library")
ThemeManager:ApplyToTab(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

Library:Notify({
    Title = "ESP Library",
    Description = "Carregado com sucesso!",
    Icon = "check-circle",
    Duration = 3
})
