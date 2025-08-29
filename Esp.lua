local CloneRef = cloneref or function(instance)
    return instance
end

Players = CloneRef(game:GetService("Players"))
RunService = CloneRef(game:GetService("RunService"))

Player = Players.LocalPlayer

ActiveESP = {}
ESPEnabled = false
ESPConnection = nil
CurrentConfig = nil

local function IsPlayerFriend(character)
    if not CurrentConfig.Friends.Enabled then return false end
    
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        local success, isFriend = pcall(function()
            return Player:IsFriendsWith(player.UserId)
        end)
        return success and isFriend
    end
    return false
end

local function GetHealthColor(health)
    if health > 75 then
        return CurrentConfig.HealthColors.High
    elseif health > 25 then
        return CurrentConfig.HealthColors.Medium
    else
        return CurrentConfig.HealthColors.Low
    end
end

local function GetTeamColor(character)
    local player = Players:GetPlayerFromCharacter(character)
    if player and player.Team then
        return player.Team.TeamColor.Color
    end
    return Color3.fromRGB(255, 255, 255)
end

local function GetDistance(character)
    if not Player.Character then return 0 end
    
    local playerRoot = Player.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = character:FindFirstChild("HumanoidRootPart")
    
    if playerRoot and targetRoot then
        return math.floor((playerRoot.Position - targetRoot.Position).Magnitude)
    end
    return 0
end

local function GetESPColor(character)
    if IsPlayerFriend(character) then
        return CurrentConfig.Friends.Color
    end
    
    if CurrentConfig.Highlight.ColorMode == 'health' then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            return GetHealthColor(humanoid.Health)
        end
    elseif CurrentConfig.Highlight.ColorMode == 'team' then
        return GetTeamColor(character)
    end
    return CurrentConfig.Highlight.StaticColor
end

local function CreateESPText(character)
    local player = Players:GetPlayerFromCharacter(character)
    if not player then return "Unknown" end
    
    local parts = {}
    
    if CurrentConfig.Text.ShowName then
        table.insert(parts, player.Name)
    end
    
    if CurrentConfig.Text.ShowHealth then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            table.insert(parts, "HP: " .. math.floor(humanoid.Health))
        end
    end
    
    if CurrentConfig.Text.ShowStuds then
        local distance = GetDistance(character)
        table.insert(parts, "Studs: " .. distance)
    end
    
    return table.concat(parts, " | ")
end

local function ShouldShowESP(character)
    if CurrentConfig.ExcludeSelf and character == Player.Character then
        return false
    end
    
    return true
end

local function UpdateESP(character)
    if not ActiveESP[character] then return end
    
    local espData = ActiveESP[character]
    
    if espData.highlight then
        if CurrentConfig.Highlight.ColorMode == 'team' then
            espData.highlight.FillColor = GetTeamColor(character)
            espData.highlight.OutlineColor = GetTeamColor(character)
        else
            local color = GetESPColor(character)
            espData.highlight.FillColor = color
            espData.highlight.OutlineColor = color
        end
    end
    
    if espData.textLabel then
        espData.textLabel.Text = CreateESPText(character)
        if CurrentConfig.Highlight.ColorMode == 'team' then
            espData.textLabel.TextColor3 = GetTeamColor(character)
        else
            espData.textLabel.TextColor3 = GetESPColor(character)
        end
    end
end

local function CreateESP(character)
    if not ShouldShowESP(character) then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoidRootPart or not humanoid then return end
    
    if ActiveESP[character] then
        RemoveESP(character)
    end
    
    local highlight, billboardGui, textLabel
    
    if CurrentConfig.Highlight.Enabled then
        highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillTransparency = CurrentConfig.Highlight.FillTransparency
        highlight.OutlineTransparency = CurrentConfig.Highlight.OutlineTransparency
    end
    
    if CurrentConfig.Text.Enabled then
        billboardGui = Instance.new("BillboardGui")
        billboardGui.Parent = character
        billboardGui.Adornee = humanoidRootPart
        billboardGui.Size = UDim2.new(0, 200, 0, 30)
        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
        billboardGui.AlwaysOnTop = true
        
        textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboardGui
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.TextSize = CurrentConfig.Text.Size
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.Font = Enum.Font.GothamBold
    end
    
    local connections = {}
    
    if humanoid and CurrentConfig.Highlight.ColorMode == 'health' then
        connections.healthChanged = humanoid.HealthChanged:Connect(function()
            UpdateESP(character)
        end)
    end
    
    local player = Players:GetPlayerFromCharacter(character)
    if player and CurrentConfig.Highlight.ColorMode == 'team' then
        connections.teamChanged = player:GetPropertyChangedSignal("Team"):Connect(function()
            UpdateESP(character)
        end)
    end
    
    connections.ancestryChanged = character.AncestryChanged:Connect(function()
        if not character.Parent then
            RemoveESP(character)
        end
    end)
    
    if CurrentConfig.Text.ShowStuds then
        connections.distanceUpdate = RunService.Heartbeat:Connect(function()
            if ActiveESP[character] and ActiveESP[character].textLabel then
                UpdateESP(character)
            end
        end)
    end
    
    ActiveESP[character] = {
        highlight = highlight,
        billboardGui = billboardGui,
        textLabel = textLabel,
        connections = connections
    }
    
    UpdateESP(character)
end

function RemoveESP(character)
    if not ActiveESP[character] then return end
    
    local espData = ActiveESP[character]
    
    if espData.connections then
        for _, connection in pairs(espData.connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
    
    if espData.highlight then
        espData.highlight:Destroy()
    end
    if espData.billboardGui then
        espData.billboardGui:Destroy()
    end
    
    ActiveESP[character] = nil
end

local function SetupPlayer(player)
    if player == Player then return end
    
    if player.Character then
        CreateESP(player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        task.wait(0.1)
        if ESPEnabled then
            CreateESP(character)
        end
    end)
end

local function Esp(State, Config)
    ESPEnabled = State
    CurrentConfig = Config or getgenv().config
    
    if State then
        for _, player in pairs(Players:GetPlayers()) do
            SetupPlayer(player)
        end
        
        ESPConnection = Players.PlayerAdded:Connect(SetupPlayer)
        
        Players.PlayerRemoving:Connect(function(player)
            if player.Character and ActiveESP[player.Character] then
                RemoveESP(player.Character)
            end
        end)
    else
        if ESPConnection then
            ESPConnection:Disconnect()
            ESPConnection = nil
        end
        
        for character, _ in pairs(ActiveESP) do
            RemoveESP(character)
        end
    end
end

return Esp
