local cloneref = (cloneref or clonereference or function(instance: any)   
    return instance   
end)

local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Workspace = cloneref(game:GetService("Workspace"))

local getgenv = getgenv or (function() 
    return shared 
end)

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

local GetHUI = gethui or function()
    return CoreGui
end

local assert = function(condition, errorMessage)
    if not condition then
        error(errorMessage or "assert failed", 3)
    end
end

local ESPs = {}

local Library = {
    Enabled = true,
    Config = {
        Tracer = true,
        Name = true,
        Distance = true,
        Outline = true,
        Filled = true,
    },
    Settings = {
        HighlightTransparency = {
            Filled = 0.7,
            Outline = 0.3
        },
        TracerOrigin = "Top",
        MaxDistance = math.huge,
        MinDistance = 5,
        Decimal = false,
        FontSize = 10,
        Font = 2,
        Rainbow = false,
        RainbowDelay = 8,
    },
    Template = {
        Add = {
            PrefixDistance = "(",
            SuffixDistance = " m)",
            Color = Color3.fromRGB(0, 50, 233)
        }
    },
    ESPs = ESPs
}

local Origin = {
    Top = function(vs) return Vector2.new(vs.X / 2, 0) end,
    Center = function(vs) return Vector2.new(vs.X / 2, vs.Y / 2) end,
    Bottom = function(vs) return Vector2.new(vs.X / 2, vs.Y) end,
    Left = function(vs) return Vector2.new(0, vs.Y / 2) end,
    Right = function(vs) return Vector2.new(vs.X, vs.Y / 2) end,
}

function Library:New(Class: string, properties: table?)
    local Instance_ = Instance.new(Class)
    if properties then
        for k, v in pairs(properties) do
            pcall(function()
                Instance_[k] = v
            end)
        end
    end
    return Instance_
end

function Library:NewDrawing(class, props)
    local obj = Drawing.new(class)
    if props then
        for k, v in pairs(props) do
            pcall(function()
                obj[k] = v
            end)
        end
    end
    return obj
end

