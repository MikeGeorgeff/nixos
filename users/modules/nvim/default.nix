{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      neovim-ayu
      lualine-nvim
      nvim-treesitter.withAllGrammars
      telescope-nvim
      nvim-tree-lua
      nvim-lspconfig
      vim-nix
      indent-blankline-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      gitsigns-nvim
      barbar-nvim
      nvim-web-devicons
      vim-fugitive
      undotree
      nvim-autopairs
    ];

    extraPackages = with pkgs; [
      # for telescope-nvim
      ripgrep
      fd

      # language servers
      nodejs_18
      nil
      phpactor
      php81
      php81Packages.composer
      yaml-language-server
      nodePackages.bash-language-server
      dockerfile-language-server-nodejs
    ];

    extraConfig = ''
      set number
      set shiftwidth=4
      set tabstop=4
      set expandtab
      set smarttab
      set ignorecase
      set smartcase
      set nohlsearch " do not highlight search terms

      let mapleader = ","

      " Find files using Telescope command-line sugar.
      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>

      " NvimTree
      nnoremap <leader>n :NvimTreeFocus<cr>
      nnoremap <leader>nc :NvimTreeClose<cr>

      " UndoTree
      nnoremap <leader>z :UndotreeToggle<cr>
      nnoremap <leader>zz :UndotreeFocus<cr>

      let g:undotree_WindowLayout = 2
      let g:undotree_SetFocusWhenToggle = 1

      " BarBar
      " Move to previous/next
      nnoremap <silent> <A-,> <Cmd>BufferPrevious<CR>
      nnoremap <silent> <A-.> <Cmd>BufferNext<CR>

      " Reorder to previous/next
      nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
      nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>

      " Goto buffer in position...
      nnoremap <silent>    <A-1> <Cmd>BufferGoto 1<CR>
      nnoremap <silent>    <A-2> <Cmd>BufferGoto 2<CR>
      nnoremap <silent>    <A-3> <Cmd>BufferGoto 3<CR>
      nnoremap <silent>    <A-4> <Cmd>BufferGoto 4<CR>
      nnoremap <silent>    <A-5> <Cmd>BufferGoto 5<CR>
      nnoremap <silent>    <A-6> <Cmd>BufferGoto 6<CR>
      nnoremap <silent>    <A-7> <Cmd>BufferGoto 7<CR>
      nnoremap <silent>    <A-8> <Cmd>BufferGoto 8<CR>
      nnoremap <silent>    <A-9> <Cmd>BufferGoto 9<CR>
      nnoremap <silent>    <A-0> <Cmd>BufferLast<CR>

      " Pin/unpin buffer
      nnoremap <silent>    <A-p> <Cmd>BufferPin<CR>

      " Close buffer
      nnoremap <silent>    <A-c> <Cmd>BufferClose<CR>

      let g:barbar_auto_setup = v:false

      lua << EOF
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      vim.opt.termguicolors = true

      require('nvim-autopairs').setup {}

      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })

      require('ayu').setup({
        mirage = false, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
        overrides = {}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
      })
      vim.cmd.colorscheme "ayu-dark"

      require'barbar'.setup {
        animation = true,
        auto_hide = false,
        tabpages = true,
        clickable = true,

        exclude_ft = {'javascript'},
        exclude_name = {'package.json'},

        highlight_alternate = false,
        highlight_inactive_file_icons = false,
        highlight_visible = true,

        icons = {
          buffer_index = false,
          buffer_number = false,

          diagnostics = {
            [vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'ff'},
            [vim.diagnostic.severity.WARN] = {enable = false},
            [vim.diagnostic.severity.INFO] = {enable = false},
            [vim.diagnostic.severity.HINT] = {enable = true},
          },

          gitsigns = {
            added = {enabled = true, icon = '+'},
            changed = {enabled = true, icon = '~'},
            deleted = {enabled = true, icon = '-'},
          },

          filetype = {
            enabled = true,
            custom_colors = false,
          },

          separator = {left = '▎', right = ""},
          separator_at_end = true,

          modified = {button = '●'},
          pinned = {button = '', filename = true},

          preset = 'default',

          alternate = {filetype = {enabled = false}},
          current = {buffer_index = true},
          inactive = {button = '×'},
          visible = {modified = {buffer_number = false}},
        };

        insert_at_end = true,

        maximum_padding = 1,
        minimum_padding = 1,
        maximum_length = 30,
        minumum_length = 0,

        sidebar_filetypes = {
          NvimTree = true,
          undotree = true,
        },
      }

      require('lualine').setup({
        options = {
          theme = 'ayu',
        },
        sections = {
          lualine_c = {
            {
              'filename',
              file_status = true,
              path = 1
            },
          },
        },
      })

      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,

          additional_vim_regex_highlighting = false,
        },

        indent = {
          enable = true
        }
      }

      -- Indent blank lines
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require "ibl.hooks"

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      require("ibl").setup { indent = { highlight = highlight } }

      vim.cmd[[
        match ExtraWhitespace /\s\+$/
        highlight ExtraWhitespace ctermbg=red guibg=red
      ]]

      require('gitsigns').setup()

      -- completions
      local cmp = require("cmp")

      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              path = "[PATH]",
            })[entry.source.name]
            return vim_item
          end
        },
        mapping = {
          ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          })
        },
      }

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- language servers
      local lspconfig = require('lspconfig')
      lspconfig.nil_ls.setup {
        capabilities = capabilities
      }
      lspconfig.phpactor.setup {
        capabilities = capabilities
      }
      lspconfig.yamlls.setup {}
      lspconfig.bashls.setup {
        capabilities = capabilities
      }
      lspconfig.dockerls.setup {
        capabilities = capabilities
      }
      EOF
    '';
  };
}
