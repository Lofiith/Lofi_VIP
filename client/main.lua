local EXPECTED_RESOURCE_NAME = 'Lofi_VIP'
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= EXPECTED_RESOURCE_NAME then
    lib.print.error('CRITICAL ERROR: Resource name has been changed!')
    lib.print.error(('Expected: %s | Current: %s'):format(EXPECTED_RESOURCE_NAME, currentResourceName))
    lib.print.error('This resource will NOT function properly with a different name!')
    lib.print.error('Please rename the resource back to: ' .. EXPECTED_RESOURCE_NAME)
    return
end

-- Client initialization
CreateThread(function()
    Wait(1000)
    lib.print.info('VIP Client initialized successfully')
end)
