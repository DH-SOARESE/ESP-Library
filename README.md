# ESP Library para Roblox

Uma biblioteca completa e otimizada de ESP (Extra Sensory Perception) para Roblox, oferecendo visualização avançada de objetos no jogo com tracers, highlights, nomes e indicadores de distância em tempo real.

## ✨ Características

- **Tracers**avançada de objetos no jogo com tracers, highlights, nomes e indicadores
- **Highlights** - Destaque visual 3D nos modelos com transparência ajustável
- **Nomes** - Exibição de texto personalizável com múltiplas fontes
- **Distâncias** - Cálculo e exibição de distância em tempo real com prefixo/sufixo customizáveis
- **Rainbow Mode** - Modo arco-íris com velocidade ajustável
- **Identificadores flexíveis** - Use strings ou o próprio objeto como chave
- **Gerenciamento individual** - Controle granular de cada ESP criado
- **Performance otimizada** - Sistema eficiente usando RenderStepped
- **Compatibilidade** - Suporte para múltiplos executores com sistema de fallback

## 📦 Instalação

```lua
local ESPLibrary = loadstring(game:HttpGet("seu-link-aqui"))()
```

## 🚀 Início Rápido

### Criar um ESP com identificador string

```lua
local meuESP = ESPLibrary:Add("meu_esp", {
    Model = workspace.AlgumModelo,
    Name = "Alvo",
    Color = Color3.fromRGB(255, 0, 0)
})
```

### Criar um ESP usando o objeto como chave

```lua
local modelo = workspace.AlgumModelo

-- Use false como identificador para usar o próprio objeto como chave
local meuESP = ESPLibrary:Add(false, {
    Model = modelo,
    Name = "Alvo",

    
})

-- Agora você pode acessar/remover usando o objeto diretamente
ESPLibrary:Remove(modelo)
ESPLibrary:SetColor(modelo, Color3.fromRGB(0, 255, 0))
```

### Configuração global

```lua
-- Ativar/desativar componentes globalmente
ESPLibrary.Config.Tracer = true
ESPLibrary.Config.Name = true
ESPLibrary.Config.Distance = true
ESPLibrary.Config.Outline = true
ESPLibrary.Config.Filled = true

-- Personalizar aparência
ESPLibrary.Settings.MaxDistance = 500
ESPLibrary.Settings.MinDistance = 10
ESPLibrary.Settings.TracerOrigin = "Bottom" -- Opções: "Top", "Center", "Bottom", "Left", "Right"
ESPLibrary.Settings.FontSize = 14
ESPLibrary.Settings.Font = 2 -- 0: Legacy, 1: Arial, 2: SourceSansBold, 3: Gotham
ESPLibrary.Settings.Decimal = true -- Exibir casas decimais na distância

-- Modo Rainbow
ESPLibrary.Settings.Rainbow = true
ESPLibrary.Settings.RainbowDelay = 8 -- Velocidade do ciclo (menor = mais rápido)
```

## 📖 API Reference

### Métodos da Biblioteca

#### `Add(identificador, configurações)`
Cria um novo ESP para um objeto.

**Parâmetros:**
- `identificador` (string | false) - ID único para o ESP, ou `false` para usar o objeto Model como chave
- `configurações` (table) - Opções de configuração

**Opções disponíveis:**
```lua
{
    Model = Instance,              -- (Obrigatório) Modelo ou Part alvo
    Name = "Nome",                 -- (Opcional) Nome a ser exibido
    Color = Color3.new(1, 0, 0),  -- (Opcional) Cor do ESP
    PrefixDistance = "(",          -- (Opcional) Prefixo da distância
    SuffixDistance = " m)"         -- (Opcional) Sufixo da distância
}
```

**Com identificador string:**
```lua
ESPLibrary:Add("player_1", {
    Model = workspace.Player.Character,
    Name = "Jogador 1",
    Color = Color3.fromRGB(255, 100, 100),
    PrefixDistance = "[",
    SuffixDistance = "m]"
})
```

