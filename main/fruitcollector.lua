local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local fruitChooser = player:WaitForChild("PlayerGui"):WaitForChild("MainGUI"):WaitForChild("FruitChooser")
local collectEvent = ReplicatedStorage:WaitForChild("CollectFruit", 10)

local fruitList = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil",
    "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit",
    "Mango", "Grape", "Soul Fruit", "Cursed Fruit", "Mushroom", "Pineapple", "Peach",
    "Raspberry", "Pear", "Papaya", "Banana", "Passionfruit", "Moon Melon", "Moon Mango",
    "Candy Blossom", "Red Lollipop"
}

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FruitCollectorGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 300)
frame.Position = UDim2.new(0.5, -130, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 1
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Fruit Auto Collector"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -90)
scroll.Position = UDim2.new(0, 10, 0, 35)
scroll.CanvasSize = UDim2.new(0, 0, 0, #fruitList * 25)
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1

local checkboxes = {}
local selectedFruits = {}

for i, fruit in ipairs(fruitList) do
    local cb = Instance.new("TextButton", scroll)
    cb.Size = UDim2.new(1, -10, 0, 25)
    cb.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    cb.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    cb.Text = "[ ] " .. fruit
    cb.TextColor3 = Color3.new(1, 1, 1)
    cb.Font = Enum.Font.Gotham
    cb.TextSize = 14

    cb.MouseButton1Click:Connect(function()
        if selectedFruits[fruit] then
            selectedFruits[fruit] = nil
            cb.Text = "[ ] " .. fruit
        else
            selectedFruits[fruit] = true
            cb.Text = "[X] " .. fruit
        end
    end)

    checkboxes[fruit] = cb
end

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 1, -50)
status.BackgroundTransparency = 1
status.Text = "Status: Idle"
status.TextColor3 = Color3.new(1, 1, 1)
status.Font = Enum.Font.Gotham
status.TextSize = 13

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 0, 30)
toggle.Position = UDim2.new(0, 10, 1, -25)
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Text = "Start Auto Collect"

local running = false
toggle.MouseButton1Click:Connect(function()
    running = not running
    toggle.Text = running and "Stop Auto Collect" or "Start Auto Collect"
end)

task.spawn(function()
    while true do
        if running then
            local selectedValueObj = fruitChooser:FindFirstChild("SelectedFruit")
            local selectedFruit = selectedValueObj and selectedValueObj:IsA("StringValue") and selectedValueObj.Value or nil

            if selectedFruit and selectedFruits[selectedFruit] and collectEvent then
                collectEvent:FireServer(selectedFruit)
                status.Text = "Collected: " .. selectedFruit
            end
        end
        task.wait(1)
    end
end)
