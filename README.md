# UI Library

![version](https://img.shields.io/badge/version-1.1.0-7f7fff) ![platform](https://img.shields.io/badge/platform-Roblox-black) ![language](https://img.shields.io/badge/language-Luau-blue)

A single-file Roblox GUI component library: a floating, draggable window with tabs, sections, and a full set of ready-made controls — toggle, slider, dropdown, textbox, keybind, button, title, color picker, paragraph and divider. It also ships a key-system screen, a toast notification queue, a theme system, a save/load config system, and a small terminal easter egg.

No dependencies. Drop in one file and go.

---

## Preview

![preview](https://files.catbox.moe/j0iqpd.jpg)
![Preview](https://files.catbox.moe/qm4jf2.jpg)

---

## Table of Contents

- [Preview](#preview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
  - [Library.new — the window](#librarynewconfig)
  - [Window:NewTab](#windownewtabconfig)
  - [Tab:NewSection](#tabnewsectionconfig)
  - [Section elements](#section-elements)
    - [NewToggle](#sectionnewtoggleconfig)
    - [NewSlider](#sectionnewsliderconfig)
    - [NewDropdown](#sectionnewdropdownconfig)
    - [NewTextbox](#sectionnewtextboxconfig)
    - [NewKeybind](#sectionnewkeybindconfig)
    - [NewButton](#sectionnewbuttonconfig)
    - [NewTitle](#sectionnewtitletext)
    - [NewColorPicker](#sectionnewcolorpickerconfig)
    - [NewParagraph](#sectionnewparagraphconfig)
    - [NewDivider](#sectionnewdividerconfig)
  - [Window-level methods](#window-level-methods)
  - [Flags & config persistence](#flags--config-persistence)
  - [Themes](#themes)
  - [Library.NewAuth — key system](#librarynewauthconfig)
  - [Library.Notification — toasts](#librarynotification)
  - [Library:Console — terminal easter egg](#libraryconsole)
- [Tips & Best Practices](#tips--best-practices)
- [FAQ](#faq)
- [Compatibility](#compatibility)
- [Changelog](#changelog)
- [Contributing](#contributing)
- [Credits](#credits)
- [License](#license)

---

## Features

- Floating, draggable, blurred-backdrop window with open/close animation and a keybind toggle
- Tabs → Sections (two columns, Left/Right) → Elements
- 10 element types: Toggle, Slider, Dropdown, Textbox, Keybind, Button, Title, **Color Picker**, **Paragraph**, **Divider**
- Live accent-color recoloring across the whole UI, including an animated **Rainbow Mode**
- Built-in **theme presets** (`Violet`, `Ocean`, `Emerald`, `Rose`, `Amber`, `Mono`) or any custom `Color3`
- **Flag system** — tag any input with `Flag = "name"` and it's automatically tracked in `Window.Flags`
- **SaveConfig / LoadConfig** — persist every flagged input to a local JSON file, no setup required
- A key-system screen (`Library.NewAuth`) for gating access behind a license key
- A toast notification queue (`Library.Notification`)
- A small Linux-terminal-style easter egg (`Library:Console`)

---

## Project Structure

| File | Purpose |
|---|---|
| [`UILibrary.lua`](./UILibrary.lua) | The library itself — the only file you need to load with `loadstring` |
| [`UILibrary_Demo.lua`](./UILibrary_Demo.lua) | A full demo that exercises every function below — use it as a working reference |
| `README.md` | This file |

---

## Installation

`UILibrary.lua` ends with `return table.freeze(Library)`, so it **must** be loaded through `loadstring` as its own chunk — don't paste its contents directly above your own script in the same file, or that top-level `return` will stop your script right there.

### Option A — load straight from GitHub (recommended)

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Akiraaiko0/Library/main/UILibrary.lua"))()
```

This always pulls the latest version from this repo's `main` branch. It needs the game (or your executor) to allow HTTP requests.

### Option B — load from a local file

Useful offline, or if HTTP requests are blocked where you're running it. Save `UILibrary.lua` to your executor's workspace folder, then:

```lua
local Library = loadstring(readfile("UILibrary.lua"))()
```

---

## Quick Start

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Akiraaiko0/Library/main/UILibrary.lua"))()

local Window = Library.new({
    Title       = "My Menu",
    Description = "made with UI Library",
    AccentColor = Color3.fromRGB(133, 127, 255),
})

local Tab     = Window:NewTab({ Title = "Main" })
local Section = Tab:NewSection({ Title = "General", Position = "Left" })

Section:NewToggle({
    Title    = "Example Toggle",
    Default  = false,
    Flag     = "exampleToggle", -- optional, see Flags & config persistence
    Callback = function(value)
        print("Toggle is now", value)
    end,
})
```

A full working example that exercises every function below lives in [`UILibrary_Demo.lua`](./UILibrary_Demo.lua).

---

## API Reference

### `Library.new(config)`

Creates the window. Returns a **Window** object.

| Field | Type | Default | Description |
|---|---|---|---|
| `Title` | string | `"UI Library"` | Window title text |
| `Description` | string | — | Subtitle shown under the title |
| `Keybind` | `Enum.KeyCode` | `LeftControl` | Key that shows/hides the window |
| `Logo` | string (asset id) | — | Logo image shown next to the title |
| `Size` | `UDim2` | `UDim2.new(0.1, 445, 0.1, 315)` | Window size |
| `AccentColor` | `Color3` | `Color3.fromRGB(133, 127, 255)` | Starting accent color (fully overridable; see [Themes](#themes)) |

```lua
local Window = Library.new({
    Title       = "My Menu",
    Description = "v1.0",
    Keybind     = Enum.KeyCode.RightControl,
    AccentColor = Color3.fromRGB(64, 170, 255),
})
```

---

### `Window:NewTab(config)`

Adds a tab to the window's sidebar. Returns a **Tab** object.

| Field | Type | Default | Description |
|---|---|---|---|
| `Title` | string | `"Tab"` | Tab label |
| `Icon` | string | built-in icon | Either a short icon name from the library's icon set, or a full `rbxassetid://...` string. If omitted, the built-in default is used — safest choice if you're not sure a name exists in the icon set. |

```lua
local Tab = Window:NewTab({ Title = "Main" })
```

---

### `Tab:NewSection(config)`

Adds a section box to a tab. Returns a **Section** object, which is what every element below is created on.

| Field | Type | Default | Description |
|---|---|---|---|
| `Title` | string | `"Section"` | Section header text |
| `Icon` | string | built-in icon | Same icon rules as `NewTab` |
| `Position` | `"Left"` \| `"Right"` | `"Left"` | Which of the tab's two columns to place the section in |

```lua
local Left  = Tab:NewSection({ Title = "Player",  Position = "Left"  })
local Right = Tab:NewSection({ Title = "Visuals", Position = "Right" })
```

---

## Section elements

Every element below is called as `Section:NewX({ ...config... })` and returns a small API table you can use to control it afterward. Any element that takes a `Flag` registers itself automatically — see [Flags & config persistence](#flags--config-persistence).

**Simple form.** Toggle, Slider, Dropdown, Textbox, Keybind and Button also accept plain positional arguments instead of a config table, Kavo-style, if you just want the quickest possible call:

```lua
Section:NewToggle("Example", false, function(value) end)
Section:NewSlider("Speed", 16, 100, 16, function(value) end)
Section:NewButton("Click me", function() end)
```

This is just a shorthand for the config-table form — pass a table as the first argument (as in every example below) any time you also want `Flag` or the other optional fields; pass a plain value and the library builds the table for you.

### `Section:NewToggle(config)`

| Field | Type | Default |
|---|---|---|
| `Title` | string | `"Toggle"` |
| `Default` | boolean | `false` |
| `Flag` | string, optional | `nil` |
| `Callback` | `function(value: boolean)` | no-op |

**Returns:** `{ Value(bool), Visible(bool) }`
**Simple form:** `Section:NewToggle(title, default, callback)`

```lua
local MyToggle = Section:NewToggle({
    Title = "Example", Default = false, Flag = "example",
    Callback = function(value) end,
})
MyToggle.Value(true)   -- set programmatically
MyToggle.Visible(false) -- hide the row
```

### `Section:NewSlider(config)`

| Field | Type | Default |
|---|---|---|
| `Title` | string | `"Slider"` |
| `Min` | number | `0` |
| `Max` | number | `100` |
| `Default` | number | `50` |
| `Flag` | string, optional | `nil` |
| `Callback` | `function(value: number)` | no-op |

**Returns:** `{ Visible(bool), Value(number) }`
**Simple form:** `Section:NewSlider(title, min, max, default, callback)`

### `Section:NewDropdown(config)`

| Field | Type | Default |
|---|---|---|
| `Title` | string | `"Dropdown"` |
| `Data` | `{string}` | `{'One','Two','Three','Four'}` |
| `Default` | string | `"Two"` |
| `Flag` | string, optional | `nil` |
| `Callback` | `function(value: string)` | no-op |

**Returns:** `{ Visible(bool), Value(string), Open(), Close(), Clear(), Set(newData: {string}) }`
**Simple form:** `Section:NewDropdown(title, data, default, callback)`

```lua
Section:NewDropdown({
    Title = "Theme",
    Data = Window:GetThemes(),
    Default = "Violet",
    Callback = function(theme) Window:SetTheme(theme) end,
})
```

### `Section:NewTextbox(config)`

| Field | Type | Default |
|---|---|---|
| `Title` | string | `"Textbox"` |
| `Default` | string | `""` |
| `FileType` | string, optional | `""` — short label shown to the right of the input (e.g. a suffix/unit hint) |
| `Flag` | string, optional | `nil` |
| `Callback` | `function(text: string)` | no-op, fires on focus lost |

**Returns:** `{ Visible(bool), Value(newText: string) }`
**Simple form:** `Section:NewTextbox(title, default, callback)`

### `Section:NewKeybind(config)`

| Field | Type | Default |
|---|---|---|
| `Title` | string | `"Keybind"` |
| `Default` | `Enum.KeyCode` | `E` |
| `Flag` | string, optional | `nil` |
| `Callback` | `function(key: Enum.KeyCode)` | no-op |

**Returns:** `{ Visible(bool), Value(newKey: Enum.KeyCode) }`
**Simple form:** `Section:NewKeybind(title, default, callback)`

Click the keybind box, then press any key to rebind it.

### `Section:NewButton(config)`

| Field | Type | Default |
|---|---|---|
| `Title` | string | `"Button"` |
| `Callback` | `function()` | no-op |

**Returns:** `{ Visible(bool), Fire }` — `Fire` is the callback itself, so `MyButton.Fire()` triggers it programmatically.
**Simple form:** `Section:NewButton(title, callback)`

### `Section:NewTitle(text)`

Takes a plain **string**, not a config table.

```lua
Section:NewTitle("Section Heading")
```

**Returns:** `{ Visible(bool), Set(newText: string) }`

### `Section:NewColorPicker(config)`

*New in 1.0.* A hue + saturation/value color picker. Click the swatch to expand it.

| Field | Type | Default |
|---|---|---|
| `Title` | string | `"Color Picker"` |
| `Default` | `Color3` | `Color3.fromRGB(255, 255, 255)` |
| `Flag` | string, optional | `nil` |
| `Callback` | `function(color: Color3)` | no-op |

**Returns:** `{ Visible(bool), Value(newColor: Color3) }`

```lua
Section:NewColorPicker({
    Title = "Custom Accent",
    Default = Color3.fromRGB(133, 127, 255),
    Flag = "accentColor",
    Callback = function(color) Window:SetAccentColor(color) end,
})
```

### `Section:NewParagraph(config)`

*New in 1.0.* Wrapping, multi-line info text. Height grows automatically to fit the content.

| Field | Type | Default |
|---|---|---|
| `Title` | string | `"Paragraph"` |
| `Content` | string | example text |

**Returns:** `{ Visible(bool), Set(newTitle, newContent) }` — pass `nil` for either argument to leave it unchanged.

### `Section:NewDivider(config)`

*New in 1.0.* A thin separator line, with an optional label.

| Field | Type | Default |
|---|---|---|
| `Title` | string, optional | `nil` — unlabeled line if omitted |

**Returns:** `{ Visible(bool) }`

---

## Window-level methods

| Method | Description |
|---|---|
| `Window:SetAccentColor(color: Color3)` | Live-recolors the whole UI to the given color |
| `Window:SetRainbow(enabled: boolean)` | Cycles the accent color through the rainbow while enabled |
| `Window:SetTheme(nameOrColor)` | Pass a preset name (string) or a `Color3` directly — see [Themes](#themes) |
| `Window:GetThemes()` | Returns `{string}` — the names of all built-in presets |
| `Window:SaveConfig(name: string)` | Writes every flagged input's value to disk as JSON. Returns `true`/`false` |
| `Window:LoadConfig(name: string)` | Reads a previously saved config and applies it. Returns `true`/`false` |
| `Window:SetTitle(newTitle: string)` | *New in 1.1.* Changes the window's title text live |
| `Window:SetKeybind(newKey: Enum.KeyCode)` | *New in 1.1.* Changes the show/hide keybind live |
| `Window.Flags` | Table of `{ [flagName] = { Get, Set, Type } }` — see below |

```lua
Window:SetAccentColor(Color3.fromRGB(255, 80, 80))
Window:SetRainbow(true)  -- cycles the accent color continuously
Window:SetRainbow(false) -- stop and keep whatever color it last landed on
Window:SetTitle("New Title")
Window:SetKeybind(Enum.KeyCode.RightShift)
```

---

## Flags & config persistence

Give **any** of Toggle, Slider, Dropdown, Textbox, Keybind or Color Picker a unique `Flag = "name"` and it registers itself in `Window.Flags`:

```lua
Window.Flags["exampleToggle"] = {
    Type = "Toggle",       -- "Toggle" | "Slider" | "Dropdown" | "Textbox" | "Keybind" | "ColorPicker"
    Get  = function() ... end,  -- returns the current value
    Set  = function(value) ... end, -- sets it programmatically, same as the element's own Value()
}
```

`Window:SaveConfig(name)` loops over every entry in `Window.Flags`, calls `Get()`, and writes the result to `<name>.json` under a `UILibrary/Configs` folder via `writefile`. `Window:LoadConfig(name)` reads that file back and calls each entry's `Set()`. Both are wrapped in `pcall` and check that `writefile` / `readfile` / `isfile` / `makefolder` / `isfolder` exist first, so they simply return `false` on executors that don't support file I/O — nothing errors, and nothing is ever sent over the network. The file only ever lives in that one local, sandboxed folder.

```lua
local ok = Window:SaveConfig("default")
local ok = Window:LoadConfig("default")
```

---

## Themes

Six presets ship built in:

| Name | Color |
|---|---|
| `Violet` | `133, 127, 255` |
| `Ocean` | `64, 170, 255` |
| `Emerald` | `70, 220, 155` |
| `Rose` | `255, 105, 145` |
| `Amber` | `255, 175, 70` |
| `Mono` | `235, 235, 235` |

```lua
Window:SetTheme("Ocean")
-- or any custom color:
Window:SetTheme(Color3.fromRGB(10, 200, 120))
```

---

### `Library.NewAuth(config)`

A standalone key-system / license screen. Call it **before** building your main window if you want to gate access behind it.

| Field | Type | Default |
|---|---|---|
| `Title` | string | `"Nothing $ KEY SYSTEM"` |
| `GetKey` | `function(): string` | returns an example URL, copied to the clipboard when the user clicks "Get Key" |
| `Auth` | `function(key: string): any` | return a truthy value to accept the key |
| `Freeze` | boolean | `false` — if `true`, **yields the script** until a correct key (or a gamepass purchase) is accepted |
| `GamePassId` | number, optional | *New in 1.1.* Set this to show a "BUY WITH ROBUX" button as an alternative to typing a key — ownership is checked automatically on load, and again right after a purchase |
| `MaxAttempts` | number, optional | *New in 1.1.* Kicks the player after this many wrong keys in a row. `nil` (default) = no limit |
| `KickMessage` | string | *New in 1.1.* `"Too many incorrect key attempts."` — shown on the kick screen when `MaxAttempts` is hit |
| `AntiHook` | boolean | *New in 1.1.* `false` — best-effort: periodically re-checks that `Auth`/`GetKey` haven't been hooked out from under the script, and kicks if they have. See the caveat below. |

**Returns:** `{ Close() }` — dismisses the screen with its closing animation. Also wired to a small **✕** button in the corner of the screen itself.

As of 1.1, entering a key now shows a green "Correct" / red "Incorrect" message right on the screen, and on success the Auth window **closes itself automatically** before your script continues — you don't need to call `Close()` yourself in that case.

```lua
local Auth = Library.NewAuth({
    Title = "My Script $ KEY SYSTEM",
    GetKey = function() return "https://example.com/get-key" end,
    Auth = function(key) return key == "my-secret-key" end,
    Freeze = true,

    GamePassId = 123456789,   -- optional: "BUY WITH ROBUX" skips the key entirely
    MaxAttempts = 3,
    KickMessage = "Too many incorrect key attempts.",
    AntiHook = true,
})
-- execution only reaches here once Auth succeeds (by key or by owning the gamepass)
```

> `GetKey` and `Auth` must be real Lua functions you define — the library explicitly rejects native/C functions here so the default placeholders can't accidentally ship as-is.

> **On `AntiHook`:** this is a best-effort check, not a guarantee — like any client-side anti-tamper, a determined attacker can usually still find a way around it. It only re-verifies that `conf.Auth` and `conf.GetKey` specifically haven't been swapped for a hooked C closure; it does not monitor anything else in your script.

---

### `Library.Notification()`

Returns a **notification system** — call it **once**, then use `.new(...)` for every toast:

| Field | Type | Default |
|---|---|---|
| `Title` | string | `"Notification"` |
| `Description` | string | `"Description"` |
| `Duration` | number (seconds) | `5` |
| `Icon` | string (asset id) | built-in icon |

```lua
local Notify = Library.Notification()

Notify.new({
    Title = "Saved",
    Description = "Your config was saved.",
    Duration = 3,
})
```

Toasts stack from the bottom-right corner of the screen. Click one to dismiss it early (a quick white flash, then it's gone) instead of waiting out its `Duration`.

---

### `Library:Console()`

Opens a small draggable, Linux-terminal-styled window with a handful of joke commands (`neofetch`, `clear`, `python`, `sudo rm -rf ...`) plus a real Lua REPL for whatever you type. Called with a colon, no arguments:

```lua
Library:Console()
```

---

## Tips & Best Practices

- **Flag everything you want to persist.** If a setting should survive a rejoin, give it a `Flag` and call `SaveConfig`/`LoadConfig` from a couple of buttons — see the demo script for a working example.
- **ColorPicker + SetAccentColor is a nice combo.** Let players pick a theme from a dropdown first, then fine-tune it live with a color picker, exactly like the demo does.
- **Icons are fetched live** from a hosted icon-name → asset-id JSON. If you're not sure a short name (e.g. `"home"`) exists in that set, just omit `Icon` and let the built-in default apply — don't guess, since an unmatched name silently fails to render.
- **`Freeze = true` on `Library.NewAuth` blocks the thread it's called on.** Call it from its own `task.spawn`, or simply accept that the rest of your script won't run until the key is entered.
- **`SaveConfig`/`LoadConfig` quietly no-op** (return `false`) on executors without file-system support — always check the return value before assuming a save actually happened.
- **Dragging** works from the header area of the main window; the Console window is independently draggable too.
- Keep `Window.Flags` names unique across your whole menu. Reusing a flag name still means the second element overwrites the first in `Window.Flags` — as of 1.1 you'll at least get a `warn()` in the console when it happens, instead of it happening silently.

---

## FAQ

**`game:HttpGet(...)` is erroring, something like "HTTP requests are not enabled".**
The game or your executor has HTTP requests turned off. Download `UILibrary.lua` and load it locally with `readfile` instead — see [Option B](#installation) under Installation.

**My tab/section icons aren't showing up.**
Icon names are resolved against a list fetched live over HTTP when the library first loads. If that request fails (no internet, HTTP disabled, the host going down) short names won't resolve. Either pass a full `rbxassetid://...` string as `Icon`, or omit it entirely to use the built-in default.

**`SaveConfig`/`LoadConfig` always return `false`.**
Your executor doesn't expose `writefile` / `readfile` / `isfile` / `makefolder` / `isfolder`. Check your executor's own documentation for which file-system functions it supports, if any.

**Can I use this in Roblox Studio?**
No. It's built for script executors — it relies on executor-only globals like `gethui` (with safe fallbacks to `CoreGui`) and expects to be loaded with `loadstring`, which Studio's normal script contexts don't allow.

**Can I change the window title, keybind, etc. after creating it?**
Yes — `Window:SetTitle(newTitle)` and `Window:SetKeybind(newKey)` (new in 1.1) cover those live. Style things (accent color, theme, rainbow) can also be changed anytime through the `Window:Set...` methods above.

**I used the same `Flag` on two elements by accident — how do I know?**
The console will print a `warn()` the moment the second one registers, naming the flag. The second element still wins (it overwrites the first in `Window.Flags`) — the warning is just so you notice, not a hard error.

---

## Compatibility

- Written in **Luau** (Roblox's Lua dialect) — not vanilla Lua. Function parameter type annotations and other Luau-only syntax are used throughout.
- Intended to run inside a Roblox script executor (not Roblox Studio) — it relies on `gethui()`/`CoreGui` parenting to render above the game UI.
- `SaveConfig`/`LoadConfig` need `writefile`, `readfile`, `isfile`, `makefolder` and `isfolder`. Everything else works without any special executor APIs.

---

## Changelog

### 1.1.0

- **Added:** `Window:SetTitle` / `Window:SetKeybind` — change the title and show/hide keybind after the window is already built.
- **Added:** plain positional-argument calls for Toggle, Slider, Dropdown, Textbox, Keybind and Button (Kavo-style), alongside the existing config-table form — see [Section elements](#section-elements).
- **Added (Key System):** on-screen correct/incorrect feedback, automatic close-on-success, a **✕** close button, `GamePassId` (buy-with-Robux bypass), `MaxAttempts`/`KickMessage` (kick after too many wrong keys), and `AntiHook` (best-effort hook detection).
- **Added:** `warn()` when a `Flag` name is reused, instead of silently overwriting the earlier entry in `Window.Flags`.
- **Changed (Notifications):** toasts now anchor to the bottom-right corner instead of a fixed on-screen position, click to dismiss early, and their shadow now matches the card's actual rounded shape (circular when collapsed, rounded-rectangle when expanded) instead of a static image.
- **Changed:** rounded several corners that were still sharp (2–3px) left over from the original theme, so they're consistent with the softer look introduced in 1.0 (Tab/Section icons, Title underline, Dropdown/Textbox inner boxes, Key System's buttons and window, Console).

### 1.0.0

- Initial public release.
- **Added:** `Section:NewColorPicker`, `Section:NewParagraph`, `Section:NewDivider`.
- **Added:** Flag system (`Window.Flags`) across Toggle, Slider, Dropdown, Textbox, Keybind and Color Picker.
- **Added:** `Window:SaveConfig` / `Window:LoadConfig`.
- **Added:** `Window:SetTheme` / `Window:GetThemes` with six built-in presets.
- **Fixed:** `Section:NewTextbox` now returns a proper `{ Visible, Value }` API, like every other element.
- **Fixed:** Slider, Dropdown and Keybind now track their own current value correctly instead of only ever firing a callback.
- Refreshed the default accent color.

---

## Contributing

Issues and pull requests are welcome.

- Found a bug? Open an issue with a short repro (what you called, what you expected, what happened).
- Proposing a new element or API change? Include a usage example in the description, in the same style as the ones in [API Reference](#api-reference).
- Keep PRs focused — one feature or fix per PR is easier to review than several bundled together.

---

## Credits

- Icons loaded from the [lucideblox](https://github.com/evoincorp/lucideblox) icon set.
- Create a library by [mm55061](https://www.roblox.com/users/4737901580/profile)
- 
---

## License

Pick a license for your repository — [MIT](https://choosealicense.com/licenses/mit/) is a common, permissive choice for libraries like this — and add a `LICENSE` file alongside this README. Replace this section with your actual license once decided.
