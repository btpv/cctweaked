function find(type)
    output = {}
    leftover = {}
    for i, v in pairs(peripheral.getNames()) do
        if peripheral.getType(v) == type then
            table.insert(output, peripheral.wrap(v))
        else
            table.insert(leftover, peripheral.wrap(v))
        end
    end
    return output, leftover
end
function energyLevelFormat(energyLevel)
    local energyLevelLength = #tostring(energyLevel)
    local energyLevelFormated
    if energyLevelLength < 4 then
        energyLevelFormated = (energyLevel)
    elseif energyLevelLength < 7 then
        K_energyLevel = energyLevel / 1000
        energyLevelFormated = ((math.floor(K_energyLevel * 100) / 100) .. "K")
    elseif energyLevelLength < 10 then
        M_energyLevel = energyLevel / 1000000
        energyLevelFormated = ((math.floor(M_energyLevel * 100) / 100) .. "M")
    elseif energyLevelLength < 13 then
        B_energyLevel = energyLevel / 1000000000
        energyLevelFormated = ((math.floor(B_energyLevel * 100) / 100) .. "B")
    else
        T_energyLevel = energyLevel / 1000000000000
        energyLevelFormated = ((math.floor(T_energyLevel * 100) / 100) .. "T")
    end
    return energyLevelFormated
end

while true do
    controllers= find("arController")
    for i, v in pairs(controllers) do
        glasses = v
    end
    disks = find("drive")
    for i, v in pairs(disks) do
        if v.isDiskPresent() then
            label = v.getDiskLabel()
            if string.find(label, "limit: ") then
                limit = string.gsub(label, "limit: ", "")
            end
        end
    end
    energy = find("energyDetector")
    if limit == "-1" then
        perDetectorLimit = 64000
    else
        perDetectorLimit = tonumber(limit) / #energy
    end
    for i, v in pairs(energy) do
        v.setTransferRateLimit(perDetectorLimit)
    end
    transferrateall = 0
    transferrateLimitall = 0
    for i, v in pairs(energy) do
        getThisTransferRate = v.getTransferRate()
        getThisTransferRateLimit = v.getTransferRateLimit()
        print(i .. ":    " .. energyLevelFormat(getThisTransferRate) .. "/" ..
                  energyLevelFormat(getThisTransferRateLimit))
        transferrateall = transferrateall + getThisTransferRate
        transferrateLimitall = transferrateLimitall + getThisTransferRateLimit
    end
    transferrateallFormated = energyLevelFormat(transferrateall)
    transferrateLimitallFormated = energyLevelFormat(transferrateLimitall)
    print("all:  " .. transferrateallFormated .. "/" .. transferrateLimitallFormated)
    print()
    matrix = find("peripheralProxy:inductionMatrix")
    energyLevelall = 0
    energyMaxLevelall = 0
    for i, v in pairs(matrix) do
        energyLevel = v.getEnergy()
        energyLevelFormated = energyLevelFormat(energyLevel)
        energyMaxLevel = v.getMaxEnergy()
        energyMaxLevelFormated = energyLevelFormat(energyMaxLevel)
        print(i .. ":    " .. energyLevelFormated .. "/" .. energyMaxLevelFormated)
        energyLevelall = energyLevelall + energyLevel
        energyMaxLevelall = energyMaxLevelall + energyMaxLevel
    end
    energyLevelallFormated = energyLevelFormat(energyLevelall)
    energyMaxLevelallFormated = energyLevelFormat(energyMaxLevelall)
    print("all:  " .. energyLevelallFormated .. "/" .. energyMaxLevelallFormated)
    glasses.clear()
    glasses.drawString(transferrateallFormated .. "/" .. transferrateLimitallFormated, 10, 10, 0xffffff)
    glasses.drawString(energyLevelallFormated .. "/" .. energyMaxLevelallFormated, 10, 20, 0xffffff)
    i = 1111
    print()
    sleep(1)
    print()

end
