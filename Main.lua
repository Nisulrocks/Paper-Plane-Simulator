-- boot da libary 
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Main 

local Window = Rayfield:CreateWindow({
   Name = "Plane Simulator",
   Icon = 0, 
   LoadingTitle = "Plane Simulator",
   LoadingSubtitle = "by NisulRocks",
   Theme = "Default", 

   ToggleUIKeybind = "K" 

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

-- Farm Tab 

local Tab = Window:CreateTab("Farm")

-- Training farm section 

local Section = Tab:CreateSection("Training Farm")

-- Wins Farm section 

local Section = Tab:CreateSection("Wins Farm")

-- Eggs Farm section 

local Section = Tab:CreateSection("Eggs Farm")