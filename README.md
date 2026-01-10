# ESP Library para Roblox (1.0.4)

Uma biblioteca otimizada para criar sistemas de ESP (Extra Sensory Perception) em Roblox com visualização avançada de objetos e jogadores.

---

## ✨ Características

- **Tracer** - Linha conectando até o alvo
- **Name** - Nome personalizado sobre o alvo
- **Distance** - Distância em tempo real
- **Outline** - Contorno destacado (Highlight)
- **Filled** - Preenchimento do modelo
- **Arrow** - Seta direcional quando fora da tela
- **Rainbow Mode** - Efeito arco-íris automático
- **Search System** - Busca automática de múltiplos alvos
- **Multi-Color** - Cores individuais por componente
- **Visibility Control** - Controle de visibilidade individual

---

## 🚀 Instalação

```luau
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/ESP-Library/main/Source.lua"))()
```

---

## 📖 Uso Básico

### Adicionar ESP

```luau
-- Simples
Library:Add("Player1", {
    Model = workspace.Target,
    Name = "Alvo",
    Color = Color3.fromRGB(255, 0, 0)
})

-- Com cores individuais
Library:Add("Boss", {
    Model = workspace.Boss,
    Color = {
        TracerColor = Color3.fromRGB(255, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        FilledColor = Color3.fromRGB(255, 0, 0),
        OutlineColor = Color3.fromRGB(255, 255, 0),
        ImageColor = Color3.fromRGB(255, 0, 0)
    }
})
```

**Parâmetros:**
- `Model` - Instance do alvo (obrigatório)
- `Name` - Nome exibido
- `Color` - Color3 ou table de cores
- `PrefixDistance` / `SuffixDistance` - Formatação da distância
- `Visible` - Controle de visibilidade
- `Center` - BasePart como centro
- `Method` - "Position" ou "BoundingBox"
- `Collision` - Renderização para modelos invisíveis

### Sistema de Busca

```luau
-- Busca simples
Library:Search({
    Local = workspace.Enemies,
    Target = "Zombie",
    Color = Color3.fromRGB(255, 0, 0)
})

-- Múltiplos alvos
Library:Search({
    Local = workspace,
    Targets = {"Zombie", "Skeleton", "Ghost"},
    Name = "Inimigo",
    Color = Color3.fromRGB(255, 0, 0)
})

-- Configuração individual
Library:Search({
    Local = workspace,
    Targets = {
        ["Boss"] = {
            Name = "CHEFE",
            Color = Color3.fromRGB(255, 0, 0)
        },
        ["Merchant"] = {
            Name = "Vendedor",
            Color = Color3.fromRGB(0, 255, 0)
        }
    }
})
```

### Métodos Principais

```luau
-- Gerenciamento
Library:Remove("Player1")
Library:Update("Player1", { Name = "Novo Nome" })
Library:GetESP("Player1")
Library:HasESP("Player1")
Library:Clear()
Library:Destroy()

-- Customização
Library:SetColor("Player1", Color3.fromRGB(0, 255, 0))
Library:SetName("Player1", "Novo Nome")
Library:SetVisible("Player1", false)

-- Métodos do ESP
local esp = Library:GetESP("Player1")
esp:SetColor(Color3.fromRGB(255, 255, 0))
esp:SetName("Novo Nome")
esp:SetVisible(false)
```

---

## ⚙️ Configurações

### Componentes

```luau
Library.Enabled = true

Library.Config.Tracer = true
Library.Config.Name = true
Library.Config.Distance = true
Library.Config.Outline = true
Library.Config.Filled = true
Library.Config.Arrow = true
```

### Distância e Texto

```luau
Library.Settings.MaxDistance = math.huge
Library.Settings.MinDistance = 5
Library.Settings.Decimal = false
Library.Settings.FontSize = 10
Library.Settings.Font = 2  -- 0=UI, 1=System, 2=Plex, 3=Monospace
```

### Tracer

```luau
Library.Settings.TracerOrigin = "Bottom"
-- Opções: "Top", "Bottom", "Left", "Right", "Center", "Mouse"
```

