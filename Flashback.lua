local Flashback = {}

local FlashbackLength = 10000
local FlashbackSpeed = 0.75

local cloneref = cloneref or function(Instance) return Instance end
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local CoreGui = cloneref(game:GetService("CoreGui"))

local LocalPlayer = Players.LocalPlayer
local Frames = {}
local RenderStepName = nil
local FlashbackGui = nil

local FlashbackSystem = {LastInput=false, CanRevert=true, Active=false}

local function RandomString()
    local Length = math.random(10, 20)
    local Array = {}
    for I = 1, Length do
        Array[I] = string.char(math.random(32, 126))
    end
    return table.concat(Array)
end

local function CreateCorner(Parent, Radius)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, Radius or 6)
    Corner.Parent = Parent
    return Corner
end

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoidRootPart(Character)
    return Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("RootPart") or Character:FindFirstChild("PrimaryPart") or Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso") or Character:FindFirstChildWhichIsA("BasePart")
end

local function HandleDrag(Element, Callback)
    local IsDragging, Start, Start2
    local CurrentInput

    local function IsClick(Input)
        return (Input.Position - Start).Magnitude < 5
    end

    local function UpdatePosition(Input)
        local Delta = Input.Position - Start
        Element.Position = UDim2.new(
            Start2.X.Scale, Start2.X.Offset + Delta.X,
            Start2.Y.Scale, Start2.Y.Offset + Delta.Y
        )
    end

    Element.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = true
            Start = Input.Position
            Start2 = Element.Position
        end
    end)

    Element.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            CurrentInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == CurrentInput and IsDragging then
            UpdatePosition(Input)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            IsDragging = false
            if IsClick(Input) then
                Callback()
            end
        end
    end)
end

function FlashbackSystem:Advance(Character, HumanoidRootPart, Humanoid, AllowInput)
    if #Frames > FlashbackLength * 60 then
        table.remove(Frames, 1)
    end
    if AllowInput and not self.CanRevert then
        self.CanRevert = true
    end
    if self.LastInput then
        Humanoid.PlatformStand = false
        self.LastInput = false
    end
    table.insert(Frames, {
        HumanoidRootPart.CFrame,
        HumanoidRootPart.Velocity,
        Humanoid:GetState(),
        Humanoid.PlatformStand,
        Character:FindFirstChildOfClass("Tool")
    })
end

function FlashbackSystem:Revert(Character, HumanoidRootPart, Humanoid)
    local Num = #Frames
    if Num == 0 or not self.CanRevert then
        self.CanRevert = false
        self:Advance(Character, HumanoidRootPart, Humanoid)
        return
    end
    for i = 1, FlashbackSpeed do
        if Num > 0 then
            table.remove(Frames, Num)
            Num = Num - 1
        end
    end
    if Num > 0 then
        self.LastInput = true
        local LastFrame = Frames[Num]
        table.remove(Frames, Num)
        HumanoidRootPart.CFrame = LastFrame[1]
        HumanoidRootPart.Velocity = -LastFrame[2]
        Humanoid:ChangeState(LastFrame[3])
        Humanoid.PlatformStand = LastFrame[4]
        local CurrentTool = Character:FindFirstChildOfClass("Tool")
        if LastFrame[5] then
            if not CurrentTool then
                Humanoid:EquipTool(LastFrame[5])
            end
        else
            Humanoid:UnequipTools()
        end
    end
end

local function Step()
    pcall(function()
        local Character = GetCharacter()
        if not Character then return end
        local HumanoidRootPart = GetHumanoidRootPart(Character)
        local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
        if not HumanoidRootPart or not Humanoid then return end
        
        if FlashbackSystem.Active then
            FlashbackSystem:Revert(Character, HumanoidRootPart, Humanoid)
        else
            FlashbackSystem:Advance(Character, HumanoidRootPart, Humanoid, true)
        end
    end)
end

FlashbackGui = Instance.new("ScreenGui")
FlashbackGui.Name = RandomString()
FlashbackGui.Parent = CoreGui
FlashbackGui.ResetOnSpawn = false
FlashbackGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FlashbackGui.Visible = false

local Frame = Instance.new("Frame")
Frame.Name = RandomString()
Frame.Size = UDim2.new(0, 120, 0, 40)
Frame.Position = UDim2.new(0.5, -60, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = FlashbackGui
Frame.ZIndex = 10000

CreateCorner(Frame, 6)

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(50, 50, 50)
UIStroke.Parent = Frame

local FlashbackButton = Instance.new("TextLabel")
FlashbackButton.Name = RandomString()
FlashbackButton.Size = UDim2.new(1, 0, 1, 0)
FlashbackButton.Position = UDim2.new(0, 0, 0, 0)
FlashbackButton.BackgroundTransparency = 1
FlashbackButton.Text = "Flashback"
FlashbackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlashbackButton.Font = Enum.Font.Gotham
FlashbackButton.TextSize = 14
FlashbackButton.ZIndex = 10001
FlashbackButton.Parent = Frame

HandleDrag(Frame, function()
    FlashbackSystem.Active = not FlashbackSystem.Active
    FlashbackButton.Text = FlashbackSystem.Active and "Stop" or "Flashback"
    FlashbackButton.TextColor3 = FlashbackSystem.Active and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 255, 255)
end)

function Flashback.Toggle(State)
    if State then
        if not RenderStepName then
            RenderStepName = RandomString()
            RunService:BindToRenderStep(RenderStepName, 1, Step)
        end
        FlashbackGui.Enabled = true
    else
        FlashbackGui.Enabled = false
    end
end

return Flashback
