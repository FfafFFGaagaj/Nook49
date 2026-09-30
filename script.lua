-- LocalScript: Delta Executor Supported Version (Fixed Scroll Canvas Issue)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fix Clipboard for Delta / Mobile Executing
local function copyToClipboard(text)
	if setclipboard then
		pcall(setclipboard, text)
	elseif toclipboard then
		pcall(toclipboard, text)
	end
end

-- 1. Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaControlUI"
screenGui.ResetOnSpawn = false

pcall(function()
	screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end)

if not screenGui.Parent then
	screenGui.Parent = game:GetService("CoreGui")
end

-- 2. Main Window
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 360)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

-- 3. Toggle Logo Button
local logoButton = Instance.new("TextButton")
logoButton.Size = UDim2.new(0, 45, 0, 45)
logoButton.Position = UDim2.new(0.05, 0, 0.2, 0)
logoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
logoButton.Text = "SC"
logoButton.TextColor3 = Color3.fromRGB(255, 20, 147)
logoButton.TextSize = 18
logoButton.Font = Enum.Font.FredokaOne
logoButton.Active = true
logoButton.Draggable = true
logoButton.Parent = screenGui

Instance.new("UICorner", logoButton).CornerRadius = UDim.new(1, 0)
local logoStroke = Instance.new("UIStroke", logoButton)
logoStroke.Color = Color3.fromRGB(255, 20, 147)
logoStroke.Thickness = 2

logoButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- 4. Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "DELTA CONTROL"
titleLabel.TextColor3 = Color3.fromRGB(255, 20, 147)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

-- 5. Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 20, 147)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- 6. Mode Buttons (3 แท็บ)
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 30)
tabFrame.Position = UDim2.new(0, 10, 0, 40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local btnMode1 = Instance.new("TextButton")
btnMode1.Size = UDim2.new(0.31, 0, 1, 0)
btnMode1.Position = UDim2.new(0, 0, 0, 0)
btnMode1.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
btnMode1.Text = "รายชื่อ"
btnMode1.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMode1.Font = Enum.Font.SourceSansBold
btnMode1.TextSize = 12
btnMode1.Parent = tabFrame
Instance.new("UICorner", btnMode1)

local btnMode2 = Instance.new("TextButton")
btnMode2.Size = UDim2.new(0.33, 0, 1, 0)
btnMode2.Position = UDim2.new(0.33, 0, 0, 0)
btnMode2.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
btnMode2.Text = "อุ้มทิ้งVoid"
btnMode2.TextColor3 = Color3.fromRGB(100, 100, 100)
btnMode2.Font = Enum.Font.SourceSansBold
btnMode2.TextSize = 12
btnMode2.Parent = tabFrame
Instance.new("UICorner", btnMode2)

local btnMode3 = Instance.new("TextButton")
btnMode3.Size = UDim2.new(0.32, 0, 1, 0)
btnMode3.Position = UDim2.new(0.68, 0, 0, 0)
btnMode3.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
btnMode3.Text = "วาปโซฟา"
btnMode3.TextColor3 = Color3.fromRGB(100, 100, 100)
btnMode3.Font = Enum.Font.SourceSansBold
btnMode3.TextSize = 12
btnMode3.Parent = tabFrame
Instance.new("UICorner", btnMode3)

---------------------------------------------------------
-- MODE 1: PLAYER LIST (FIXED SCROLL)
---------------------------------------------------------
local panelMode1 = Instance.new("Frame")
panelMode1.Size = UDim2.new(1, -20, 1, -80)
panelMode1.Position = UDim2.new(0, 10, 0, 75)
panelMode1.BackgroundTransparency = 1
panelMode1.Parent = mainFrame

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(1, 0, 0, 28)
refreshBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
refreshBtn.Text = "🔄 รีเฟรชรายชื่อผู้เล่น"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.Font = Enum.Font.SourceSansBold
refreshBtn.TextSize = 13
refreshBtn.Parent = panelMode1
Instance.new("UICorner", refreshBtn)

local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(1, 0, 1, -35)
scrollList.Position = UDim2.new(0, 0, 0, 35)
scrollList.BackgroundTransparency = 1
scrollList.BorderSizePixel = 0
scrollList.ScrollBarThickness = 6
scrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y -- สั่งปรับขนาดพื้นที่เลื่อนอัตโนมัติ
scrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollList.Parent = panelMode1

local uiList = Instance.new("UIListLayout")
uiList.Parent = scrollList
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 4)

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 2)
uiPadding.PaddingBottom = UDim.new(0, 10) -- เพิ่มระยะเว้นด้านล่างสุด
uiPadding.Parent = scrollList

