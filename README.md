# ESP Library para Roblox (1.0.1)

Uma biblioteca completa e otimizada para criar sistemas de ESP (Extra Sensory Perception) em Roblox, oferecendo visualização avançada de objetos e jogadores com múltiplas opções de customização e renderização em tempo real.

---

## 📋 Características

A biblioteca oferece os seguintes recursos visuais:

- **Tracer:** Linha conectando a tela do jogador até o alvo
- **Name:** Exibição de nome personalizado sobre o alvo
- **Distance:** Cálculo e exibição da distância em tempo real
- **Outline:** Contorno destacado ao redor do modelo usando Highlight
- **Filled:** Preenchimento sólido do modelo com cor personalizada
- **Arrow:** Seta indicadora direcional quando o alvo está fora da tela
- **Rainbow Mode:** Efeito de cor arco-íris automático e suave

---

## 🚀 Instalação

```luau
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/ESP-Library/main/Source.lua"))()
```

---

## 📝 Uso Básico

### Adicionar ESP

```luau
-- Com identificador único (recomendado)
local Alvo = Library:Add("Player1", {
    Name = "Jogador Principal",
    Model = game.Players.LocalPlayer.Character,
    Color = Color3.fromRGB(255, 0, 0),
    PrefixDistance = "[",
    SuffixDistance = "m]"
})

-- Sem identificador (usa o Model como chave)
Library:Add(workspace.NPC, {
    Name = "NPC Inimigo",
    Model = workspace.NPC,
    Color = Color3.fromRGB(255, 0, 0),
    Collision = true  -- Adiciona Humanoid se necessário e ajusta transparência
})
```

**Parâmetros disponíveis:**
- `Model` (obrigatório): Instance do modelo/objeto a ser rastreado
- `Name` (opcional): Nome exibido (padrão: nome do Model)
- `Color` (opcional): Cor do ESP (padrão: valor do Template)
- `PrefixDistance` (opcional): Prefixo da distância (ex: "[")
- `SuffixDistance` (opcional): Sufixo da distância (ex: "m]")
- `Collision` (opcional): Adiciona Humanoid e ajusta transparência para colisão
- `Center` (opcional): BasePart customizada como centro de rastreamento
- `Method` (opcional): Método de cálculo de posição ("Position" ou "BoundingBox")

### Remover ESP

```luau
-- Por identificador
Library:Remove("Player1")

-- Por objeto/modelo
Library:Remove(workspace.NPC)
```

### Atualizar ESP

```luau
Library:Update("Player1", {
    Model = workspace.NovoModelo,
    Name = "Nome Atualizado",
    Color = Color3.fromRGB(0, 255, 0)
})
```

### Obter ESP

```luau
-- Por identificador
local ESP = Library:GetESP("Player1")

-- Por objeto/modelo
local ESP = Library:GetESP(workspace.NPC)

-- Verificar se retornou nil
if ESP then
    print("ESP encontrado!")
end
```

### Verificar Existência

```luau
-- Por identificador
if Library:HasESP("Player1") then
    print("ESP existe!")
end

-- Por objeto/modelo
if Library:HasESP(workspace.NPC) then
    print("ESP existe no modelo!")
end
```

### Limpar Todos os ESPs

```luau
-- Remove todos os ESPs ativos
Library:Clear()
```

### Destruir a Library

```luau
-- Remove todos os ESPs e desconecta eventos (cleanup completo)
Library:Destroy()
```

---

## 🎨 Métodos de Customização

### Métodos Individuais por ESP

Cada ESP retornado possui métodos próprios:

```luau
local Alvo = Library:Add("Player1", {...})

-- Alterar cor
Alvo:SetColor(Color3.fromRGB(255, 255, 0))

-- Alterar nome
Alvo:SetName("Novo Nome")

-- Alterar prefixo da distância
Alvo:SetPrefixDistance("Dist: ")

-- Alterar sufixo da distância
Alvo:SetSuffixDistance(" studs")
```

### Métodos Globais da Library

```luau
-- Alterar cor de um ESP específico
Library:SetColor("Player1", Color3.fromRGB(255, 255, 255))

-- Alterar nome
Library:SetName("Player1", "Novo Nome")

-- Alterar prefixo
Library:SetPrefixDistance("Player1", ">>")

-- Alterar sufixo
Library:SetSuffixDistance("Player1", "<<")
```

---

## 🌈 Modo Rainbow

```luau
-- Ativar com velocidade padrão (8)
Library:RainbowMode(true)

-- Ativar com velocidade customizada (1-10, quanto maior mais lento)
Library:RainbowMode(true, 5)

-- Apenas alterar velocidade (mantém estado atual)
Library:RainbowMode(nil, 10)

-- Apenas desativar (mantém velocidade configurada)
Library:RainbowMode(false)

-- Desativar e resetar velocidade
Library:RainbowMode(false, 8)
```