**Com objeto como chave:**
```lua
local character = workspace.Player.Character

ESPLibrary:Add(false, {
    Model = character,
    Name = "Jogador 1",
    Color = Color3.fromRGB(255, 100, 100)
})

-- Agora use o objeto para manipular o ESP
ESPLibrary:SetColor(character, Color3.new(0, 1, 0))
```

#### `Remove(identificador)`
Remove um ESP específico pelo identificador (string ou objeto).

```lua
ESPLibrary:Remove("player_1")
ESPLibrary:Remove(workspace.Player.Character)
```

#### `Clear()`
Remove todos os ESPs ativos.

```lua
ESPLibrary:Clear()
```

#### `SetColor(identificador, cor)`
Altera a cor de um ESP existente.

```lua
ESPLibrary:SetColor("player_1", Color3.fromRGB(0, 255, 0))
```

#### `SetName(identificador, nome)`
Altera o nome exibido de um ESP.

```lua
ESPLibrary:SetName("player_1", "Novo Nome")
```

#### `SetPrefixDistance(identificador, prefixo)`
Altera o prefixo da distância.

```lua
ESPLibrary:SetPrefixDistance("player_1", "[")
```

#### `SetSuffixDistance(identificador, sufixo)`
Altera o sufixo da distância.

```lua
ESPLibrary:SetSuffixDistance("player_1", " metros]")
```

#### `GetESP(identificador)`
Retorna o objeto ESP para manipulação direta.

```lua
local esp = ESPLibrary:GetESP("player_1")
if esp then
    esp:SetColor(Color3.new(0, 1, 1))
    esp:SetName("Novo Nome")
end
```

#### `HasESP(identificador)`
Verifica se um ESP existe.

```lua
if ESPLibrary:HasESP("player_1") then
    print("ESP encontrado!")
end
```

#### `Readjustment(identificador, propriedades)`
Atualiza múltiplas propriedades de um ESP de uma vez.

```lua
ESPLibrary:Readjustment("player_1", {
    Name = "Novo Nome",
    Color = Color3.fromRGB(255, 0, 0),
    PrefixDistance = "<",
    SuffixDistance = ">"
})
```

#### `SetTemplete(identificador, configurações)`
Define templates customizados para reutilização.

```lua
ESPLibrary:SetTemplete("Inimigo", {
    PrefixDistance = "[",
    SuffixDistance = "m]",
    Color = Color3.fromRGB(255, 0, 0)
})
```

### Métodos do Objeto ESP

Após obter um ESP com `GetESP()` ou através de `Library.ESPs`:

```lua
local esp = ESPLibrary.ESPs.identificador
-- ou
local esp = ESPLibrary.ESPs[objeto]

esp:SetColor(Color3.fromRGB(0, 0, 255))
esp:SetName("Novo Nome")
esp:SetSuffixDistance(" metros")
esp:SetPrefixDistance("[")
```

## ⚙️ Configurações

### Enabled (Global)
Ativa/desativa toda a biblioteca.

```lua
ESPLibrary.Enabled = true  -- Liga todos os ESPs
ESPLibrary.Enabled = false -- Desliga todos os ESPs
```

### Config (Componentes)
Controla quais elementos visuais são exibidos globalmente.

```lua
ESPLibrary.Config = {
    Tracer = true,      -- Linha conectando ao alvo
    Name = true,        -- Nome do alvo
    Distance = true,    -- Distância até o alvo
    Outline = true,     -- Contorno do highlight
    Filled = true       -- Preenchimento do highlight
}
```

### Settings (Aparência)
Ajusta a aparência e comportamento dos ESPs.

```lua
ESPLibrary.Settings = {
    -- Distâncias
    MaxDistance = math.huge,        -- Distância máxima de renderização (padrão: infinito)
    MinDistance = 5,                -- Distância mínima para exibição
    
    -- Tracers
    TracerOrigin = "Top",           -- Origem: "Top", "Center", "Bottom", "Left", "Right"
    
    -- Texto
    FontSize = 10,                  -- Tamanho da fonte
    Font = 2,                       -- 0: Legacy, 1: Arial, 2: SourceSansBold, 3: Gotham
    Decimal = false,                -- true: mostra decimais (123.4m), false: inteiro (123m)
    
    -- Rainbow
    Rainbow = false,                -- Ativar modo arco-íris
    RainbowDelay = 8,              -- Velocidade do ciclo (menor = mais rápido)
    
    -- Highlight
    HighlightTransparency = {
        Filled = 0.7,               -- Transparência do preenchimento (0-1)
        Outline = 0.3               -- Transparência do contorno (0-1)
    }
}
```

