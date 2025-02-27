local function is_in_vaults()
    local current_dir = vim.fn.expand('%:p:h')
    return current_dir:match("/Vaults/")
end

if is_in_vaults() then
    require("obsidian").setup({
        workspaces = {
            {
                name = "Notes",
                path = "/mnt/Vaults/Notes/",
            },
            {
                name = "School",
                path = "/mnt/Vaults/School2.0",
            },
            {
                name = "CodingAcademy",
                path = "/mnt/Vaults/CodingAcademy",
            },
            {
                name = "InDigital",
                path = "/mnt/Vaults/InDigital",
            },
        }
    })
end
