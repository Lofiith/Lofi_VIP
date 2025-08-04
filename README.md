# Advanced VIP System for FiveM

This is a lightweight, optimized script for FiveM that introduces a highly configurable VIP membership system. It allows server owners to provide exclusive features, items, and privileges to VIP members through Discord role integration. The script is designed to integrate seamlessly into ESX, QBCORE, and standalone servers with modern ox_lib optimization.

## Requirements!
- **ox_lib** (Required)
- **ESX**, **QBCORE**, or **Standalone** Framework
- **lofi_discord** (Optional - for Discord role verification)

## Features
- **Discord Integration**: Automatic VIP role verification with configurable role IDs
- **Exclusive VIP Features**: Health/armor restoration, vehicle repair/washing, god mode, invisibility
- **VIP Shop System**: Tiered item purchasing with VIP and VIP+ pricing
- **Quick Travel**: VIP+ exclusive teleportation to custom locations
- **Framework Agnostic**: Works with ESX, QBCore, or standalone setups
- **Security Focused**: Server-side validation, anti-exploit protection, proper money handling
- **Performance Optimized**: Uses ox_lib cache, modern FiveM APIs, and efficient cooldown systems
- **Fully Configurable**: Easy-to-customize config file for all features, prices, and permissions
- **Resource Name Protection**: Prevents unauthorized modifications and renaming

## Installation
1. Clone or download the repository
2. Copy the `Lofi_VIP` folder to your resources directory
3. Ensure you have `ox_lib` installed and running
4. Add `ensure Lofi_VIP` to your server.cfg **after** ox_lib
5. Optional: Install `lofi_discord` for Discord role verification

## Usage / Documentation

### Configuration
Customize the `shared/config.lua` file to your preferences:
- **VIP Features**: Enable/disable features, set prices and cooldowns
- **Discord Roles**: Configure your VIP role IDs
- **Shop Items**: Add custom items with VIP/VIP+ pricing
- **Teleport Locations**: Set quick travel destinations
- **Framework Settings**: Choose auto-detection or specific framework

### Commands
- `/vipmenu` - Opens the VIP menu interface
- `/vipstatus` - Check your current VIP status
- `/viprefresh` - Refresh Discord VIP cache

### Keybinds
- **F5** (configurable) - Opens VIP menu

### VIP Features Available
- **Health Restoration**: Instantly restore health to 100%
- **Armor Restoration**: Restore armor to maximum
- **Vehicle Repair**: Fully repair and restore current vehicle
- **Vehicle Wash**: Clean current vehicle
- **Clothing Menu**: Access skin/clothing customization
- **God Mode** (VIP+ Only): Temporary invincibility
- **Invisibility** (VIP+ Only): Become invisible to other players
- **Quick Travel** (VIP+ Only): Teleport to configured locations
- **Exclusive Shop**: Purchase items at discounted VIP prices

### Discord Integration
The script integrates with Discord through the `lofi_discord` resource:
1. Install and configure `lofi_discord`
2. Set your VIP role IDs in the config
3. Players with VIP roles automatically gain access
4. Without Discord integration, all players have access (useful for testing)

## Framework Compatibility
- **ESX Legacy**: Full support with automatic detection
- **QBCore/QBX**: Full support with automatic detection  
- **Standalone**: Basic functionality without framework dependency

## Exports
The script provides several exports for integration with other resources:

### `hasVipAccess(playerId, level)`
Check if a player has the required VIP access level
```lua
-- Check if player has VIP access
local hasVip = exports['lofi_vip']:hasVipAccess(playerId, 'vip')

-- Check if player has VIP+ access  
local hasVipPlus = exports['lofi_vip']:hasVipAccess(playerId, 'vip_plus')
```

### `updatePlayerVipState(playerId)`
Manually update a player's VIP state (useful after role changes)
```lua
-- Update player's VIP status
exports['lofi_vip']:updatePlayerVipState(playerId)
```

### `refreshPlayerCache(playerId)`
Refresh Discord cache for a specific player
```lua
-- Refresh player's Discord cache
local success = exports['lofi_vip']:refreshPlayerCache(playerId)
```

### `getDisplayName(playerId)`
Get player's Discord display name or fallback to FiveM name
```lua
-- Get player's display name
local displayName = exports['lofi_vip']:getDisplayName(playerId)
```

## Security Features
- Server-side validation for all actions
- Money is charged only after successful feature execution
- Cooldown system prevents spam and abuse
- Resource name protection prevents unauthorized modifications
- No client-side exploits possible

## Contributing
Contributions are welcome! Please submit pull requests or issues if you find bugs or have suggestions for improvement.

## Support
For support and updates, please check the repository or contact the development team.

---
**Note**: This resource must be named exactly `Lofi_VIP` to function properly. Renaming the resource will prevent it from working.
