--[[
	UI Library — feature demo / test script
	----------------------------------------
	Exercises every public function of UILibrary.lua so you can see the
	whole thing working end to end: every element type (both the config-
	table form and the 1.1 Kavo-style simple-call form), the Flag system,
	SaveConfig/LoadConfig, SetTheme, SetRainbow, SetTitle/SetKeybind,
	Notification and the Console.

	UILibrary.lua ends with `return table.freeze(Library)`, so it has
	to be loaded through loadstring (NOT just pasted above this file
	in the same script — that top-level `return` would stop the whole
	script right there and this demo would never run).

	Below loads straight from this repo's GitHub raw URL (needs HTTP
	requests enabled). Prefer a local copy instead — offline, or if
	HTTP requests are blocked where you're running this — save the
	library as "UILibrary.lua" in your executor's workspace folder
	and swap the line for:
		local Library = loadstring(readfile("UILibrary.lua"))();
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Akiraaiko0/Library/main/UILibrary.lua"))();

local Notify = Library.Notification(); -- call once; .new(...) spawns each toast

----------------------------------------------------------------
-- 1. Window
----------------------------------------------------------------
local Window = Library.new({
	Title = "UI Library — Demo",
	Description = "testing every feature",
	Keybind = Enum.KeyCode.RightControl,
	AccentColor = Color3.fromRGB(133, 127, 255),
});

----------------------------------------------------------------
-- 2. Tabs + Sections (Left/Right columns, two tabs)
----------------------------------------------------------------
local MainTab = Window:NewTab({ Title = "Main" });
local PlayerSection = MainTab:NewSection({ Title = "Player",  Position = "Left"  });
local VisualSection = MainTab:NewSection({ Title = "Visuals", Position = "Right" });

local ExtrasTab = Window:NewTab({ Title = "Extras" });
local ConfigSection = ExtrasTab:NewSection({ Title = "Config", Position = "Left"  });
local AboutSection  = ExtrasTab:NewSection({ Title = "About",  Position = "Right" });

----------------------------------------------------------------
-- 3. Player section — Toggle, Slider, Keybind, Button
----------------------------------------------------------------
PlayerSection:NewToggle({
	Title = "Example Toggle",
	Default = false,
	Flag = "exampleToggle", -- try Window.Flags.exampleToggle.Get() in the console
	Callback = function(state)
		Notify.new({
			Title = "Example Toggle",
			Description = state and "Turned ON" or "Turned OFF",
			Duration = 2,
		});
	end,
});

PlayerSection:NewSlider({
	Title = "Walk Speed",
	Min = 16,
	Max = 100,
	Default = 16,
	Flag = "walkSpeed",
	Callback = function(value)
		local char = game:GetService("Players").LocalPlayer.Character;
		local hum = char and char:FindFirstChildOfClass("Humanoid");
		if hum then hum.WalkSpeed = value end;
	end,
});

PlayerSection:NewKeybind({
	Title = "Toggle Console",
	Default = Enum.KeyCode.F2,
	Flag = "consoleKey",
	Callback = function()
		Library:Console();
	end,
});

PlayerSection:NewButton({
	Title = "Say Hi",
	Callback = function()
		Notify.new({
			Title = "Hello!",
			Description = "Buttons fire this callback on click.",
			Duration = 3,
		});
	end,
});

----------------------------------------------------------------
-- 3b. Same section, but calling things the "simple" (Kavo-style)
--     way: plain arguments instead of a config table. Both styles
--     work on the same element types — use whichever reads better.
----------------------------------------------------------------
PlayerSection:NewDivider({ Title = "Simple calls" });

PlayerSection:NewToggle("Simple Toggle", false, function(value) end);
PlayerSection:NewSlider("Jump Power", 50, 200, 50, function(value)
	local char = game:GetService("Players").LocalPlayer.Character;
	local hum = char and char:FindFirstChildOfClass("Humanoid");
	if hum then hum.JumpPower = value end;
end);
PlayerSection:NewButton("Simple Button", function()
	Notify.new({ Title = "Simple Button", Description = "Called with 2 plain arguments, no table.", Duration = 3 });
end);

----------------------------------------------------------------
-- 4. Visuals section — Divider, Dropdown (theme), ColorPicker,
--    Toggle (rainbow), Paragraph
----------------------------------------------------------------
VisualSection:NewDivider({ Title = "Appearance" });

VisualSection:NewDropdown({
	Title = "Theme",
	Data = Window:GetThemes(), -- Violet / Ocean / Emerald / Rose / Amber / Mono
	Default = "Violet",
	Callback = function(theme)
		Window:SetTheme(theme);
	end,
});

VisualSection:NewColorPicker({
	Title = "Custom Accent",
	Default = Color3.fromRGB(133, 127, 255),
	Flag = "accentColor",
	Callback = function(color)
		Window:SetAccentColor(color); -- overrides whatever theme was picked above
	end,
});

VisualSection:NewToggle({
	Title = "Rainbow Mode",
	Default = false,
	Callback = function(state)
		Window:SetRainbow(state);
	end,
});

VisualSection:NewParagraph({
	Title = "Tip",
	Content = "The color picker overrides whatever theme you pick — choose a theme first, then fine-tune it with the picker.",
});

----------------------------------------------------------------
-- 5. Config section — Textbox + Save/Load, reading its Flag's Get()
----------------------------------------------------------------
ConfigSection:NewTextbox({
	Title = "Config Name",
	Default = "default",
	Flag = "configName",
	Callback = function() end,
});

ConfigSection:NewButton({
	Title = "Save Config",
	Callback = function()
		local name = Window.Flags.configName.Get();
		local ok = Window:SaveConfig(name);
		Notify.new({
			Title = "Save Config",
			Description = ok and ('Saved as "'..name..'".')
				or "writefile isn't available on this executor.",
			Duration = 3,
		});
	end,
});

ConfigSection:NewButton({
	Title = "Load Config",
	Callback = function()
		local name = Window.Flags.configName.Get();
		local ok = Window:LoadConfig(name);
		Notify.new({
			Title = "Load Config",
			Description = ok and ('Loaded "'..name..'".')
				or "No saved config found (or readfile unavailable).",
			Duration = 3,
		});
	end,
});

----------------------------------------------------------------
-- 6. About section — Title, Paragraph
----------------------------------------------------------------
AboutSection:NewTitle("UI Library Demo");
AboutSection:NewParagraph({
	Title = "What this covers",
	Content = "Every element type, the Flag system, SaveConfig/LoadConfig, SetTheme, SetRainbow, Notification and the Console. Check both tabs and both columns of each section.",
});

----------------------------------------------------------------
-- 7. Fire a notification once everything is loaded
----------------------------------------------------------------
Notify.new({
	Title = "UI Library",
	Description = "Demo loaded — every feature is wired up. Press Right Ctrl to hide/show, F2 for the console.",
	Duration = 5,
});

----------------------------------------------------------------
-- 8. Key System (Library.NewAuth) — optional, NOT called above.
--    Uncomment to see the auth screen. Move it above section 1 and
--    set Freeze = true if you want it to gate the rest of the script.
--    For a full walkthrough of every 1.1 Auth feature (feedback,
--    MaxAttempts, AntiHook, GamePassId), see KeySystem_Example.lua.
----------------------------------------------------------------
--[[
local Auth = Library.NewAuth({
	Title = "Demo $ KEY SYSTEM",
	GetKey = function()
		return "https://example.com/get-key" -- copied to clipboard on click
	end,
	Auth = function(key)
		return key == "letmein" -- replace with your own check
	end,
	Freeze = false,        -- true = blocks script execution until Auth succeeds
	MaxAttempts = 3,       -- optional: kick after this many wrong keys
	AntiHook = true,       -- optional: best-effort kick if Auth/GetKey get hooked
	-- GamePassId = 123456789, -- optional: adds a "BUY WITH ROBUX" button
});
]]