### Template (Valores Padrão)
Define valores padrão para novos ESPs.

```lua
ESPLibrary.Template.Add = {
    PrefixDistance = "(",
    SuffixDistance = " m)",
    Color = Color3.fromRGB(0, 50, 233)
}
```

## 💡 Exemplos Práticos

### ESP Rainbow para todos os jogadores

```lua
local ESPLibrary = loadstring(game:HttpGet("seu-link"))()

-- Ativar modo rainbow
ESPLibrary.Settings.Rainbow = true
ESPLibrary.Settings.RainbowDelay = 5  -- Ciclo mais rápido

for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer and player.Character then
        ESPLibrary:Add(false, {
            Model = player.Character,
            Name = player.Name
        })
    end
end
```

### ESP com configuração completa

```lua
local ESPLibrary = loadstring(game:HttpGet("seu-link"))()

-- Configuração detalhada
ESPLibrary.Enabled = true
ESPLibrary.Config.Tracer = true
ESPLibrary.Config.Name = true
ESPLibrary.Config.Distance = true
ESPLibrary.Config.Outline = true
ESPLibrary.Config.Filled = true

ESPLibrary.Settings.MaxDistance = 1000
ESPLibrary.Settings.MinDistance = 10
ESPLibrary.Settings.TracerOrigin = "Bottom"
ESPLibrary.Settings.FontSize = 12
ESPLibrary.Settings.Font = 2
ESPLibrary.Settings.Decimal = true
ESPLibrary.Settings.HighlightTransparency.Filled = 0.5
ESPLibrary.Settings.HighlightTransparency.Outline = 0.2

-- Criar ESP
local character = workspace.Player.Character
ESPLibrary:Add(false, {
    Model = character,
    Name = "Alvo Principal",
    Color = Color3.fromRGB(255, 0, 0),
    PrefixDistance = "[",
    SuffixDistance = " metros]"
})
```

### ESP diferenciado por equipe

```lua
local function getTeamColor(player)
    if player.Team then
        return player.Team.TeamColor.Color
    end
    return Color3.fromRGB(255, 255, 255)
end

for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer and player.Character then
        local teamName = player.Team and player.Team.Name or "Sem Time"
        
        ESPLibrary:Add(false, {
            Model = player.Character,
            Name = player.Name .. "\n" .. teamName,
            Color = getTeamColor(player)
        })
    end
end
```

### Sistema de ESP com categorias

```lua
-- Template para inimigos
ESPLibrary.Template.Add = {
    PrefixDistance = "[",
    SuffixDistance = "m]",
    Color = Color3.fromRGB(255, 0, 0)
}

-- ESPs de inimigos
for _, enemy in pairs(workspace.Enemies:GetChildren()) do
    ESPLibrary:Add(false, {
        Model = enemy,
        Name = "Inimigo"
    })
end

-- Mudar template para itens
ESPLibrary.Template.Add = {
    PrefixDistance = "(",
    SuffixDistance = " studs)",
    Color = Color3.fromRGB(255, 215, 0)
}

-- ESPs de itens
for _, item in pairs(workspace.Items:GetChildren()) do
    ESPLibrary:Add(false, {
        Model = item,
        Name = "Item"
    })
end
```

### Atualização dinâmica de ESP

```lua
local character = workspace.Player.Character
ESPLibrary:Add("player", {
    Model = character,
    Name = "Jogador",
    Color = Color3.fromRGB(0, 255, 0)
})

-- Atualizar cor quando tomar dano
character.Humanoid.HealthChanged:Connect(function(health)
    if health < 50 then
        ESPLibrary:SetColor("player", Color3.fromRGB(255, 0, 0))
        ESPLibrary:SetName("player", "Jogador [BAIXA VIDA]")
    else
        ESPLibrary:SetColor("player", Color3.fromRGB(0, 255, 0))
        ESPLibrary:SetName("player", "Jogador")
    end
end)
```