local targetInput = Instance.new("TextBox")

local function updatePlayerList()
	for _, child in pairs(scrollList:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local pItemFrame = Instance.new("Frame")
			pItemFrame.Size = UDim2.new(1, -10, 0, 30)
			pItemFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
			pItemFrame.Parent = scrollList
			Instance.new("UICorner", pItemFrame)

			local pLabel = Instance.new("TextLabel")
			pLabel.Size = UDim2.new(0.68, -5, 1, 0)
			pLabel.Position = UDim2.new(0, 5, 0, 0)
			pLabel.BackgroundTransparency = 1
			pLabel.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
			pLabel.TextColor3 = Color3.fromRGB(255, 20, 147)
			pLabel.TextXAlignment = Enum.TextXAlignment.Left
			pLabel.Font = Enum.Font.SourceSansBold
			pLabel.TextSize = 11
			pLabel.Parent = pItemFrame

			local copyBtn = Instance.new("TextButton")
			copyBtn.Size = UDim2.new(0.3, 0, 0.8, 0)
			copyBtn.Position = UDim2.new(0.68, 0, 0.1, 0)
			copyBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
			copyBtn.Text = "📋 คัดลอก"
			copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			copyBtn.Font = Enum.Font.SourceSansBold
			copyBtn.TextSize = 10
			copyBtn.Parent = pItemFrame
			Instance.new("UICorner", copyBtn)

			copyBtn.MouseButton1Click:Connect(function()
				copyToClipboard(plr.Name)
				targetInput.Text = plr.Name
				copyBtn.Text = "✓ เลือกแล้ว"
				copyBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
				task.wait(1)
				copyBtn.Text = "📋 คัดลอก"
				copyBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
			end)
		end
	end
end

refreshBtn.MouseButton1Click:Connect(updatePlayerList)

---------------------------------------------------------
-- MODE 2: DELTA ORBIT & DROP
---------------------------------------------------------
local panelMode2 = Instance.new("Frame")
panelMode2.Size = UDim2.new(1, -20, 1, -80)
panelMode2.Position = UDim2.new(0, 10, 0, 75)
panelMode2.BackgroundTransparency = 1
panelMode2.Visible = false
panelMode2.Parent = mainFrame

targetInput.Size = UDim2.new(1, 0, 0, 30)
targetInput.Position = UDim2.new(0, 0, 0, 0)
targetInput.PlaceholderText = "พิมพ์ชื่อผู้เล่น..."
targetInput.Text = ""
targetInput.TextColor3 = Color3.fromRGB(0, 0, 0)
targetInput.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
targetInput.Font = Enum.Font.SourceSans
targetInput.TextSize = 13
targetInput.Parent = panelMode2
Instance.new("UICorner", targetInput)

local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(1, 0, 0, 20)
radiusLabel.Position = UDim2.new(0, 0, 0, 35)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "ระยะหมุนวนรอบผู้เล่น: 3"
radiusLabel.TextColor3 = Color3.fromRGB(255, 20, 147)
radiusLabel.Font = Enum.Font.SourceSansBold
radiusLabel.TextSize = 12
radiusLabel.Parent = panelMode2

local radiusInput = Instance.new("TextBox")
radiusInput.Size = UDim2.new(1, 0, 0, 30)
radiusInput.Position = UDim2.new(0, 0, 0, 58)
radiusInput.Text = "3"
radiusInput.PlaceholderText = "ปรับระยะวน (1 - 100)"
radiusInput.TextColor3 = Color3.fromRGB(0, 0, 0)
radiusInput.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
radiusInput.Font = Enum.Font.SourceSans
radiusInput.TextSize = 13
radiusInput.Parent = panelMode2
Instance.new("UICorner", radiusInput)

radiusInput.FocusLost:Connect(function()
	local val = tonumber(radiusInput.Text) or 3
	val = math.clamp(val, 1, 100)
	radiusInput.Text = tostring(val)
	radiusLabel.Text = "ระยะหมุนวนรอบผู้เล่น: " .. tostring(val)
end)

local actionBtn = Instance.new("TextButton")
actionBtn.Size = UDim2.new(1, 0, 0, 40)
actionBtn.Position = UDim2.new(0, 0, 0, 98)
actionBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
actionBtn.Text = "🚀 วนรอบเป้าหมาย + ดึงลงใต้แมพ"
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
actionBtn.Font = Enum.Font.SourceSansBold
actionBtn.TextSize = 14
actionBtn.Parent = panelMode2
Instance.new("UICorner", actionBtn)

actionBtn.MouseButton1Click:Connect(function()
	task.spawn(function()
		local targetName = targetInput.Text:lower()
		if targetName == "" then return end
		
		local orbitRadius = tonumber(radiusInput.Text) or 3
		orbitRadius = math.clamp(orbitRadius, 1, 100)
		
		local targetPlayer = nil
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and (p.Name:lower():find(targetName) or p.DisplayName:lower():find(targetName)) then
				targetPlayer = p
				break
			end
		end
		
		if not targetPlayer then return end

		local myChar = LocalPlayer.Character
		local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
		local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
		
		if myHRP and targetHRP then
			local originalCFrame = myHRP.CFrame
			local isSeated = false
			local angle = 0
			local startTime = tick()
			
			actionBtn.Text = "🔄 กำลังหมุนวนรอจับนั่ง..."
			
			while (tick() - startTime) < 3 do
				if targetHumanoid and targetHumanoid.Sit then
					isSeated = true
					break
				end
				
				angle = angle + 0.5
				local offsetX = math.cos(angle) * orbitRadius
				local offsetZ = math.sin(angle) * orbitRadius
				
				if targetHRP and targetHRP.Parent then
					myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(offsetX, 0, offsetZ), targetHRP.Position)
				end
				
				task.wait(0.02)
			end
			
			if isSeated then
				actionBtn.Text = "💥 จับได้แล้ว! ทิ้งใต้แมพ"
				myHRP.CFrame = CFrame.new(myHRP.Position.X, myHRP.Position.Y - 80, myHRP.Position.Z)
				task.wait(0.3)
				
				local myHumanoid = myChar:FindFirstChildOfClass("Humanoid")
				if myHumanoid then
					myHumanoid:UnequipTools()
				end
				
				task.wait(0.2)
				myHRP.CFrame = originalCFrame
				actionBtn.Text = "✅ สำเร็จ!"
			else
				myHRP.CFrame = originalCFrame
				actionBtn.Text = "⚠️ ยังไม่ยอมนั่ง (กดอีกครั้ง)"
			end
			
			task.wait(1.5)
			actionBtn.Text = "🚀 วนรอบเป้าหมาย + ดึงลงใต้แมพ"
		end
	end)
end)

