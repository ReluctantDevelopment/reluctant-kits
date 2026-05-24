local mainMenu = 'rkits:main'
local catMenu = 'rkits:cat:'

local function weaponText(w)
    if w.ammo then
        return w.name .. ' (' .. w.ammo .. ' ammo)'
    end
    return w.name or 'Weapon'
end

local function itemText(item)
    return 'x' .. (tonumber(item.count) or 1) .. ' ' .. (item.name or 'Unknown')
end

local function kitDesc(kit)
    local out = {}

    if kit.description and kit.description ~= '' then
        out[#out+1] = kit.description
    end

    if kit.weapons and #kit.weapons > 0 then
        local list = {}
        for _, w in ipairs(kit.weapons) do
            list[#list+1] = weaponText(w)
        end
        out[#out+1] = 'Weapons: ' .. table.concat(list, ', ')
    end

    if kit.items and #kit.items > 0 then
        local list = {}
        for _, item in ipairs(kit.items) do
            list[#list+1] = itemText(item)
        end
        out[#out+1] = 'Items: ' .. table.concat(list, ', ')
    end

    return table.concat(out, '\n')
end

local function openCat(cat)
    local opts = {
        {
            title = 'Go Back',
            icon = 'arrow-left',
            description = 'Return to main menu.',
            onSelect = function()
                lib.showContext(mainMenu)
            end
        }
    }

    for _, kit in ipairs(cat.kits or {}) do
        opts[#opts+1] = {
            title = kit.label or kit.id,
            description = kitDesc(kit),
            icon = kit.icon or 'box-open',
            onSelect = function()
                local res = lib.alertDialog({
                    header = kit.label or 'Kit',
                    content = kit.confirmText or ('Claim ' .. (kit.label or 'this kit') .. '?'),
                    centered = true,
                    cancel = true
                })

                if res == 'confirm' then
                    TriggerServerEvent('reluctant-kits:server:claimKit', cat.id, kit.id)
                end
            end
        }
    end

    lib.registerContext({
        id = catMenu .. cat.id,
        title = cat.label or 'Category',
        menu = mainMenu,
        options = opts
    })
end

local function setupMenus()
    local cats = {}

    for _, cat in ipairs(Config.Categories or {}) do
        openCat(cat)

        cats[#cats+1] = {
            title = cat.label or cat.id,
            description = cat.description or 'Browse kits.',
            icon = cat.icon or 'folder-open',
            onSelect = function()
                lib.showContext(catMenu .. cat.id)
            end
        }
    end

    lib.registerContext({
        id = mainMenu,
        title = Config.MenuTitle or 'Kits',
        options = cats
    })
end

CreateThread(function()
    setupMenus()
end)

RegisterCommand(Config.Command or 'kit', function()
    lib.showContext(mainMenu)
end, false)