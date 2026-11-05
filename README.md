# C00LGUI - K00pkid Decal Script

A C00LGUI-style utility GUI for Roblox Studio, featuring a K00pkid decal applicator, fly toggle, speed control, and more. This Roblox script pack includes a client-side LocalScript and a server-side Script that work together to provide a complete admin-style interface with smooth animations and real-time notifications.

## Install

1. Download the script files from the repository.
2. Open your Roblox Studio project.
3. Navigate to `StarterPlayer > StarterPlayerScripts` in the Explorer.
4. Insert the `C00LGUI.lua` LocalScript into `StarterPlayerScripts`.
5. Navigate to `ServerScriptService`.
6. Insert the `K00kAdminServer.lua` Script into `ServerScriptService`.

The server script automatically creates the required `K00kAdminEvent` RemoteEvent inside `ReplicatedStorage` - you don't need to create it manually.

## Use

1. Open both scripts and configure the `CONFIG` table at the top of `C00LGUI.lua`:
   - Replace the `K00pkidDecal` asset ID with your actual K00pkid decal.
   - Adjust keybind, colors, and text color to your preference.
2. Test the game. Press **Right Shift** to toggle the C00LGUI interface.
3. Use the following buttons:
   - **K00pkid Decal** - Applies the K00pkid decal texture to every part of your character.
   - **Remove K00pkid Decal** - Removes all applied K00pkid decals from your character.
   - **Fly (Toggle)** - Toggles flying with WASD/Space controls.
   - **Speed ᴏɴ** - Toggles between normal (16) and fast (100) walk speed.
   - **Close** - Closes the GUI.

The GUI includes smooth tween animations, notification pop-ups, and a clean dark theme with red accents for the authentic C00LGUI style.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/25868fb7-d008-403c-8703-198cc162795d?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=25868fb7-d008-403c-8703-198cc162795d