---------------------------------------------------------
-- MODE 3: SOFA TP, WALK & AUTO RETURN
---------------------------------------------------------
local panelMode3 = Instance.new("Frame")
panelMode3.Size = UDim2.new(1, -20, 1, -80)
panelMode3.Position = UDim2.new(0, 10, 0, 75)
panelMode3.BackgroundTransparency = 1
panelMode3.Visible = false
panelMode3.Parent = mainFrame

local sofaCFrame = CFrame.new(-82.0, 19.2, -129.1)

local sofaDescLabel = Instance.new("TextLabel")
sofaDescLabel.Size = UDim2.new(1, 0, 0, 45)
sofaDescLabel.Position = UDim2.new(0, 0, 0, 0)
sofaDescLabel.BackgroundTransparency = 1
sofaDescLabel.Text = "วาร์ปไปโซฟา -> ขยับซ้าย-ขวา (3วิ)\n-> วาร์ปกลับจุดเดิมอัตโนมัติ"
sofaDescLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
sofaDescLabel.Font = Enum.Font.SourceSans
sofaDescLabel.TextSize = 13
sofaDescLabel.Parent = panelMode3

local sofaTpBtn = Instance.new("TextButton")
sofaTpBtn.Size = UDim2.new(1, 0, 0, 45)
sofaTpBtn.Position = UDim2.new(0, 0, 0, 55)
sofaTpBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
sofaTpBtn.Text = "🛋️ วาร์ปไปโซฟา + ขยับ + กลับ"
sofaTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sofaTpBtn.Font = Enum.Font.SourceSansBold
sofaTpBtn.TextSize = 14
sofaTpBtn.Parent = panelMode3
Instance.new("UICorner", sofaTpBtn)

