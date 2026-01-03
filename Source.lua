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

local CamConnect
local RunConnect

CamConnect = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

local gethui = gethui or function()
    return CoreGui
end

local assert = function(condition, errorMessage)
    if not condition then
        error(errorMessage or "assert failed", 3)
    end
end

local ArrowMain = Instance.new("ScreenGui")
ArrowMain.Parent = gethui()
ArrowMain.IgnoreGuiInset = true
ArrowMain.DisplayOrder = 3

local ESPs = {}

local Library = {
    Enabled = true,
    Unloaded = false,
    
    Config = {
        Tracer = false,
        Name = true,
        Distance = true,
        Outline = true,
        Filled = true,
        Arrow = true
    },
    Settings = {
        TracerOrigin = "Bottom",
        
        MaxDistance = math.huge,
        MinDistance = 5,
        
        Decimal = false,
        FontSize = 10,
        Font = 2,
        
        Rainbow = false,
        RainbowDelay = 8,
        
        Arrow = {
            Image = 92023845052369,
            Size = UDim2.new(0, 40, 0, 40),
            Rotation = 90,
            Radius = 360,
            Range = 90
        },
        
        HighlightTransparency = {
            Filled = 0.7,
            Outline = 0.3
        }
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

function Library:Destroy()
    Library:Clear()
    if CamConnect then
        CamConnect:Disconnect()
        CamConnect = nil
    end
    if RunConnect then
        RunConnect:Disconnect()
        RunConnect = nil
    end
    if ArrowMain then
        ArrowMain:Destroy()
        ArrowMain = nil
    end
    self = { Unloaded = true }
end

local Origin = {
    Top = function(vs) return Vector2.new(vs.X / 2, 0) end,
    Center = function(vs) return Vector2.new(vs.X / 2, vs.Y / 2) end,
    Bottom = function(vs) return Vector2.new(vs.X / 2, vs.Y) end,
    Left = function(vs) return Vector2.new(0, vs.Y / 2) end,
    Right = function(vs) return Vector2.new(vs.X, vs.Y / 2) end,
}

local function New(Class: string?, properties: table?)
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

local function NewDrawing(class: string?, props: table?)
    local Draw = Drawing.new(class)
    if props then
        for k, v in pairs(props) do
            pcall(function()
                Draw[k] = v
            end)
        end
    end
    return Draw
end

function Library:GetBoundingBox(root: Instance?)
    if not root then return end

    if root:IsA("BasePart") then
        return root.CFrame, root.Size
    elseif root:IsA("Model") then
        local primary = root.PrimaryPart or root:FindFirstChildWhichIsA("BasePart")
        if not primary then return end
        
        local cframe, size
        local parts = root:GetDescendants()
        local minVec, maxVec

        for _, part in pairs(parts) do
            if part:IsA("BasePart") then
                local corners = {
                    part.Position + Vector3.new( part.Size.X/2,  part.Size.Y/2,  part.Size.Z/2),
                    part.Position + Vector3.new( part.Size.X/2,  part.Size.Y/2, -part.Size.Z/2),
                    part.Position + Vector3.new( part.Size.X/2, -part.Size.Y/2,  part.Size.Z/2),
                    part.Position + Vector3.new( part.Size.X/2, -part.Size.Y/2, -part.Size.Z/2),
                    part.Position + Vector3.new(-part.Size.X/2,  part.Size.Y/2,  part.Size.Z/2),
                    part.Position + Vector3.new(-part.Size.X/2,  part.Size.Y/2, -part.Size.Z/2),
                    part.Position + Vector3.new(-part.Size.X/2, -part.Size.Y/2,  part.Size.Z/2),
                    part.Position + Vector3.new(-part.Size.X/2, -part.Size.Y/2, -part.Size.Z/2),
                }

                for _, corner in pairs(corners) do
                    if not minVec then
                        minVec = corner
                        maxVec = corner
                    else
                        minVec = Vector3.new(
                            math.min(minVec.X, corner.X),
                            math.min(minVec.Y, corner.Y),
                            math.min(minVec.Z, corner.Z)
                        )
                        maxVec = Vector3.new(
                            math.max(maxVec.X, corner.X),
                            math.max(maxVec.Y, corner.Y),
                            math.max(maxVec.Z, corner.Z)
                        )
                    end
                end
            end
        end

        if minVec and maxVec then
            cframe = CFrame.new((minVec + maxVec)/2)
            size = maxVec - minVec
            return cframe, size
        end
    end
end

function Library:Add(idx, info: table?)
    if self.Unloaded then return end
    assert(info.Model and typeof(info.Model) == "Instance", "Alvo inválido!")
    assert(not ESPs[idx], "ESP Já existe nesse alvo!")
    
    local ESP = {
        Model = info.Model,
        Name = info.Name or info.Model.Name,
        
        SuffixDistance = info.SuffixDistance or self.Template.Add.SuffixDistance,
        PrefixDistance = info.PrefixDistance or self.Template.Add.PrefixDistance,
        
        Center = if info.Center and info.Center:IsA("BasePart") then info.Center else nil,
        Visible = info.Visible or true,
        
        Color = info.Color or self.Template.Add.Color,
        
        Method = info.Method or "Position"
    }

    ESP.Tracer = NewDrawing("Line", { 
        Color = ESP.Color,
        Thickness = 1,
        Visible = false 
    })
    
    ESP.TextDraw = NewDrawing("Text", { 
        Text = ESP.Name or "",
        Size = self.Settings.FontSize,
        Font = self.Settings.Font,
        Color = ESP.Color,
        Center = true, 
        Outline = true, 
        Visible = false
    })
    
    ESP.Highlight = New("Highlight", {
        Adornee = ESP.Model,
        FillColor = ESP.Color,
        OutlineColor = ESP.Color,
        FillTransparency = self.Config.Filled and self.Settings.HighlightTransparency.Filled or 1,
        OutlineTransparency = self.Config.Outline and self.Settings.HighlightTransparency.Outline or 1,
        Enabled = false,
        Parent = gethui()
    })
    
    ESP.Arrow = New("ImageLabel", {
        BackgroundTransparency = 1,
        Size = self.Settings.Arrow.Size,
        Image = "rbxassetid://" .. tostring(self.Settings.Arrow.Image),
        Visible = false,
        Parent = ArrowMain
    })
    
    if info.Collision then
        if not ESP.Model:FindFirstChildWhichIsA("Humanoid", false) then
            New("Humanoid", { 
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
    
    function ESP:SetColor(color: Color3?)
        self.Color = color
    end

    function ESP:SetName(New: string?)
        self.Name = New
    end

    function ESP:SetSuffixDistance(New: string?)
        self.SuffixDistance = New
    end

    function ESP:SetPrefixDistance(New: string?)
        self.PrefixDistance = New
    end    
    
    function ESP:Visible(bool: boolean?)
        ESP.Visible = bool
    end
    
    ESPs[(typeof(idx) == "string" and idx or ESP.Model)] = ESP
    return ESP
end

function Library:Search(info)
    assert(info ~= nil, "Info precisa ser definido")
    assert(info.Local ~= nil, "Local precisa ser definido")
    
    local targets = info.Target or info.Targets
    
    local targetConfigs = {}
    
    if typeof(targets) == "string" then
        targetConfigs[targets] = {
            Name = info.Name,
            Color = info.Color,
            PrefixDistance = info.PrefixDistance,
            SuffixDistance = info.SuffixDistance
        }
    elseif typeof(targets) == "table" then
        -- Se for array de strings → usa config global
        if targets[1] and typeof(targets[1]) == "string" then
            for _, name in ipairs(targets) do
                targetConfigs[name] = {
                    Name = info.Name or name,
                    Color = info.Color,
                    PrefixDistance = info.PrefixDistance,
                    SuffixDistance = info.SuffixDistance
                }
            end
        else
            -- Se for table com configs por nome → usa direto
            for targetName, config in pairs(targets) do
                targetConfigs[targetName] = {
                    Name = config.Name or info.Name or targetName,
                    Color = config.Color or info.Color,
                    PrefixDistance = config.PrefixDistance or info.PrefixDistance,
                    SuffixDistance = config.SuffixDistance or info.SuffixDistance,
                    -- Pode adicionar mais overrides aqui no futuro
                }
            end
        end
    else
        error("Target/Targets precisa ser string ou table")
    end
    
    -- Iteração nos objetos
    local objects = typeof(info.Local) == "table" and info.Local or info.Local:GetDescendants()
    
    for _, obj in ipairs(objects) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local objName = obj.Name
            
            if targetConfigs[objName] then
                local config = table.clone(targetConfigs[objName])
                config.Model = obj
                
                local id = "search_" .. objName .. "_" .. obj:GetFullName()
                Library:Add(id, config)
            end
        end
    end
end

function Library:SetTemplate(idx, info: table?)
    if self.Template[idx] then
        for k, v in pairs(info) do
            if self.Template[idx][k] then
                self.Template[idx][k] = v
            end
        end
    end
end

function Library:Update(idx, info: table?)
    if self.Unloaded then return end
    assert(ESPs[idx], "Erro: valor esperado não existe")
    assert(typeof(info) == "table", "Erro: 'info' precisa ser uma table")
    
    for k, v in pairs(info) do
        if ESPs[idx][k] then
            ESPs[idx][k] = v
        end
    end
end

function Library:Remove(idx)
    if ESPs[idx] then
        if ESPs[idx].Tracer then ESPs[idx].Tracer:Remove() end
        if ESPs[idx].TextDraw then ESPs[idx].TextDraw:Remove() end
        if ESPs[idx].Box then ESPs[idx].Box:Remove() end
        if ESPs[idx].Highlight then ESPs[idx].Highlight:Destroy() end
        if ESPs[idx].Arrow then ESPs[idx].Arrow:Destroy() end
        ESPs[idx] = nil
    end
end

function Library:SetColor(idx, New: Color3?)
    if ESPs[idx] then
        ESPs[idx]:SetColor(New)
    end
end

function Library:SetName(idx, New: string?)
    if ESPs[idx] then
        ESPs[idx]:SetName(New)
    end
end

function Library:SetPrefixDistance(idx, New: string?)
    if ESPs[idx] then
        ESPs[idx]:SetPrefixDistance(New)
    end
end

function Library:SetSuffixDistance(idx, New: string?)
    if ESPs[idx] then
        ESPs[idx]:SetSuffixDistance(New)
    end
end

function Library:SetVisible(idx, bool: boolean?)
    if ESPs[idx] then
        ESPs[idx]:Visible(bool)
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
    for idx, _ in pairs(ESPs) do
        self:Remove(idx)
    end
end

function Library:RainbowMode(state: boolean?, delay: number?)
    if typeof(state) == "boolean" then
        self.Settings.Rainbow = state
    end
    if typeof(delay) == "number" then
        self.Settings.RainbowDelay = delay
    end
end

RunConnect = RunService.RenderStepped:Connect(function()
    if not Camera then return end
    local vs = Camera.ViewportSize
    local cameraPos = Camera.CFrame.Position

    for _, ESP in pairs(ESPs) do
        local target = ESP.Model
        if not target or not target.Parent then
            if ESP.Tracer then ESP.Tracer.Visible = false end
            if ESP.TextDraw then ESP.TextDraw.Visible = false end
            if ESP.Highlight then ESP.Highlight.Enabled = false end
            if ESP.Arrow then ESP.Arrow.Visible = false end
            continue
        end

        local targetPos
        if ESP.Method == "BoundingBox" then
            local cframe, _ = Library:GetBoundingBox(target)
            targetPos = cframe and cframe.Position
        else
            targetPos = ESP.Center and ESP.Center.Position
                or (target:IsA("Model") and target.PrimaryPart and target.PrimaryPart.Position)
                or (target:IsA("BasePart") and target.Position)
        end

        if not targetPos then
            if ESP.Tracer then ESP.Tracer.Visible = false end
            if ESP.TextDraw then ESP.TextDraw.Visible = false end
            if ESP.Highlight then ESP.Highlight.Enabled = false end
            if ESP.Arrow then ESP.Arrow.Visible = false end
            continue
        end

        local pos3d = Camera:WorldToViewportPoint(targetPos)
        local dist = (targetPos - cameraPos).Magnitude

        if (dist > Library.Settings.MaxDistance or dist < Library.Settings.MinDistance) or not ESP.Visible then
            if ESP.Tracer then ESP.Tracer.Visible = false end
            if ESP.TextDraw then ESP.TextDraw.Visible = false end
            if ESP.Highlight then ESP.Highlight.Enabled = false end
            if ESP.Arrow then ESP.Arrow.Visible = false end
            continue
        end

        local pos = Vector2.new(pos3d.X, pos3d.Y)
        local center = Vector2.new(vs.X / 2, vs.Y / 2)
        local dir = pos - center
        local mag = dir.Magnitude

        local inFront = pos3d.Z > 0
        local onScreen = pos.X >= 0 and pos.X <= vs.X and pos.Y >= 0 and pos.Y <= vs.Y
        local within_fov = inFront and onScreen and (mag <= Library.Settings.Arrow.Radius)

        local currentColor = ESP.Color
        if Library.Settings.Rainbow then
            local hue = (tick() % Library.Settings.RainbowDelay) / Library.Settings.RainbowDelay
            currentColor = Color3.fromHSV(hue, 1, 1)
        end

        if ESP.Highlight then
            ESP.Highlight.FillTransparency = Library.Config.Filled and Library.Settings.HighlightTransparency.Filled or 1
            ESP.Highlight.OutlineTransparency = Library.Config.Outline and Library.Settings.HighlightTransparency.Outline or 1
            ESP.Highlight.Enabled = Library.Enabled and within_fov
            ESP.Highlight.FillColor = currentColor
            ESP.Highlight.OutlineColor = currentColor
        end

        if within_fov then
            if Library.Config.Tracer and ESP.Tracer and Library.Enabled then
                local originPos = (Origin[Library.Settings.TracerOrigin] or Origin.Bottom)(vs)
                ESP.Tracer.From = originPos
                ESP.Tracer.To = pos
                ESP.Tracer.Color = currentColor
                ESP.Tracer.Visible = true
            elseif ESP.Tracer then
                ESP.Tracer.Visible = false
            end

            if ESP.TextDraw then
                local text = ""
                if Library.Config.Name then text = ESP.Name end
                if Library.Config.Distance then
                    local distText = ESP.PrefixDistance .. (Library.Settings.Decimal and string.format("%.1f", dist) or math.floor(dist)) .. ESP.SuffixDistance
                    if text ~= "" then text = text.."\n"..distText else text = distText end
                end
                ESP.TextDraw.Text = text
                ESP.TextDraw.Font = Library.Settings.Font
                ESP.TextDraw.Size = Library.Settings.FontSize
                ESP.TextDraw.Position = pos + Vector2.new(0, -ESP.TextDraw.TextBounds.Y - 5)
                ESP.TextDraw.Color = currentColor
                ESP.TextDraw.Visible = true
            end

            if ESP.Arrow then ESP.Arrow.Visible = false end
        else
            if ESP.Tracer then ESP.Tracer.Visible = false end
            if ESP.TextDraw then ESP.TextDraw.Visible = false end

            if Library.Config.Arrow and ESP.Arrow and Library.Enabled then
                local arrowDir = inFront and dir or -dir
                local normalizedDir = mag > 0 and (arrowDir / mag) or Vector2.new(0, 1)
                local arrowPos = center + normalizedDir * Library.Settings.Arrow.Range
                ESP.Arrow.Position = UDim2.fromOffset(
                    arrowPos.X - (Library.Settings.Arrow.Size.X.Offset/2),
                    arrowPos.Y - (Library.Settings.Arrow.Size.Y.Offset/2)
                )
                local angle = math.atan2(normalizedDir.Y, normalizedDir.X)
                ESP.Arrow.Rotation = math.deg(angle) + Library.Settings.Arrow.Rotation
                ESP.Arrow.Image = "rbxassetid://"..tostring(Library.Settings.Arrow.Image)
                ESP.Arrow.ImageColor3 = currentColor
                ESP.Arrow.Size = Library.Settings.Arrow.Size
                ESP.Arrow.Visible = true
            elseif ESP.Arrow then
                ESP.Arrow.Visible = false
            end
        end
    end
end)

return Library
