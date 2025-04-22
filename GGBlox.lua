-- إعدادات
_G.AutoFruitSniper = false

-- GUI الزر
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 100, 0, 40)
Toggle.Position = UDim2.new(0.5, -50, 0.3, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Toggle.Text = "تشغيل"
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 18
Toggle.Active = true
Toggle.Draggable = true
Instance.new("UICorner", Toggle)

-- Anti AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

-- جمع الفواكه
function collectFruits()
    for _,v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") and v.Name:lower():find("fruit") then
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = v.Handle.CFrame
                wait(0.3)
                firetouchinterest(hrp, v.Handle, 0)
                firetouchinterest(hrp, v.Handle, 1)
                wait(0.3)
            end
        end
    end
end

-- تنقل سيرفرات (محسّن)
function serverHop()
    local tpService = game:GetService("TeleportService")
    local http = game:HttpGet("https://games.roblox.com/v1/games/2753915549/servers/Public?sortOrder=2&limit=100")
    local servers = game:GetService("HttpService"):JSONDecode(http)
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers then
            tpService:TeleportToPlaceInstance(2753915549, server.id, game.Players.LocalPlayer)
            break
        end
    end
end

-- تفعيل التبديل بالزر
Toggle.MouseButton1Click:Connect(function()
    _G.AutoFruitSniper = not _G.AutoFruitSniper
    Toggle.Text = _G.AutoFruitSniper and "إيقاف" or "تشغيل"
    Toggle.BackgroundColor3 = _G.AutoFruitSniper and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,170,255)
end)

-- حلقة مستمرة
spawn(function()
    while true do
        if _G.AutoFruitSniper then
            local found = false
            for _,v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and v.Name:lower():find("fruit") then
                    found = true
                    break
                end
            end
            if found then
                collectFruits()
            else
                wait(5)
                serverHop()
            end
        end
        wait(5)
    end
end)
