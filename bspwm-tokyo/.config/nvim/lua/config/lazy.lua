local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Explorador de archivos
    { "nvim-neo-tree/neo-tree.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
      config = function()
          require("neo-tree").setup()

        -- Abrir Neo-tree automáticamente al iniciar Neovim
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                vim.cmd("Neotree show")
            end
        })
      end
    },{
        "mfussenegger/nvim-dap"
    },

    -- LSP y autocompletado
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-cmp",
      dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip"
      },
      config = function()
          local cmp = require("cmp")
          cmp.setup({
              snippet = {
                  expand = function(args)
                      require("luasnip").lsp_expand(args.body)
                  end,
              },
              mapping = cmp.mapping.preset.insert({
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(4),
                    ['<C-s>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
              }),
              sources = cmp.config.sources({
                  { name = "nvim_lsp" },
                  { name = "luasnip"},
                  { name = "buffer" },
                  { name = "path" },
              })
          })
      end
    },
    {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Lista de servidores LSP
        local servers = {
            "html", "cssls", "ts_ls", "bashls",
            "clangd", "lua_ls", "jsonls", "marksman", "jdtls", "tailwindcss"
        }

        for _, server in ipairs(servers) do
            lspconfig[server].setup({ capabilities = capabilities })
        end
        require'lspconfig'.pyright.setup{}  -- Configuración para Python
    end
},

-- LSP para LaTeX
{
    "lervag/vimtex",
    config = function()
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_syntax_enabled = 1
    end
},

    -- Temas y estétic
    {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
        config = function ()
            vim.cmd('colorscheme tokyonight-storm')
            
        end
    }, 

    -- Árbol de sintaxis
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",

    config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = { "c", "lua", "javascript", "css", "html", "cpp", "markdown_inline", "java", "typescript", "python" },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                
            },
             indent = {
                enable = true,  -- Activa la indentación con Tree-sitter
            },
        }
        
    end

},

    {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Asegurar que los íconos funcionen
    config = function()
        require("lualine").setup({
            options = {
                theme = "tokyonight-storm", -- Puedes cambiar el tema
                icons_enabled = true,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                globalstatus = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            }
        })
    end
},

{
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Asegurar que los íconos funcionen
    config = function()
        require("bufferline").setup({
            options = {
                diagnostics = "nvim_lsp",
                offsets = {
                    { filetype = "neo-tree", text = "File Explorer", highlight = "Directory", text_align = "left" }
                },
                separator_style = "thin" -- Puedes cambiar a "thin", "thick", etc.
            }
        })
    end
},

{
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- Carga solo cuando entras en modo inserción
    config = function()
        require("nvim-autopairs").setup({
            check_ts = true, -- Habilita Treesitter para pares más inteligentes
        })
    end
},

{
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Asegurar Treesitter
    config = function()
        require("nvim-ts-autotag").setup()
    end
},
 {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end
  },
    {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()
  end,
},

{
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "clangd",
      }
    })
  end,
},

{
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-nvim-dap").setup({
      ensure_installed = {
        "codelldb",
      }
    })
  end,
},

{
  "stevearc/conform.nvim", -- si usas un formatter como conform.nvim
  opts = {
    formatters_by_ft = {
      cpp = { "clang-format" },
    },
    formatters = {
      ["clang-format"] = {
        command = "clang-format", -- asegúrate de que esté instalado por Mason
      },
    },
  },
}, {
  "ellisonleao/carbon-now.nvim",
  lazy = true,
  cmd = "CarbonNow",
        config = function ()
            local carbon = require('carbon-now')
                carbon.setup({
                    options ={
                        theme = "material",
                        font_family = "Fira Code NerdFont",
                    }
                })
            
        end

  
},
    
  -- amongst your other plugins
  {'akinsho/toggleterm.nvim', version = "*", config = function ()
		require("toggleterm").setup({
			size = 15,

			open_mapping = [[<C-\>]],

			direction = "horizontal",

			shell = "/bin/zsh",
		})
  	
  end
	},
    {"xiyaowong/transparent.nvim", config = function ()
         -- Optional, you don't have to run setup.
        require("transparent").setup({
    -- table: default groups
        groups = {
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
        'EndOfBuffer',
        },
        -- table: additional groups that should be cleared
        extra_groups = {
                "NormalFloat",
                "Neotree",
                "BufferLine"
            },
        -- table: groups you don't want to clear
        exclude_groups = {},
        -- function: code to be executed after highlight groups are cleared
        -- Also the user event "TransparentClear" will be triggered
        on_clear = function() end,
})
        
    end}

  
 

  


})

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true }) -- Cerrar buffer actual

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Buscar archivos" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Buscar texto en archivos" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").current_buffer_fuzzy_find, { desc = "Buscar en archivo actual" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Buscar entre buffers" })

vim.diagnostic.config({
    virtual_text = true,
    sings = true,
    underline = true,

})

vim.keymap.set("n", "pr", vim.diagnostic.goto_prev) -- error anterior
vim.keymap.set("n", "ne", vim.diagnostic.goto_next) -- erro siguiente
vim.keymap.set("n", "<leader>er", vim.diagnostic.open_float) -- abrir ventana de errores

vim.keymap.set("v", "<leader>cn", ":CarbonNow<CR>", { silent = true })

vim.keymap.set('n', '<leader>m',
function ()
        local cmd = [[kitty @ lauch --type=window --cwd=current sh -c "make; exec zsh"]]
        vim.fn.system(cmd)
end, {desc = "Ejecutar make en kitty"})

