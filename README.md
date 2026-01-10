# ESP Library para Roblox (1.0.5)

Uma biblioteca otimizada e leve para criar sistemas de ESP (Extra Sensory Perception) em Roblox com visualização avançada de objetos e jogadores.

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
- **Lightweight** - Otimizado para melhor performance

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
    Name = "CHEFE",
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
- `Visible` - Controle de visibilidade (padrão: true)
- `Center` - BasePart como centro
- `Method` - "Position" ou "BoundingBox"
- `Collision` - Renderização para modelos invisíveis

### Sistema de Busca

```luau
-- Busca simples (um alvo)
Library:Search({
    Local = workspace.Enemies,
    Target = "Zombie",
    Color = Color3.fromRGB(255, 0, 0)
})

-- Múltiplos alvos (array)
Library:Search({
    Local = workspace,
    Targets = {"Zombie", "Skeleton", "Ghost"},
    Name = "Inimigo",
    Color = Color3.fromRGB(255, 0, 0)
})

-- Configuração individual por alvo
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
Library:SetPrefixDistance("Player1", "[")
Library:SetSuffixDistance("Player1", "]")

-- Métodos do ESP
local esp = Library:GetESP("Player1")
esp:SetColor(Color3.fromRGB(255, 255, 0))
esp:SetName("Novo Nome")
esp:SetVisible(false)
esp:SetPrefixDistance("[")
esp:SetSuffixDistance("]")
esp:Destroy()
```

---

## ⚙️ Configurações

### Componentes

```luau
Library.Enabled = true

Library.Config.Tracer = false
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
Library.Settings.Decimal = false  -- true = "123.4 m" | false = "123 m"
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

-- Ou configure manualmente
Library.Settings.Rainbow = false
Library.Settings.RainbowDelay = 8
```

### Arrow (Seta)

```luau
Library.Settings.Arrow = {
    Image = 92023845052369,           -- ID da imagem
    Size = UDim2.new(0, 40, 0, 40),  -- Tamanho
    Rotation = 90,                    -- Rotação base
    Radius = 360,                     -- Raio FOV
    Range = 90                        -- Distância do centro
}
```

### Transparência

```luau
Library.Settings.HighlightTransparency = {
    Filled = 0.7,    -- 0 = Opaco | 1 = Invisível
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

## 🎨 Sistema de Cores

```luau
-- Color3 único (todos os componentes usam a mesma cor)
Color = Color3.fromRGB(255, 0, 0)

-- Cores individuais por componente
Color = {
    TracerColor = Color3.fromRGB(255, 0, 0),   -- Linha tracer
    TextColor = Color3.fromRGB(255, 255, 255), -- Texto (nome/distância)
    FilledColor = Color3.fromRGB(255, 0, 0),   -- Preenchimento
    OutlineColor = Color3.fromRGB(255, 255, 0),-- Contorno
    ImageColor = Color3.fromRGB(255, 0, 0)     -- Seta
}
```

---

## 🎯 Recursos Avançados

### Métodos de Posição

```luau
-- Position (padrão) - Usa PrimaryPart.Position ou BasePart.Position
Method = "Position"

-- BoundingBox - Calcula centro da caixa delimitadora do modelo
Method = "BoundingBox"
```

### Centro Customizado

```luau
Library:Add("Enemy", {
    Model = workspace.Enemy,
    Center = workspace.Enemy.Head  -- ESP aponta para a cabeça
})
```

### Collision (Renderização de Modelos Invisíveis)

```luau
Library:Add("NPC", {
    Model = workspace.NPC,
    Collision = true  -- Adiciona Humanoid e ajusta transparência para renderizar Highlight
})
```

### Acesso aos ESPs

```luau
-- Iterar todos os ESPs ativos
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
    
    -- Componentes (Drawing/Instance)
    Tracer = Drawing,
    TextDraw = Drawing,
    Highlight = Highlight,
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

**Dentro da tela (within FOV):**
- ✅ Highlight, Tracer, Text
- ❌ Arrow

**Fora da tela:**
- ❌ Highlight, Tracer, Text
- ✅ Arrow (aponta para o alvo)

**Condições para ocultar:**
- ❌ `Visible = false`
- ❌ `Library.Enabled = false`
- ❌ `dist > MaxDistance`
- ❌ `dist < MinDistance`
- ❌ Model destruído/removido

---

## 🛡️ Segurança e Otimização

### CloneRef Protection
```luau
-- A biblioteca usa cloneref para proteção contra detecção
local cloneref = cloneref or clonereference or function(instance)   
    return instance   
end
```

### Performance
- Sistema de renderização otimizado com `RenderStepped`
- Verificações eficientes de distância e visibilidade
- Garbage collection automática de ESPs destruídos
- Cálculo de BoundingBox otimizado

---

## 📝 Exemplos Práticos

### ESP para Inimigos

```luau
Library.Config.Tracer = true
Library.Config.Arrow = true

Library:Search({
    Local = workspace.Enemies,
    Targets = {"Zombie", "Skeleton"},
    Name = "Inimigo",
    Color = Color3.fromRGB(255, 0, 0)
})
```

### ESP para Boss com Rainbow

```luau
Library:RainbowMode(true, 5)

Library:Add("Boss", {
    Model = workspace.Boss,
    Name = "BOSS",
    Method = "BoundingBox"
})
```

### ESP para NPCs com Cores Customizadas

```luau
Library:Search({
    Local = workspace.NPCs,
    Targets = {
        ["Merchant"] = {
            Name = "Vendedor",
            Color = {
                TextColor = Color3.fromRGB(255, 255, 255),
                FilledColor = Color3.fromRGB(0, 255, 0),
                OutlineColor = Color3.fromRGB(255, 255, 0)
            }
        },
        ["Blacksmith"] = {
            Name = "Ferreiro",
            Color = Color3.fromRGB(128, 128, 128)
        }
    }
})
```

---

## 🔧 Troubleshooting

**ESP não aparece:**
- Verifique se `Library.Enabled = true`
- Verifique se o componente está ativo (`Library.Config.X`)
- Confirme que o Model existe e não foi destruído
- Verifique as configurações de distância (`MinDistance`/`MaxDistance`)

**Performance ruim:**
- Reduza `MaxDistance`
- Desative componentes não utilizados
- Use `:Clear()` para remover ESPs desnecessários

**Arrow não funciona:**
- Certifique-se que `Library.Config.Arrow = true`
- Verifique se o `Arrow.Image` é um ID válido
- Confirme que o alvo está fora do FOV

---

## 📌 Versão

**Versão:** 1.0.5

**Changelog:**
- ✨ Sistema `:Search()` para busca automática
- ✨ Suporte a cores individuais por componente
- ✨ Controle de visibilidade individual
- ✨ Método BoundingBox otimizado
- ⚡ Removido sistema de Box para melhor performance
- ⚡ Otimizações gerais de renderização
- 🛡️ CloneRef protection integrado

---

## 🔗 Links

- **Repositório:** [GitHub](https://github.com/DH-SOARESE/ESP-Library)
- **Source:** [Source.lua](https://github.com/DH-SOARESE/ESP-Library/blob/main/Source.lua)
- **Exemplo:** [Example.lua](https://github.com/DH-SOARESE/ESP-Library/blob/main/Example.lua)

```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/ESP-Library/main/Example.lua"))()
```

---

**Feito com ❤️ para a comunidade Roblox**