---

## ⚙️ Configurações Globais

### Ativar/Desativar Componentes

```luau
Library.Enabled = true            -- Ativa/desativa toda a biblioteca

Library.Config.Tracer = true      -- Linha até o alvo
Library.Config.Name = true        -- Nome sobre o alvo
Library.Config.Distance = true    -- Distância até o alvo
Library.Config.Outline = true     -- Contorno do modelo (Highlight)
Library.Config.Filled = true      -- Preenchimento do modelo (Highlight)
Library.Config.Arrow = true       -- Seta indicadora quando fora da tela
```

### Configurações de Tracer

```luau
-- Origem da linha tracer na tela
Library.Settings.TracerOrigin = "Bottom"

-- Opções disponíveis:
-- "Top"    - Topo central da tela
-- "Bottom" - Base central da tela (padrão)
-- "Left"   - Centro esquerdo da tela
-- "Right"  - Centro direito da tela
-- "Center" - Centro absoluto da tela
```

### Configurações de Distância

```luau
-- Distância máxima para renderizar ESP
Library.Settings.MaxDistance = math.huge

-- Distância mínima para renderizar ESP
Library.Settings.MinDistance = 5

-- Mostrar casas decimais (true = 125.5m | false = 125m)
Library.Settings.Decimal = false
```

### Configurações de Texto

```luau
-- Tamanho da fonte do texto
Library.Settings.FontSize = 10

-- Tipo de fonte (Drawing.Fonts enum)
-- 0 = UI, 1 = System, 2 = Plex, 3 = Monospace
Library.Settings.Font = 2
```

### Configurações de Rainbow

```luau
-- Ativar/desativar modo rainbow
Library.Settings.Rainbow = false

-- Velocidade da transição (1-10, quanto maior mais lento)
Library.Settings.RainbowDelay = 8
```

### Configurações de Seta (Arrow)

```luau
Library.Settings.Arrow = {
    -- ID da imagem da seta (AssetId)
    Image = 92023845052369,
    
    -- Tamanho da seta na tela
    Size = UDim2.new(0, 40, 0, 40),
    
    -- Rotação base da seta em graus
    Rotation = 90,
    
    -- Raio de detecção da tela (pixels do centro)
    Radius = 360,
    
    -- Distância da seta do centro da tela
    Range = 90
}
```

### Configurações de Transparência (Highlight)

```luau
Library.Settings.HighlightTransparency = {
    -- Transparência do preenchimento (0 = opaco, 1 = invisível)
    Filled = 0.7,
    
    -- Transparência do contorno (0 = opaco, 1 = invisível)
    Outline = 0.3
}
```

### Template Padrão para Novos ESPs

```luau
-- Configurar valores padrão para novos ESPs
Library.Template.Add = {
    PrefixDistance = "(",
    SuffixDistance = " m)",
    Color = Color3.fromRGB(0, 50, 233)
}

-- Também pode usar o método SetTemplate
Library:SetTemplate("Add", {
    PrefixDistance = "[",
    SuffixDistance = "]",
    Color = Color3.fromRGB(255, 0, 0)
})
```

---

## 📊 Estrutura de Dados

### Objeto ESP

Ao adicionar um ESP, você recebe um objeto com as seguintes propriedades e componentes:

```luau
{
    -- Propriedades configuráveis
    Name = "string",              -- Nome exibido
    Model = Instance,             -- Modelo/objeto alvo
    Color = Color3,               -- Cor do ESP
    PrefixDistance = "string",    -- Prefixo da distância
    SuffixDistance = "string",    -- Sufixo da distância
    Center = BasePart or nil,     -- Centro customizado de rastreamento
    Method = "string",            -- Método de cálculo ("Position" ou "BoundingBox")
    
    -- Componentes de renderização (não modificar diretamente)
    Tracer = Drawing,             -- Linha tracer
    TextDraw = Drawing,           -- Texto de nome/distância
    Highlight = Instance,         -- Outline/Filled
    Arrow = ImageLabel,           -- Seta indicadora
    
    -- Métodos disponíveis
    SetColor = function,
    SetName = function,
    SetPrefixDistance = function,
    SetSuffixDistance = function
}
```

---

## 🎯 Sistema de Renderização

### Métodos de Cálculo de Posição

A biblioteca oferece dois métodos para calcular a posição do alvo:

**1. Position (Padrão):**
- Usa `PrimaryPart.Position` para Models
- Usa `BasePart.Position` para partes individuais
- Usa `Center.Position` se especificado

**2. BoundingBox:**
- Calcula o centro da caixa delimitadora do modelo inteiro
- Considera todos os BaseParts descendentes
- Ideal para modelos irregulares ou sem PrimaryPart definida

```luau
-- Usando BoundingBox
Library:Add("Enemy", {
    Model = workspace.Enemy,
    Method = "BoundingBox"
})
```

