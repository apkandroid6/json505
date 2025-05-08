-- json505 Expanded Commands
-- Place this in StarterPlayerScripts or execute via an executor

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local PlayerGui = player:WaitForChild("PlayerGui")

-- === UI Setup ===
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "json505"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "json505 Admin Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local input = Instance.new("TextBox", mainFrame)
input.PlaceholderText = "Enter command"
input.Size = UDim2.new(1, -20, 0, 30)
input.Position = UDim2.new(0, 10, 0, 50)
input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
input.TextColor3 = Color3.new(1, 1, 1)
input.Font = Enum.Font.SourceSans
input.TextSize = 16

local output = Instance.new("TextLabel", mainFrame)
output.Size = UDim2.new(1, -20, 0, 290)
output.Position = UDim2.new(0, 10, 0, 90)
output.BackgroundTransparency = 1
output.TextColor3 = Color3.new(1, 1, 1)
output.Font = Enum.Font.Code
output.TextWrapped = true
output.TextYAlignment = Enum.TextYAlignment.Top
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextSize = 14
output.Text = "[json505] Ready.\n"

-- === Fly Logic ===
local flying = false
local flyGui = nil
local bodyGyro, bodyVelocity
local moveVector = Vector3.new()

local function createFlyGui()
    flyGui = Instance.new("Frame", gui)
    flyGui.Size = UDim2.new(0, 180, 0, 180)
    flyGui.Position = UDim2.new(1, -200, 1, -200)
    flyGui.BackgroundTransparency = 1
    
    local directions = {
    {key = "W", pos = UDim2.new(0.33, 0, 0, 0), vec = Vector3.new(0, 0, -1)},
    {key = "A", pos = UDim2.new(0, 0, 0.33, 0), vec = Vector3.new(-1, 0, 0)},
    {key = "S", pos = UDim2.new(0.33, 0, 0.66, 0), vec = Vector3.new(0, 0, 1)},
    {key = "D", pos = UDim2.new(0.66, 0, 0.33, 0), vec = Vector3.new(1, 0, 0)},
    {key = "↑", pos = UDim2.new(0.8, 0, 0, 0), vec = Vector3.new(0, 1, 0)},
    {key = "↓", pos = UDim2.new(0.8, 0, 0.66, 0), vec = Vector3.new(0, -1, 0)},
    }
    
    for _, dir in ipairs(directions) do
        local btn = Instance.new("TextButton", flyGui)
        btn.Text = dir.key
        btn.Size = UDim2.new(0.3, 0, 0.3, 0)
        btn.Position = dir.pos
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 20
        btn.MouseButton1Down:Connect(function()
            moveVector = moveVector + dir.vec
        end)
        btn.MouseButton1Up:Connect(function()
            moveVector = moveVector - dir.vec
        end)
    end
    
    local cancelBtn = Instance.new("TextButton", flyGui)
    cancelBtn.Text = "X"
    cancelBtn.Size = UDim2.new(0.2, 0, 0.2, 0)
    cancelBtn.Position = UDim2.new(0.8, 0, 0.4, 0)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    cancelBtn.TextColor3 = Color3.new(1, 1, 1)
    cancelBtn.Font = Enum.Font.SourceSansBold
    cancelBtn.TextSize = 20
    cancelBtn.MouseButton1Click:Connect(function()
        stopFly()
    end)
end