sofaTpBtn.MouseButton1Click:Connect(function()
	task.spawn(function()
		local myChar = LocalPlayer.Character
		local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
		local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")

		if myHRP and myHumanoid then
			local startCFrame = myHRP.CFrame
			
			sofaTpBtn.Text = "⚡ กำลังวาร์ปไปโซฟา..."
			myHRP.CFrame = sofaCFrame
			task.wait(0.3)

			sofaTpBtn.Text = "🚶 กำลังขยับซ้าย-ขวา..."
			
			for i = 1, 2 do
				myHumanoid:Move(Vector3.new(-1, 0, 0), true)
				task.wait(0.75)
				myHumanoid:Move(Vector3.new(1, 0, 0), true)
				task.wait(0.75)
			end
			
			myHumanoid:Move(Vector3.new(0, 0, 0), true)
			
			sofaTpBtn.Text = "🔙 กำลังวาร์ปกลับจุดเดิม..."
			task.wait(0.1)
			myHRP.CFrame = startCFrame
			
			sofaTpBtn.Text = "✅ เสร็จสิ้น!"
			task.wait(1.5)
			sofaTpBtn.Text = "🛋️ วาร์ปไปโซฟา + ขยับ + กลับ"
		end
	end)
end)

---------------------------------------------------------
-- TAB SWITCHING
---------------------------------------------------------
btnMode1.MouseButton1Click:Connect(function()
	panelMode1.Visible = true
	panelMode2.Visible = false
	panelMode3.Visible = false
	btnMode1.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
	btnMode1.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnMode2.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	btnMode2.TextColor3 = Color3.fromRGB(100, 100, 100)
	btnMode3.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	btnMode3.TextColor3 = Color3.fromRGB(100, 100, 100)
	updatePlayerList()
end)

btnMode2.MouseButton1Click:Connect(function()
	panelMode1.Visible = false
	panelMode2.Visible = true
	panelMode3.Visible = false
	btnMode2.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
	btnMode2.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnMode1.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	btnMode1.TextColor3 = Color3.fromRGB(100, 100, 100)
	btnMode3.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	btnMode3.TextColor3 = Color3.fromRGB(100, 100, 100)
end)

btnMode3.MouseButton1Click:Connect(function()
	panelMode1.Visible = false
	panelMode2.Visible = false
	panelMode3.Visible = true
	btnMode3.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
	btnMode3.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnMode1.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	btnMode1.TextColor3 = Color3.fromRGB(100, 100, 100)
	btnMode2.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	btnMode2.TextColor3 = Color3.fromRGB(100, 100, 100)
end)

updatePlayerList()
