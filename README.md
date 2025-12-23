# ESP Library para Roblox

Uma biblioteca completa de ESP (Extra Sensory Perception) para Roblox, oferecendo visualização avançada de objetos no jogo com tracers, highlights, nomes e distâncias.

## Características

- **Tracers**: Linhas que conectam a origem da tela ao alvo
- **Highlights**: Destaque visual 3D nos modelos
- **Nomes**: Exibição de texto personalizado
- **Distâncias**: Cálculo e exibição de distância em tempo real
- **Gerenciamento individual**: Controle completo de cada ESP criado
- **Performance otimizada**: Sistema eficiente usando RenderStepped

## Instalação

```lua
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/ESP-Library/main/Source.lua"))()
```

## Uso Básico

### Criar um ESP

```lua
local meuESP = ESPLibrary:Add("identificador", {
    Model = workspace.AlgumModelo,
    Name = "Jogador",
    Color = Color3.fromRGB(255, 0, 0)
})
```

### Configuração Global

```lua
-- Ativar/desativar componentes
ESPLibrary.Config.Tracer = true
ESPLibrary.Config.Name = true
ESPLibrary.Config.Distance = true
ESPLibrary.Config.Outline = true
ESPLibrary.Config.Filled = true

-- Ajustes de aparência
ESPLibrary.Settings.MaxDistance = 500
ESPLibrary.Settings.MinDistance = 10
ESPLibrary.Settings.TracerOrigin = "Bottom" -- "Top", "Center", "Bottom", "Left", "Right"
ESPLibrary.Settings.FontSize = 14
ESPLibrary.Settings.Decimal = true -- mostrar casas decimais na distância
```

## Métodos Principais

### Add
Cria um novo ESP para um objeto.

```lua
ESPLibrary:Add(identificador, {
    Model = Instance,
    Name = "Nome Customizado",
    Color = Color3.new(1, 0, 0),
    PrefixDistance = "[",
    SuffixDistance = "m]"
})
```

## Method

```luau
local ESP = Library.ESPs

ESP.identificador:SetColor(Color3.fromRGB(0, 0, 211))
ESP.identificador:SetName("Novo nome")
ESP.identificador:SetSuffixDistance("Novo Suffix")
ESP.identificador:SetPrefixDistance(Novo Prefix")
```

### Remove
Remove um ESP específico.

```lua
ESPLibrary:Remove("identificador")
```

### Clear
Remove todos os ESPs ativos.

```lua
ESPLibrary:Clear()
```

### SetColor
Altera a cor de um ESP.

```lua
ESPLibrary:SetColor("identificador", Color3.fromRGB(0, 255, 0))
```

### SetName
Altera o nome exibido.

```lua
ESPLibrary:SetName("identificador", "Novo Nome")
```

### GetESP
Retorna o objeto ESP para manipulação direta.

```lua
local esp = ESPLibrary:GetESP("identificador")
if esp then
    esp:SetColor(Color3.new(0, 1, 1))
end
```

### HasESP
Verifica se um ESP existe.

```lua
if ESPLibrary:HasESP("identificador") then
    print("ESP encontrado!")
end
```

## Exemplo Completo

```lua
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/ESP-Library/main/Source.lua"))()

-- Configurar biblioteca
ESPLibrary.Settings.MaxDistance = 1000
ESPLibrary.Settings.TracerOrigin = "Bottom"
ESPLibrary.Config.Distance = true

-- Criar ESP para todos os jogadores
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        ESPLibrary:Add(player.Name, {
            Model = player.Character,
            Name = player.Name,
            Color = Color3.fromRGB(255, 100, 100)
        })
    end
end

-- Atualizar quando novos jogadores entrarem
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        ESPLibrary:Add(player.Name, {
            Model = character,
            Name = player.Name,
            Color = Color3.fromRGB(255, 100, 100)
        })
    end)
end)
```

## Configurações Avançadas

### Template
Define valores padrão para novos ESPs.

```lua
ESPLibrary.Template.Add = {
    PrefixDistance = "(",
    SuffixDistance = " studs)",
    Color = Color3.fromRGB(255, 255, 0)
}
```

### Transparência do Highlight

```lua
ESPLibrary.Settings.HighlightTransparency = {
    Filled = 0.5,
    Outline = 0.2
}
```

## Observações

- A biblioteca usa `cloneref` quando disponível para maior compatibilidade
- Sistema de fallback para executores sem `gethui`
- Atualização automática via `RenderStepped` para performance consistente
- Suporta tanto `Model` quanto `Part` como alvos

## Licença

Projeto de código aberto para uso educacional.