function startFly()
    if flying then return end
        flying = true
        moveVector = Vector3.new()
        output.Text = output.Text .. "\n[+] Fly enabled."
        
        bodyGyro = Instance.new("BodyGyro", root)
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = root.CFrame
        
        bodyVelocity = Instance.new("BodyVelocity", root)
        bodyVelocity.Velocity = Vector3.new()
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        createFlyGui()
        
        RunService.RenderStepped:Connect(function()
            if flying then
                local cam = workspace.CurrentCamera
                bodyGyro.CFrame = cam.CFrame
                if moveVector.Magnitude > 0 then
                    bodyVelocity.Velocity = cam.CFrame:VectorToWorldSpace(moveVector.Unit * 50)
                else
                    bodyVelocity.Velocity = Vector3.zero
                end
            end
        end)
    end
    
    function stopFly()
        if not flying then return end
            flying = false
            if bodyGyro then bodyGyro:Destroy() end
                if bodyVelocity then bodyVelocity:Destroy() end
                    if flyGui then flyGui:Destroy() end
                        output.Text = output.Text .. "\n[-] Fly disabled."
                    end
                    
                    -- === Additional Commands ===
                    function changeSpeed(speed)
                        humanoid.WalkSpeed = speed
                        output.Text = output.Text .. "\n[+] Speed set to " .. speed
                    end
                    
                    function toggleGodMode()
                        if humanoid.Health == humanoid.MaxHealth then
                            humanoid.Health = 0
                            output.Text = output.Text .. "\n[+] Godmode activated."
                        else
                            humanoid.Health = humanoid.MaxHealth
                            output.Text = output.Text .. "\n[-] Godmode deactivated."
                        end
                    end
                    
                    function makeInvisible()
                        if character:FindFirstChild("HumanoidRootPart") then
                            for _, part in pairs(character:GetChildren()) do
                                if part:IsA("MeshPart") or part:IsA("Part") then
                                    part.Transparency = 1
                                end
                            end
                            output.Text = output.Text .. "\n[+] You are now invisible."
                        end
                    end
                    
                    function teleportTo(x, y, z)
                        root.CFrame = CFrame.new(x, y, z)
                        output.Text = output.Text .. "\n[+] Teleported to " .. x .. ", " .. y .. ", " .. z
                    end
                    
                    -- === Fling and Kill Functions ===
                    function flingPlayer(targetPlayer)
                        local char = targetPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local hrp = char.HumanoidRootPart
                            local bv = Instance.new("BodyVelocity")
                            bv.Velocity = Vector3.new(math.random(-100, 100), math.random(100, 200), math.random(-100, 100))
                            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                            bv.Parent = hrp
                            Debris:AddItem(bv, 0.5)
                            output.Text = output.Text .. "\n[+] Flinged " .. targetPlayer.Name
                        end
                    end
                    
                    function killPlayer(targetPlayer)
                        local char = targetPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid.Health = 0
                            output.Text = output.Text .. "\n[+] Killed " .. targetPlayer.Name
                        end
                    end
                    
                    -- === Command Handler ===
                    input.FocusLost:Connect(function(enterPressed)
                        if not enterPressed then return end
                            local cmd = input.Text:lower()
                            input.Text = ""
                            
                            if cmd == ";fly" then
                                if flying then stopFly() else startFly() end
                                elseif cmd == ";noclip" then
                                    output.Text = output.Text .. "\n[~] Noclip not implemented yet."
                                elseif cmd:match("^;speed (%d+)$") then
                                    local speed = tonumber(cmd:match("^;speed (%d+)$"))
                                    if speed then changeSpeed(speed) end
                                    elseif cmd == ";invisible" then
                                        makeInvisible()
                                    elseif cmd == ";godmode" then
                                        toggleGodMode()
                                    elseif cmd:match("^;teleport (%d+), (%d+), (%d+)$") then
                                        local x, y, z = cmd:match("^;teleport (%d+), (%d+), (%d+)$")
                                        teleportTo(0)
                                    elseif cmd:match("^;fling (.+)$") then
                                        local targetName = cmd:match("^;fling (.+)$")
                                        for _, p in ipairs(Players:GetPlayers()) do
                                            if p.Name:lower():find(targetName) then
                                                flingPlayer(p)
                                                break
                                            end
                                        end
                                    elseif cmd:match("^;kill (.+)$") then
                                        local targetName = cmd:match("^;kill (.+)$")
                                        for _, p in ipairs(Players:GetPlayers()) do
                                            if p.Name:lower():find(targetName) then
                                                killPlayer(p)
                                                break
                                            end
                                        end
                                    else
                                        output.Text = output.Text .. "\n[!] Unknown command: " .. cmd
                                    end
                                end)
