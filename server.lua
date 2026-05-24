local cooldowns = {}

local function getIdent(src)
    local license = GetPlayerIdentifierByType(src, 'license')
    if license then return license end

    local ids = GetPlayerIdentifiers(src)
    return ids and ids[1]
end

local function findCategory(id)
    for _, cat in ipairs(Config.Categories or {}) do
        if cat.id == id then return cat end
    end
end

local function findKit(catId, kitId)
    local cat = findCategory(catId)
    if not cat then return nil, nil end

    for _, kit in ipairs(cat.kits or {}) do
        if kit.id == kitId then return cat, kit end
    end

    return cat, nil
end

local function checkCooldown(src, kit)
    local ident = getIdent(src)
    if not ident then return false, 'Couldn\'t get your player identifier.' end

    local cd = kit.cooldown or Config.Cooldown or 0
    if cd <= 0 then return true, ident end

    cooldowns[ident] = cooldowns[ident] or {}

    local last = cooldowns[ident][kit.id]
    if not last then return true, ident end

    local left = cd - (GetGameTimer() - last)
    if left > 0 then
        return false, ('Wait %ss before claiming this again.'):format(math.ceil(left / 1000))
    end

    return true, ident
end

local function giveItems(src, items)
    for _, item in ipairs(items or {}) do
        local amt = tonumber(item.count) or 1
        if item.name and amt > 0 then
            if not exports.ox_inventory:CanCarryItem(src, item.name, amt) then
                return false, ('No inventory space for %s x%s.'):format(item.name, amt)
            end
        end
    end

    for _, item in ipairs(items or {}) do
        local amt = tonumber(item.count) or 1
        if item.name and amt > 0 then
            exports.ox_inventory:AddItem(src, item.name, amt, item.metadata)
        end
    end

    return true
end

local function giveWeapons(src, weapons)
    for _, w in ipairs(weapons or {}) do
        if w.name and w.name ~= '' then
            if not exports.ox_inventory:CanCarryItem(src, w.name, 1) then
                return false, ('No space for %s.'):format(w.name)
            end
        end
    end

    for _, w in ipairs(weapons or {}) do
        if w.name and w.name ~= '' then
            exports.ox_inventory:AddItem(src, w.name, 1)
        end
    end

    return true
end

RegisterNetEvent('reluctant-kits:server:claimKit', function(catId, kitId)
    local src = source
    local cat, kit = findKit(catId, kitId)

    if not cat or not kit then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Kits', description = 'That kit doesn\'t exist.', type = 'error' })
        return
    end

    local ok, res = checkCooldown(src, kit)
    if not ok then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Kits', description = res, type = 'error' })
        return
    end

    local ident = res

    local wOk, wMsg = giveWeapons(src, kit.weapons)
    if not wOk then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Kits', description = wMsg, type = 'error' })
        return
    end

    local iOk, iMsg = giveItems(src, kit.items)
    if not iOk then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Kits', description = iMsg, type = 'error' })
        return
    end

    cooldowns[ident] = cooldowns[ident] or {}
    cooldowns[ident][kit.id] = GetGameTimer()

    TriggerClientEvent('ox_lib:notify', src, { title = 'Kits', description = ('Claimed %s from %s.'):format(kit.label, cat.label), type = 'success' })
end)