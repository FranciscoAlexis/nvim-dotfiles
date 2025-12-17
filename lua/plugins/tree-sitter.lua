--@module "lazy"
--@type LazySpec

return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-context',
    },
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()

        local ts = require('nvim-treesitter')

        ts.install({
            'bash',
            'comment',
            'css',
            'diff',
            'fish',
            'git_config',
            'git_rebase',
            'gitcommit',
            'gitignore',
            'html',
            'javascript',
            'json',
            'latex',
            'lua',
            'luadoc',
            'make',
            'markdown',
            'markdown_inline',
            'norg',
            'objc',
            'python',
            'query',
            'regex',
            'scss',
            'svelte',
            'swift',
            'toml',
            'tsx',
            'typescript',
            'typst',
            'vim',
            'vimdoc',
            'vue',
            'xml',
        }, {
            max_jobs = 8
        })

        local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

        local ignore_filetypes = {
            'checkhealth',
            'lazy',
            'mason',
            'snacks_dashboard',
            'snacks_notif',
            'snacks_win',
        }

        -- Auto-install parsers and enable highlightning on FileType
        vim.api.nvim_create_autocmd('FileType', {
            group = group,
            desc = 'Enable treesitter highlightning and indentation',
            callback = function(event)
                if vim.tbl_contains(ignore_filetypes, event.match) then
                    return
                end

                local lang = vim.treesitter.language.get_lang(event.match) or event.match
                local buf = event.buf

                -- Start highlighting immediately (works if parser exists)
                pcall(vim.treesitter.start, buf, lang)

                -- Enable treesitter indentation
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                -- Install missing parsers (async, no-op of already installed)
                ts.install({ lang })
            end,
        })
    end,
}
