-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.opt.langmap =
  "αa,βb,γg,δd,εe,ζz,ηh,θu,ιi,κk,λl,μm,νn,ξj,οo,πp,ρr,σs,τt,υy,φf,χx,ψc,ωV,ςw,ΑA,ΒB,ΓG,ΔD,ΕE,ΖZ,ΗH,ΘU,ΙI,ΚK,ΛL,ΜM,ΝN,ΞJ,ΟO,ΠP,ΡR,ΣS,ΤT,ΥY,ΦF,ΧX,ΨC,ΩV"

vim.g.mapleader = " "


vim.keymap.set("i", "jj", "<Esc>")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
  require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
  require("vim-with-me").StopVimWithMe()
end)

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>")
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

vim.keymap.set("n", "<leader>wr", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, { noremap = true, silent = true, desc = "Toggle word wrap" })

vim.keymap.set("n", "<leader>bs", function()
  local current = vim.opt.showtabline:get()
  if current == 0 then
    vim.opt.showtabline = 2
    vim.g.bufferline_enabled = true
  else
    vim.opt.showtabline = 0
    vim.g.bufferline_enabled = false
  end
end)

vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("BufferlineState", { clear = true }),
  callback = function()
    if vim.g.bufferline_enabled == false then
      vim.o.showtabline = 0
    end
  end,
})

vim.keymap.set("n", "<leader>f.e", ":e .env<CR>", { desc = "Open .env file" })
vim.keymap.set("n", "<leader>f.g", ":e .gitignore<CR>", { desc = "Open .gitignore file" })
vim.keymap.set(
  "n",
  "<leader>f.N",
  ":e .nvim.lua<CR>",
  { desc = "Open .nvim.lua file for nvim project configuration ;)" }
)

vim.keymap.set(
  "n",
  "<leader>f.n",
  ":e nginx/nginx.conf<CR>",
  { desc = "Open nginx conf inside nginx dir" }
)
vim.keymap.set("n", "<leader>f.d", ":e docker-compose.yml<CR>", { desc = "Open docker-compose.yml" })
vim.keymap.set("n", "<leader>f.D", ":e Dockerfile<CR>", { desc = "Open Dockerfile" })

vim.keymap.set("n", "<leader>pd", function()
  require("fzf-lua").fzf_exec("find . -type d -not -path '*/.git/*' -not -name '.git'", {
    prompt = "Directories> ",
    actions = {
      ["default"] = function(selected)
        if selected and selected[1] then
          vim.cmd.Ex(selected[1])
        end
      end,
    },
  })
end, { desc = "Find directories and open in NetRW" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Normal mode from terminal mode" })

vim.keymap.set("n", "gliam", function()
  -- Prompt the user for the issue title
  local title = vim.fn.input("GitLab Issue Title: ")

  -- If the user cancels or enters an empty title, abort the operation
  if title == "" then
    print("Issue creation cancelled: No title provided.")
    return
  end

  -- Initialize a table to store description lines
  local description_lines = {}
  local line_num = 1
  local current_line = ""

  -- Loop to collect multiple lines for the description
  print("Enter GitLab Issue Description (empty line to finish):")
  while true do
    current_line = vim.fn.input(string.format("Line %d: ", line_num))
    if current_line == "" then
      -- User entered an empty line, so stop collecting description
      break
    else
      table.insert(description_lines, current_line)
      line_num = line_num + 1
    end
  end

  -- Join the collected lines with newline characters
  local description = table.concat(description_lines, "\n")

  -- Escape the title to safely pass it as a command-line argument.
  -- vim.fn.shellescape will correctly quote the string for the shell.
  local escaped_title = vim.fn.shellescape(title)

  -- Create a temporary file to store the description content.
  -- This is the most robust way to handle multi-line strings and special characters.
  local tmp_file_path = vim.fn.tempname()
  local file = io.open(tmp_file_path, "w")

  if file then
    file:write(description)
    file:close()
  else
    print("Error: Could not create temporary file for description.")
    return
  end

  -- Construct the glab command.
  -- We now include the --description flag and use shell command substitution
  -- `$(cat <temp_file_path>)` to insert the content of the temporary file
  -- as the argument for the description. This is robust for multi-line and special chars.
  local cmd = string.format(
    'glab issue create --assignee @me --title %s --description "$(cat %s)"',
    escaped_title,
    vim.fn.shellescape(tmp_file_path)
  )

  -- Inform the user that the command is being executed
  print("Calling glab to create issue...")
  -- Optional: For debugging, uncomment the next line to see the full command being executed
  -- print("Executing command: " .. cmd)

  -- Execute the glab command in a new terminal buffer.
  -- The '!' prefix tells vim.cmd to run the command in the shell.
  -- The output of the glab command will be displayed in a new buffer,
  -- providing feedback on whether the issue was created successfully.
  vim.cmd("!" .. cmd)

  -- Clean up the temporary file after the command has executed.
  -- This removes the temporary file from your system.
  os.remove(tmp_file_path)

  -- Provide a final message to the user
  print("glab command executed. Check the new buffer for output.")
end, {
  desc = "Open new issue with me as assignee (multi-line description)", -- Updated description
})

vim.keymap.set("n", "<leader>px", ":!python ~/scripts/yml_to_xml.py<CR>")
vim.keymap.set("n", "<leader>pf", "<leader>fF", { remap = true })

-- remove leader l for lazy. who the fuck uses this?
vim.keymap.del("n", "<leader>l")

vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>')


-- some cool stuff
-- Remap for converting snake_case to camelCase in Visual mode
-- CORRECTED: Visual snake_case to camelCase
vim.keymap.set('v', '<leader>ctc', ':s/_\\(.\\)/\\U\\1/g<CR>', { desc = "Visual to camelCase" })

-- CORRECTED: Visual camelCase to snake_case
vim.keymap.set('v', '<leader>cts', ':s/\\([A-Z]\\)/_\\l\\1/g<CR>', { desc = "Visual to snake_case" })

-- TypeScript/JavaScript arrow function helper
-- When typing (( in insert mode, expand to () => with cursor inside parentheses
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
--   callback = function()
--     vim.keymap.set("i", "(=", "() => <Left><Left><Left><Left><Left>", { buffer = true, desc = "Insert arrow function" })
--     vim.keymap.set("i", "(}", "() => {}<Left><Left><Left><Left><Left><Left><Left>", { buffer = true, desc = "Insert arrow function" })
--   end,
-- })
