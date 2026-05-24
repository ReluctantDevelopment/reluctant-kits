# reluctant-kits

A simple kit claimer resource for FiveM. Lets players open a menu, browse kit categories, and claim loadouts with weapons and items — with a configurable cooldown per kit or globally.

---

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)

---

## Installation

1. Drop the resource folder into your `resources` directory
2. Add `ensure reluctant-kits` to your `server.cfg`
3. Configure your kits in `config.lua`

---

## Configuration

```lua
Config.Command = 'kit'          -- command to open the menu
Config.MenuTitle = 'Kit Menu'   -- title shown at the top of the menu
Config.Cooldown = 300000        -- global cooldown in ms (5 mins), can be overridden per kit
```

### Adding Categories & Kits

```lua
Config.Categories = {
    {
        id = 'rifle',
        label = 'Rifle',
        description = 'Primary rifle loadouts.',
        icon = 'gun',           -- font awesome icon name
        kits = {
            {
                id = 'assault_rifle',
                label = 'Assault Rifle Kit',
                description = 'Assault rifle, ammo, and armor.',
                cooldown = 600000,  -- optional, overrides global cooldown for this kit
                weapons = {
                    { name = 'WEAPON_ASSAULTRIFLE', ammo = 180 },
                },
                items = {
                    { name = 'ammo-rifle', count = 120 },
                    { name = 'armour', count = 1 },
                },
            },
        },
    },
}
```

---

## Usage

Players run `/kit` (or whatever you set `Config.Command` to) and a context menu opens. They pick a category, then a kit, confirm the dialog, and it gets handed to them — assuming they have inventory space and aren't on cooldown.

Cooldowns are stored in memory, so they reset on server restart.

---