### Rainbow Mode

```luau
Library:RainbowMode(true, 8)  -- (ativo, velocidade)
Library.Settings.Rainbow = false
Library.Settings.RainbowDelay = 8
```

### Arrow (Seta)

```luau
Library.Settings.Arrow = {
    Image = 92023845052369,
    Size = UDim2.new(0, 40, 0, 40),
    Rotation = 90,
    Radius = 360,
    Range = 90
}
```

### Transparência

```luau
Library.Settings.HighlightTransparency = {
    Filled = 0.7,
    Outline = 0.3
}
```

### Template Padrão

```luau
Library.Template.Add = {
    PrefixDistance = "(",
    SuffixDistance = " m)",
    Color = Color3.fromRGB(0, 50, 233)
}

-- Ou use SetTemplate
Library:SetTemplate("Add", {
    PrefixDistance = "[",
    SuffixDistance = "]",
    Color = Color3.fromRGB(255, 0, 0)
})
```

---

## 🎨 Cores Individuais

```luau
-- Color3 único (todos os componentes usam a mesma cor)
Color = Color3.fromRGB(255, 0, 0)

-- Cores individuais por componente
Color = {
    TracerColor = Color3,   -- Linha tracer
    TextColor = Color3,     -- Texto (nome/distância)
    FilledColor = Color3,   -- Preenchimento
    OutlineColor = Color3,  -- Contorno
    ImageColor = Color3     -- Seta
}
```

---

## 🎯 Recursos Avançados

### Métodos de Posição

```luau
-- Position (padrão) - Usa PrimaryPart.Position ou BasePart.Position
Method = "Position"

-- BoundingBox - Calcula centro da caixa delimitadora
Method = "BoundingBox"
```

### Centro Customizado

```luau
Library:Add("Enemy", {
    Model = workspace.Enemy,
    Center = workspace.Enemy.Head  -- ESP aponta para a cabeça
})
```

### Collision (Renderização)

```luau
Library:Add("NPC", {
    Model = workspace.NPC,
    Collision = true  -- Adiciona Humanoid para renderizar Highlight
})
```

### Acesso aos ESPs

```luau
-- Iterar todos os ESPs
for id, esp in pairs(Library.ESPs) do
    print(id, esp.Name, esp.Visible)
end
```

---

## 📊 Estrutura do ESP

```luau
{
    -- Propriedades
    Name = string,
    Model = Instance,
    Color = Color3 or table,
    PrefixDistance = string,
    SuffixDistance = string,
    Center = BasePart or nil,
    Method = string,
    Visible = boolean,
    
    -- Componentes
    Tracer = Drawing,
    TextDraw = Drawing,
    Highlight = Instance,
    Arrow = ImageLabel,
    
    -- Métodos
    SetColor(color),
    SetName(name),
    SetPrefixDistance(prefix),
    SetSuffixDistance(suffix),
    SetVisible(bool),
    Destroy()
}
```

---

## 🔄 Lógica de Renderização

**Dentro da tela:**
- ✅ Highlight, Tracer, Text
- ❌ Arrow

**Fora da tela:**
- ❌ Highlight, Tracer, Text
- ✅ Arrow (aponta para o alvo)

**Visible = false:**
- ❌ Todos os componentes

---

## 📌 Versão

**Versão:** 1.0.4

**Atualizações:**
- ✨ Sistema `:Search()` para busca automática
- ✨ Suporte a cores individuais por componente
- ✨ Controle de visibilidade individual
- ✨ Método BoundingBox
- ⚡ Otimizações de performance

---

## 🔗 Links

- **Repositório:** [GitHub](https://github.com/DH-SOARESE/ESP-Library)
- **Source:** [Source.lua](https://github.com/DH-SOARESE/ESP-Library/blob/main/Source.lua)
- **Exemplo:** [Example.lua](https://github.com/DH-SOARESE/ESP-Library/blob/main/Example.lua)

```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/ESP-Library/main/Example.lua"))()
```

---

**Feito para a comunidade Roblox**
