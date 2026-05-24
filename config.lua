Config = {}

Config.Command = 'kit'
Config.MenuTitle = 'Kit Menu'
Config.MenuDescription = 'Choose a category and claim a loadout.'
Config.Cooldown = 300000

Config.Categories = {
    {
        id = 'rifle',
        label = 'Rifle',
        description = 'Primary rifle loadouts.',
        icon = 'gun',
        kits = {
            {
                id = 'assault_rifle',
                label = 'Assault Rifle Kit',
                description = 'Assault rifle, ammo, and armor item.',
                weapons = {
                    {
                        name = 'WEAPON_ASSAULTRIFLE',
                        ammo = 180,
                    },
                },
                items = {
                    { name = 'ammo-rifle', count = 120 },
                    { name = 'armour', count = 1 },
                },
            },
        },
    },
    {
        id = 'pistol',
        label = 'Pistol',
        description = 'Sidearm loadouts.',
        icon = 'gun',
        kits = {
            {
                id = 'heavy_pistol',
                label = 'Heavy Pistol Kit',
                description = 'Heavy pistol, ammo, and armor item.',
                weapons = {
                    {
                        name = 'WEAPON_HEAVYPISTOL',
                        ammo = 120,
                    },
                },
                items = {
                    { name = 'ammo-9', count = 120 },
                    { name = 'armour', count = 1 },
                },
            },
        },
    },
}