function Library:Add(idx, info)
    assert(info.Model and typeof(info.Model) == "Instance", "Alvo inválido!")

    local ESP = {
        Model = info.Model,
        Name = info.Name or info.Model.Name,
        SuffixDistance = info.SuffixDistance or self.Template.Add.SuffixDistance,
        PrefixDistance = info.PrefixDistance or self.Template.Add.PrefixDistance,
        Color = info.Color or self.Template.Add.Color
    }

    ESP.Tracer = self:NewDrawing("Line", { 
        Color = ESP.Color, 
        Thickness = 5,
        Visible = false 
    })
    ESP.TextDraw = self:NewDrawing("Text", { 
        Text = ESP.Name or "'",
        Size = self.Settings.FontSize,
        Font = self.Settings.Font,
        Color = ESP.Color,
        Center = true, 
        Outline = true, 
        Visible = false
    })
    ESP.Highlight = self:New("Highlight", {
        Adornee = ESP.Model,
        FillColor = ESP.Color,
        OutlineColor = ESP.Color,
        FillTransparency = self.Config.Filled and self.Settings.HighlightTransparency.Filled or 1,
        OutlineTransparency = self.Config.Outline and self.Settings.HighlightTransparency.Outline or 1,
        Enabled = false,
        Parent = GetHUI()
    })
    
    if info.Collision then
        if not ESP.Model:FindFirstChildWhichIsA("Humanoid", false) then
            self:New("Humanoid", { 
                Name = "ESP",
                Parent = ESP.Model
            })
        end
        for _, obj in ipairs(ESP.Model:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Transparency == 1 then
                obj.Transparency = 0.99
            end
        end
    end    
    function ESP:SetColor(color: Color3)
        self.Color = color
        if self.Tracer then self.Tracer.Color = color end
        if self.TextDraw then self.TextDraw.Color = color end
        if self.Highlight then
            self.Highlight.FillColor = color
            self.Highlight.OutlineColor = color
        end
    end

    function ESP:SetName(New: string)
        self.Name = New
    end

    function ESP:SetSuffixDistance(New: string)
        self.SuffixDistance = New
    end

    function ESP:SetPrefixDistance(New: string)
        self.PrefixDistance = New
    end    
    ESPs[(typeof(idx) == "string" and idx or ESP.Model)] = ESP
    return ESP
end

function Library:SetTemplete(idx,info)
    self.Template[idx] = info
end

function Library:Readjustment(idx, info)
    assert(ESPs[idx], "Erro: valor esperado não existe")
    assert(typeof(info) == "table", "Erro: 'info' precisa ser uma table")
    
    for key, value in pairs(info) do
        ESPs[idx][key] = value
    end
end

function Library:Remove(idx)
    local ESP = ESPs[idx]
    if ESP then
        if ESP.Tracer then ESP.Tracer:Remove() end
        if ESP.TextDraw then ESP.TextDraw:Remove() end
        if ESP.Highlight then ESP.Highlight:Destroy() end
        ESPs[idx] = nil
    end
end

function Library:SetColor(idx, New: Color3?)
    local ESP = ESPs[idx]
    if ESP then
        ESP:SetColor(New)
    end
end

function Library:SetName(idx, New: string?)
    local ESP = ESPs[idx]
    if ESP then
        ESP:SetName(New)
    end
end

function Library:SetPrefixDistance(idx, New: string?)
    local ESP = ESPs[idx]
    if ESP then
        ESP:SetPrefixDistance(New)
    end
end

function Library:SetSuffixDistance(idx, New: string?)
    local ESP = ESPs[idx]
    if ESP then
        ESP:SetSuffixDistance(New)
    end
end

function Library:GetESP(idx)
    if ESPs[idx] then
        return ESPs[idx]
    else
        return nil
    end
end

function Library:HasESP(idx)
    return ESPs[idx] ~= nil
end

function Library:Clear()
    for idx, ESP in pairs(ESPs) do
        if ESP then
            if ESP.Tracer then ESP.Tracer:Remove() end
            if ESP.TextDraw then ESP.TextDraw:Remove() end
            if ESP.Highlight then ESP.Highlight:Destroy() end
            ESPs[idx] = nil
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not Camera then return end
    local vs = Camera.ViewportSize
    local cameraPos = Camera.CFrame.Position

    for _, ESP in pairs(ESPs) do
        local target = ESP.Model
        if not target or not target.Parent then
            if ESP.Tracer then ESP.Tracer.Visible = false end
            if ESP.TextDraw then ESP.TextDraw.Visible = false end
            if ESP.Highlight then ESP.Highlight.Enabled = false end
            continue
        end

        local targetPos = target:IsA("Model") and target.PrimaryPart and target.PrimaryPart.Position or target.Position
        if not targetPos then
            if ESP.Tracer then ESP.Tracer.Visible = false end
            if ESP.TextDraw then ESP.TextDraw.Visible = false end
            if ESP.Highlight then ESP.Highlight.Enabled = false end
            continue
        end

        local pos3d, onScreen = Camera:WorldToViewportPoint(targetPos)
        local depth = pos3d.Z
        local dist = (targetPos - cameraPos).Magnitude

        if not onScreen or dist > Library.Settings.MaxDistance or dist < Library.Settings.MinDistance then
            if ESP.Tracer then ESP.Tracer.Visible = false end
            if ESP.TextDraw then ESP.TextDraw.Visible = false end
            if ESP.Highlight then ESP.Highlight.Enabled = false end
            continue
        end

        local pos = Vector2.new(pos3d.X, pos3d.Y)

        -- Handle rainbow mode
        local currentColor = ESP.Color
        if Library.Settings.Rainbow then
            local hue = (tick() % Library.Settings.RainbowDelay) / Library.Settings.RainbowDelay
            currentColor = Color3.fromHSV(hue, 1, 1)
            if ESP.Tracer then ESP.Tracer.Color = currentColor end
            if ESP.TextDraw then ESP.TextDraw.Color = currentColor end
            if ESP.Highlight then
                ESP.Highlight.FillColor = currentColor
                ESP.Highlight.OutlineColor = currentColor
            end
        end

        if ESP.Highlight then
            ESP.Highlight.FillTransparency = Library.Config.Filled and Library.Settings.HighlightTransparency.Filled or 1
            ESP.Highlight.OutlineTransparency = Library.Config.Outline and Library.Settings.HighlightTransparency.Outline or 1
            ESP.Highlight.Enabled = Library.Enabled
        end

        if Library.Config.Tracer and ESP.Tracer and Library.Enabled then
            local originPos = (Origin[Library.Settings.TracerOrigin] or Origin.Bottom)(vs)
            ESP.Tracer.From = originPos
            ESP.Tracer.To = pos
            ESP.Tracer.Visible = true
        elseif ESP.Tracer then
            ESP.Tracer.Visible = false
        end

        local textVisible = onScreen and Library.Enabled

        if (Library.Config.Name or Library.Config.Distance) and ESP.TextDraw and textVisible then
            local text = ""
            if Library.Config.Name then
                text = ESP.Name
            end
            if Library.Config.Distance then
                local distText = ESP.PrefixDistance .. (Library.Settings.Decimal and string.format("%.1f", dist) or math.floor(dist)) .. ESP.SuffixDistance
                if text ~= "" then
                    text = text .. "\n" .. distText
                else
                    text = distText
                end
            end
            ESP.TextDraw.Text = text
            ESP.TextDraw.Font = Library.Settings.Font
            ESP.TextDraw.Size = Library.Settings.FontSize
            local bounds = ESP.TextDraw.TextBounds
            ESP.TextDraw.Position = pos + Vector2.new(0, - (bounds.Y / 2))
            ESP.TextDraw.Visible = true
        elseif ESP.TextDraw then
            ESP.TextDraw.Visible = false
        end
    end
end)

return Library