### Lógica de Visibilidade

A biblioteca usa um sistema inteligente de renderização:

1. **Verificação de Distância:** ESP só renderiza entre `MinDistance` e `MaxDistance`
2. **Detecção de Tela:** Verifica se o alvo está dentro da viewport da câmera
3. **Campo de Visão (FOV):** Calcula se o alvo está dentro do raio configurado
4. **Arrow Automático:** Quando fora da tela/FOV, exibe seta direcional

### Componentes Visíveis por Situação

**Alvo dentro da tela e FOV:**
- ✅ Highlight (Outline + Filled)
- ✅ Tracer
- ✅ Text (Name + Distance)
- ❌ Arrow (oculto)

**Alvo fora da tela ou FOV:**
- ❌ Highlight (oculto)
- ❌ Tracer (oculto)
- ❌ Text (oculto)
- ✅ Arrow (visível e aponta para o alvo)

---

## 🔧 Recursos Avançados

### Suporte a Collision

```luau
-- Adiciona automaticamente Humanoid e ajusta transparência
Library:Add("Enemy", {
    Model = workspace.Enemy,
    Collision = true  -- Útil para NPCs sem Humanoid
})
```

### Centro Customizado de Rastreamento

```luau
-- Define uma parte específica como centro do ESP
Library:Add("Boss", {
    Model = workspace.Boss,
    Center = workspace.Boss.Head  -- ESP aponta para a cabeça
})
```

### Acesso Direto aos ESPs

```luau
-- Acessar tabela de todos os ESPs ativos
for identifier, ESP in pairs(Library.ESPs) do
    print(identifier, ESP.Name, ESP.Color)
end
```

### Compatibilidade com Exploits

A biblioteca usa funções seguras para compatibilidade:
- `cloneref` para serviços (evita detecção)
- `gethui` para UI oculta (não aparece no CoreGui normal)
- `getgenv` para ambiente global customizado

---

## 💡 Dicas e Boas Práticas

1. **Identificadores Únicos:** Use strings descritivas como identificadores para fácil gerenciamento
2. **Performance:** Limite `MaxDistance` para evitar renderizar alvos muito distantes
3. **Rainbow Mode:** Desative quando não necessário para economizar processamento
4. **Limpeza:** Sempre remova ESPs não utilizados com `:Remove()` ou `:Clear()`
5. **Cleanup Completo:** Use `:Destroy()` ao descarregar completamente a library
6. **Cores Contrastantes:** Use cores que se destacam no ambiente do jogo
7. **Font Size:** Ajuste conforme resolução da tela (menor para 1080p+, maior para 720p)
8. **Arrow Range:** Ajuste o Range da seta para deixar mais próximo/distante do centro
9. **BoundingBox:** Use para modelos irregulares ou quando o PrimaryPart não está centralizado
10. **Center Parameter:** Útil para focar em partes específicas (cabeça, torso, etc.)

---

## ⚠️ Observações Importantes

- A biblioteca roda no `RunService.RenderStepped` para renderização em tempo real
- ESPs são automaticamente ocultados quando o Model é destruído ou sai do workspace
- O sistema de Arrow calcula automaticamente a direção mesmo quando o alvo está atrás da câmera
- Highlight requer que o Model tenha um PrimaryPart ou seja um BasePart
- A transparência 0.99 no modo Collision evita invisibilidade total mantendo colisão
- O método `:Destroy()` realiza limpeza completa, desconectando eventos e removendo GUIs
- BoundingBox pode ter custo de performance maior em models com muitas partes
- A biblioteca verifica automaticamente mudanças na câmera do Workspace

---

## 📌 Versão

**Versão Atual:** 1.0.1

**Changelog:**
- ✨ Adicionado método `:Destroy()` para cleanup completo
- ✨ Adicionado suporte ao método "BoundingBox" para cálculo de posição
- ✨ Adicionado parâmetro `Center` para centro customizado de rastreamento
- ✨ Adicionado parâmetro `Method` para escolher método de cálculo
- 🐛 Corrigido comportamento de Arrow quando alvo está atrás da câmera
- ⚡ Otimizado sistema de renderização com detecção de parent nulo
- 🔧 Melhorado sistema de detecção de câmera com PropertyChangedSignal

---

## 🔗 Links

- **Repositório:** [GitHub](https://github.com/DH-SOARESE/ESP-Library)
- **Source:** [Source.lua](https://github.com/DH-SOARESE/ESP-Library/blob/main/Source.lua)
- **Example:** [Example.lua](https://github.com/DH-SOARESE/ESP-Library/blob/main/Example.lua)

```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/ESP-Library/main/Example.lua"))()
```

---

**Nota:** Para exemplos práticos de implementação e casos de uso específicos, consulte o arquivo `Example.lua` no repositório.