### Toggle rápido de funcionalidades

```lua
-- Criar função de toggle
local function toggleESP()
    ESPLibrary.Enabled = not ESPLibrary.Enabled
    print("ESP:", ESPLibrary.Enabled and "Ativado" or "Desativado")
end

-- Bind em tecla (exemplo com UserInputService)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
        toggleESP()
    end
end)
```

### ESP com atualização de múltiplas propriedades

```lua
local enemy = workspace.Enemy
ESPLibrary:Add(false, {
    Model = enemy,
    Name = "Inimigo Comum"
})

-- Quando virar boss
task.wait(5)
ESPLibrary:Readjustment(enemy, {
    Name = "BOSS",
    Color = Color3.fromRGB(255, 0, 255),
    PrefixDistance = "<<",
    SuffixDistance = ">>"
})
```

## 🎨 Opções de Fonte

```lua
-- Fontes disponíveis
ESPLibrary.Settings.Font = 0  -- Legacy (padrão antigo do Roblox)
ESPLibrary.Settings.Font = 1  -- Arial
ESPLibrary.Settings.Font = 2  -- SourceSansBold (padrão)
ESPLibrary.Settings.Font = 3  -- Gotham
```

## 🔧 Notas Técnicas

- Utiliza `cloneref` quando disponível para maior compatibilidade com anti-cheats
- Sistema de fallback automático para executores sem `gethui`
- Atualização via `RenderStepped` para performance consistente (60 FPS)
- Suporta tanto `Model` quanto `Part` como alvos
- Cálculo de distância otimizado usando magnitude entre posições
- **Identificadores flexíveis**: Use strings para controle manual ou objetos para vinculação direta
- Modo Rainbow utiliza HSV para transições suaves de cor
- Sistema inteligente de visibilidade: ESPs só são renderizados quando visíveis na tela

## 🎯 Quando usar cada tipo de identificador

### Use **strings** quando:
- Precisa de nomes legíveis para debug
- Quer controlar múltiplos ESPs para o mesmo objeto
- Está trabalhando com objetos que podem ser destruídos e recriados
- Precisa de referência persistente independente do objeto

### Use **objetos (false)** quando:
- Quer garantir um ESP único por objeto
- Prefere código mais limpo sem gerenciar IDs manualmente
- Está trabalhando com objetos persistentes
- Quer vinculação automática entre ESP e objeto
- Facilita remoção automática quando o objeto é destruído

## ⚠️ Limitações

- ESPs não funcionam se o modelo alvo for destruído (verificação automática)
- Distância máxima limitada por `Settings.MaxDistance`
- Distância mínima limitada por `Settings.MinDistance`
- Performance pode variar dependendo da quantidade de ESPs ativos
- Ao usar objetos como chave, o ESP é automaticamente vinculado ao ciclo de vida do objeto
- Tracers só aparecem quando o alvo está na tela (onScreen = true)
- Modo Rainbow sobrescreve cores individuais dos ESPs

## 🐛 Troubleshooting

**ESP não aparece:**
- Verifique se `ESPLibrary.Enabled = true`
- Confirme que o componente específico está ativado em `Config`
- Verifique se o objeto está dentro do `MaxDistance` e acima do `MinDistance`
- Certifique-se de que o Model/Part tem uma posição válida

**Performance ruim:**
- Reduza `MaxDistance` para limitar quantos ESPs são renderizados
- Desative componentes desnecessários em `Config`
- Use `Clear()` para remover ESPs não utilizados

**Highlight não aparece:**
- Verifique `Config.Filled` ou `Config.Outline`
- Ajuste `HighlightTransparency` (valores muito altos deixam invisível)

## 📄 Licença

Projeto de código aberto para uso educacional e pessoal.

---

**Nota:** Esta biblioteca foi desenvolvida para fins educacionais. Use com responsabilidade e respeite os termos de serviço do Roblox.
