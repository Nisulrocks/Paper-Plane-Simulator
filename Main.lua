-- boot da libary 
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Main 

local Window = Rayfield:CreateWindow({
   Name = "Plane Simulator",
   Icon = 0, 
   LoadingTitle = "Plane Simulator",
   LoadingSubtitle = "by NisulRocks",
   Theme = "Default", 

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Plane Simulator", 
      FileName = "Plane Simulator"
   },

   Discord = {
      Enabled = false, 
      Invite = "noinvitelink", 
      RememberJoins = true 
   },

   KeySystem = false, 
   KeySettings = {
      Title = "Plane Simulator",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", 
      FileName = "Key", 
      SaveKey = true, 
      GrabKeyFromSite = false, 
      Key = {"Hello"} 
   }
})

-- farm tab
local Tab = Window:CreateTab(" Auto Farm ")

-- Training farm section 

local Section = Tab:CreateSection("Training Farm")

-- create a variable to store the Zone
local Zone = "Zone1"
local Trainer = 1

local Dropdown = Tab:CreateDropdown({
    Name = "Select Zone",
    Options = {"Zone1","Zone2","Zone3"},
    CurrentOption = {"Zone1"},
    MultipleOptions = false,
    Flag = "Dropdown1", 
    Callback = function(Options)
    -- The function that takes place when the selected option is changed
    -- The variable (Options) is a table of strings for the current selected options
    Zone = Options[1]
    end,
 })

 local Dropdown = Tab:CreateDropdown({
    Name = "Select Trainer",
    Options = {"1","2","3","4"},
    CurrentOption = {"1"},
    MultipleOptions = false,
    Flag = "Dropdown2", 
    Callback = function(Options)
    -- The function that takes place when the selected option is changed
    -- The variable (Options) is a table of strings for the current selected options
    Trainer = tonumber(Options[1])
    end,
 })

local RunService = game:GetService("RunService")
local connection

local Toggle = Tab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        if Value then
            connection = RunService.Heartbeat:Connect(function()
                local args = {
                    "Train",
                    {
                        Trainer,
                        Zone
                    }
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RewardAction"):FireServer(unpack(args))
            end)
        else
            if connection then
                connection:Disconnect()
            end
        end
    end,
})

-- Wins Farm section 

local Section = Tab:CreateSection("Wins Farm")

-- Eggs Farm section 

local Section = Tab:CreateSection("Eggs Farm")