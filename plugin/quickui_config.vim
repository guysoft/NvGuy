" vim-quickui Menu Configuration
" Place this file in: <stdpath('config')>/plugin/quickui_config.vim
" It will be automatically sourced by the plugin config function

" Load guard — prevent double-sourcing on initial startup (Neovim
" auto-loads plugin/ files). The deferred config function in init.lua
" intentionally unsets g:quickui_config_loaded and re-sources this file
" after quickui#menu#reset() so the menus are rebuilt correctly for
" leader+m. See lua/plugins/init.lua for the re-source logic.
if exists('g:quickui_config_loaded') | finish | endif
let g:quickui_config_loaded = 1

" Clear any existing menus
call quickui#menu#reset()

" ============================================================================
" Helper Functions (must be defined before menus)
" ============================================================================

" Show recent sessions submenu with grouping by project
function! QuickUI_OpenRecentSessions()
    " Get all session files using Lua
    let session_files = luaeval("vim.fn.glob(vim.fn.stdpath('data') .. '/possession/*.json', 0, 1)")
    
    if empty(session_files)
        echo "No sessions found"
        return
    endif
    
    " Build list of sessions with metadata
    let sessions = []
    for filepath in session_files
        " Get file modification time and session name
        let mtime = getftime(filepath)
        let basename = fnamemodify(filepath, ':t:r')
        
        " Decode URL-encoded session name (possession uses URL encoding)
        let session_name = substitute(basename, '%2F', '/', 'g')
        let session_name = substitute(session_name, '%7E', '~', 'g')
        let session_name = substitute(session_name, '%3A', ':', 'g')
        
        " Try to read JSON to get working directory
        try
            let json_content = join(readfile(filepath), "\n")
            let session_data = json_decode(json_content)
            let cwd = get(session_data, 'cwd', 'Unknown')
        catch
            let cwd = 'Unknown'
        endtry
        
        call add(sessions, {'name': basename, 'display': session_name, 'cwd': cwd, 'mtime': mtime})
    endfor
    
    " Sort by modification time (newest first)
    call sort(sessions, {a, b -> b.mtime - a.mtime})
    
    " Take only top 5
    let sessions = sessions[0:4]
    
    " Group by project/directory
    let grouped = {}
    for session in sessions
        let cwd = session.cwd
        if !has_key(grouped, cwd)
            let grouped[cwd] = []
        endif
        call add(grouped[cwd], session)
    endfor
    
    " Build menu content
    let content = []
    for cwd in sort(keys(grouped))
        " Add directory header (as separator with text)
        if len(content) > 0
            call add(content, ['--', ''])
        endif
        call add(content, ['📁 ' . cwd, '', 'Project directory'])
        
        " Add sessions under this directory
        for session in grouped[cwd]
            " Simplify display name
            let display_text = session.display
            
            " If session name looks like a path (contains slashes)
            if display_text =~ '/'
                 " Check if it matches the CWD (default auto-session)
                 " Normalize paths for comparison (expand ~ to full path)
                 let expanded_session = fnamemodify(display_text, ':p')
                 let expanded_cwd = fnamemodify(cwd, ':p')
                 
                 " Remove trailing slashes
                 let expanded_session = substitute(expanded_session, '/$', '', '')
                 let expanded_cwd = substitute(expanded_cwd, '/$', '', '')
                 
                 if expanded_session ==# expanded_cwd
                     let display_text = '(auto-saved)' 
                 else
                     " Show just the filename part for other path-based sessions
                     let display_text = fnamemodify(display_text, ':t')
                 endif
            endif

            let display_name = '  ' . display_text
            
            " Use decoded name for the command
            let cmd = 'SLoad ' . session.display
            let help = 'Load session: ' . session.display
            call add(content, [display_name, cmd, help])
        endfor
    endfor
    
    if empty(content)
        echo "No recent sessions found"
        return
    endif
    
    call quickui#context#open(content, {})
endfunction

" ============================================================================
" File Menu
" ============================================================================
call quickui#menu#install('&File', [
    \ [ '&New File', 'enew', 'Create a new file' ],
    \ [ '&Open', 'Telescope find_files', 'Browse and open file (Telescope)' ],
    \ [ 'Open in &Project', 'Telescope find_files', 'Open file in project' ],
    \ [ '&Save', 'write', 'Save current file' ],
    \ [ 'Save &As', 'call feedkeys(":saveas ")', 'Save file as' ],
    \ [ '--', ],
    \ [ 'Save Se&ssion', 'call feedkeys(":SSave ")', 'Save current session' ],
    \ [ 'Recent Session&s', 'call QuickUI_OpenRecentSessions()', 'Load a recent session' ],
    \ [ '--', ],
    \ [ '&Recent Files', 'Telescope oldfiles', 'Open recent files' ],
    \ [ '&Close', 'close', 'Close current window' ],
    \ [ '--', ],
    \ [ '&Quit', 'quit', 'Quit vim' ],
    \ ])

" ============================================================================
" Edit Menu
" ============================================================================
call quickui#menu#install('&Edit', [
    \ [ '&Undo', 'undo', 'Undo last change' ],
    \ [ '&Redo', 'redo', 'Redo last change' ],
    \ [ '--', ],
    \ [ 'Cu&t', '"+x', 'Cut to clipboard' ],
    \ [ '&Copy', '"+y', 'Copy to clipboard' ],
    \ [ '&Paste', '"+p', 'Paste from clipboard' ],
    \ [ '--', ],
    \ [ '&Find', 'Telescope live_grep', 'Find in files' ],
    \ [ 'Find and &Replace', 'call feedkeys(":%s/")', 'Find and replace' ],
    \ [ '--', ],
    \ [ '&File Operations', 'call <SID>open_edit_fileops()', 'File encoding, format, etc.' ],
    \ [ '&Search/Replace', 'call <SID>open_edit_search()', 'Advanced search and replace' ],
    \ ])

" ============================================================================
" View Menu
" ============================================================================
call quickui#menu#install('&View', [
    \ [ '&File Explorer', 'NvimTreeToggle', 'Toggle file explorer' ],
    \ [ '&Buffers', 'Telescope buffers', 'List buffers' ],
    \ [ '&Symbols', 'Telescope lsp_document_symbols', 'Show document symbols' ],
    \ [ '--', ],
    \ [ '&Diagnostics', 'Telescope diagnostics', 'Show diagnostics' ],
    \ [ '&Quickfix', 'copen', 'Open quickfix window' ],
    \ ])

" ============================================================================
" Git Menu
" ============================================================================
call quickui#menu#install('&Git', [
    \ [ '&Neogit', 'Neogit', 'Open Neogit (magit-style interface)' ],
    \ [ '--', ],
    \ [ '&Status', 'Telescope git_status', 'Git status (Telescope)' ],
    \ [ 'Co&mmits', 'Telescope git_commits', 'Git commits (Telescope)' ],
    \ [ '&Branches', 'Telescope git_branches', 'Git branches (Telescope)' ],
    \ [ '--', ],
    \ [ '&Diff', 'Gitsigns diffthis', 'Show diff for current file' ],
    \ [ 'Bl&ame Line', 'lua require("gitsigns").blame_line{full=true}', 'Show blame for current line' ],
    \ [ '&Toggle Line Blame', 'Gitsigns toggle_current_line_blame', 'Toggle inline blame (like GitLens)' ],
    \ [ '--', ],
    \ [ '&Preview Hunk', 'Gitsigns preview_hunk', 'Preview current hunk changes' ],
    \ [ '&Reset Hunk', 'Gitsigns reset_hunk', 'Reset current hunk' ],
    \ [ 'Stage &Hunk', 'Gitsigns stage_hunk', 'Stage current hunk' ],
    \ ])

" ============================================================================
" Tools Menu
" ============================================================================
call quickui#menu#install('&Tools', [
    \ [ '&Terminal', 'terminal', 'Open terminal' ],
    \ [ '&Lazy', 'Lazy', 'Plugin manager' ],
    \ [ '&Mason', 'Mason', 'LSP installer' ],
    \ [ '--', ],
    \ [ '&Commands', 'Telescope commands', 'Show commands' ],
    \ [ '&Keymaps', 'Telescope keymaps', 'Show keymaps' ],
    \ [ '&Help', 'Telescope help_tags', 'Search help' ],
    \ ])

" ============================================================================
" Window Menu
" ============================================================================
call quickui#menu#install('&Window', [
    \ [ 'Split &Horizontal', 'split', 'Split window horizontally' ],
    \ [ 'Split &Vertical', 'vsplit', 'Split window vertically' ],
    \ [ '--', ],
    \ [ 'Close &Other', 'only', 'Close all other windows' ],
    \ [ '&Equalize', '<C-w>=', 'Equalize window sizes' ],
    \ [ 'Ma&ximize', '<C-w>_<C-w>|', 'Maximize current window' ],
    \ [ '--', ],
    \ [ 'Rotate &Up', '<C-w>R', 'Rotate windows upward' ],
    \ [ 'Rotate &Down', '<C-w>r', 'Rotate windows downward' ],
    \ ])

" ============================================================================
" Marks Menu
" ============================================================================
call quickui#menu#install('&Marks', [
    \ [ '&Set Mark', 'call feedkeys("m")', 'Set a mark' ],
    \ [ '&View Marks', 'marks', 'View all marks' ],
    \ [ '&Clear Mark', 'call feedkeys(":delm ")', 'Clear a mark' ],
    \ ])

" ============================================================================
" Jumps Menu
" ============================================================================
call quickui#menu#install('&Jumps', [
    \ [ '&Jump to Last Edit', "normal! '.", 'Jump to last edit position' ],
    \ [ '&Jump to Last Pos', "normal! ''", 'Jump to last position' ],
    \ ])


" ============================================================================
" Spell Menu
" ============================================================================
call quickui#menu#install('&Spell', [
    \ [ '&Toggle Spell', 'set spell!', 'Toggle spell checking' ],
    \ [ '--', ],
    \ [ '&Next Error', ']s', 'Next spelling error' ],
    \ [ '&Previous Error', '[s', 'Previous spelling error' ],
    \ [ '--', ],
    \ [ '&Add Word', 'zg', 'Add word to dictionary' ],
    \ [ '&Mark Wrong', 'zw', 'Mark word as wrong' ],
    \ ])

" ============================================================================
" History Menu
" ============================================================================
call quickui#menu#install('&History', [
    \ [ '&Command History', 'history', 'View command history' ],
    \ [ '&Search History', 'history /', 'View search history' ],
    \ [ '--', ],
    \ [ '&Clear History', 'history clear', 'Clear command history' ],
    \ ])

" ============================================================================
" Options Menu
" ============================================================================
call quickui#menu#install('&Options', [
    \ [ '&Line Numbers', 'set number!', 'Toggle line numbers' ],
    \ [ '&Relative Numbers', 'set relativenumber!', 'Toggle relative numbers' ],
    \ [ '--', ],
    \ [ '&List Chars', 'set list!', 'Toggle invisible chars' ],
    \ [ '&Wrap', 'set wrap!', 'Toggle line wrap' ],
    \ [ '&Cursor Line', 'set cursorline!', 'Toggle cursor line' ],
    \ ])

" ============================================================================
" Help Menu
" ============================================================================
call quickui#menu#install('&Help', [
    \ [ '&Vim Help', 'help', 'Open vim help' ],
    \ [ '&About', 'version', 'Show version info' ],
    \ [ '--', ],
    \ [ '&View Mappings', ':Telescope keymaps', 'View all key mappings' ],
    \ [ '&View Settings', ':set all', 'View all settings' ],
    \ ])

" ============================================================================
" Run Menu (requires nvim-launch / vscodium.nvim + nvim-dap)
" ============================================================================
call quickui#menu#install('&Run', [
    \ [ '&Run                   Ctrl+F5', 'lua require("nvim-launch").run()', 'Pick a config and run without debugger (in tmux pane)' ],
    \ [ 'Start &Debugging          F6', 'lua require("nvim-launch").debug()', 'Pick a config and start debugging' ],
    \ [ '--', ],
    \ [ 'R&un Last              Ctrl+F6', 'lua require("nvim-launch").run_last()', 'Re-run last config without debugger' ],
    \ [ 'De&bug Last                  ', 'lua require("nvim-launch").debug_last()', 'Re-run last debug session' ],
    \ [ '--', ],
    \ [ '&Toggle Breakpoint        F9', 'lua require("dap").toggle_breakpoint()', 'Toggle breakpoint on current line' ],
    \ [ '&Conditional Breakpoint      ', 'lua require("nvim-launch").conditional_breakpoint()', 'Set breakpoint with condition' ],
    \ [ 'Clear &All Breakpoints      ', 'lua require("dap").clear_breakpoints()', 'Remove all breakpoints' ],
    \ [ '--', ],
    \ [ '&Continue                 F5', 'lua require("dap").continue()', 'Resume paused debug session' ],
    \ [ 'Step &Over            leader+do', 'lua require("dap").step_over()', 'Step over current line' ],
    \ [ 'Step &Into               F11', 'lua require("dap").step_into()', 'Step into function' ],
    \ [ 'Ste&p Out             Shift+F11', 'lua require("dap").step_out()', 'Step out of function' ],
    \ [ '&Stop                 Shift+F5', 'lua require("dap").terminate()', 'Stop debug session' ],
    \ [ '--', ],
    \ [ 'Toggle Debug &UI     leader+du', 'lua require("dapui").toggle()', 'Toggle debug UI panels' ],
    \ [ 'Open &launch.json   leader+dl', 'lua require("nvim-launch.launch_json").open_launch_json()', 'Open or create launch.json' ],
    \ ])

" ============================================================================
" Edit -> File Operations Submenu
" ============================================================================
function! s:open_edit_fileops()
    let content = [
        \ [ '&File Info', '<C-g>', 'Show file information' ],
        \ [ 'File &Path', '1<C-g>', 'Show full file path' ],
        \ [ '--', ],
        \ [ '&Word Count', 'g<C-g>', 'Count words in file' ],
        \ [ '--', ],
        \ [ 'Set &Encoding', 'call feedkeys(":set fileencoding=")', 'Change file encoding' ],
        \ [ 'Set &Format', 'call feedkeys(":set fileformat=")', 'Change line endings' ],
        \ [ 'View &Format', 'set fileformat?', 'View current format' ],
        \ ]
    call quickui#context#open(content, {})
endfunction

" ============================================================================
" Edit -> Search/Replace Submenu
" ============================================================================
function! s:open_edit_search()
    let content = [
        \ [ '&Search', 'call feedkeys("/")', 'Search forward' ],
        \ [ 'Search &Backward', 'call feedkeys("?")', 'Search backward' ],
        \ [ '--', ],
        \ [ '&Next Match', 'n', 'Next search match' ],
        \ [ '&Previous Match', 'N', 'Previous search match' ],
        \ [ '--', ],
        \ [ '&Replace', 'call feedkeys(":%s/")', 'Replace in file' ],
        \ [ 'Replace &Confirm', 'call feedkeys(":%s//gc")', 'Replace with confirmation' ],
        \ [ 'Replace in &Selection', 'call feedkeys(":'<,'>s/")', 'Replace in visual selection' ],
        \ ]
    call quickui#context#open(content, {})
endfunction

" ============================================================================
" Reload Command
" ============================================================================
" Command to reload the entire quickui configuration
command! QuickUIReload call quickui#menu#reset() | execute 'source ' . stdpath('config') . '/plugin/quickui_config.vim' | echo "QuickUI config reloaded"

" ============================================================================
" Keybindings
" ============================================================================

" Open menu bar with F10 or <leader>m
nnoremap <silent> <F10> :call quickui#menu#open()<CR>
nnoremap <silent> <leader>m :call quickui#menu#open()<CR>

" Open Telescope keymaps with <leader>k
nnoremap <silent> <leader>k :Telescope keymaps<CR>

" ============================================================================
" Context Menu Function
" ============================================================================
function! s:show_context_menu()
    " Define context menu items
    let content = [
        \ [ 'Go to &Definition', 'lua vim.lsp.buf.definition()', 'Go to definition' ],
        \ [ 'Go to &References', 'lua vim.lsp.buf.references()', 'Find references' ],
        \ [ 'Go to &Implementation', 'lua vim.lsp.buf.implementation()', 'Go to implementation' ],
        \ [ '--', ],
        \ [ '&Hover', 'lua vim.lsp.buf.hover()', 'Show hover info' ],
        \ [ '&Rename', 'lua vim.lsp.buf.rename()', 'Rename symbol' ],
        \ [ '&Code Action', 'lua vim.lsp.buf.code_action()', 'Show code actions' ],
        \ [ '--', ],
        \ [ '&Format', 'lua vim.lsp.buf.format()', 'Format code' ],
        \ ]
    
    " Open context menu at current line
    call quickui#context#open(content, {'index': line('.')})
endfunction

" ============================================================================
" Confirmation Message
" ============================================================================
" Startup message removed — was causing duplicate output due to
" double-sourcing (plugin/ autoload + explicit source in init.lua).

" ============================================================================
" CUSTOMIZATION GUIDE
" ============================================================================
"
" Menu Item Format:
" [ 'Display &Name', 'command', 'description' ]
"
" - Display Name: Text shown in menu
"   - Use & before a letter to create a hotkey (e.g., &File = Alt+F)
" - Command: Any Vim/Neovim command to execute
"   - Can be Ex commands: 'write', 'quit', etc.
"   - Can be Lua commands: 'lua vim.lsp.buf.format()'
"   - Can be plugin commands: 'Telescope find_files'
" - Description: Shows in command line when hovering
"
" Separator:
" [ '--', ]
"
" Example - Adding a Custom Menu:
"
" call quickui#menu#install('&Custom', [
"     \ [ '&Hello World', 'echo "Hello!"', 'Print hello' ],
"     \ [ '&Run Script', '!./script.sh', 'Execute script' ],
"     \ [ '--', ],
"     \ [ '&Lua Function', 'lua print("From Lua")', 'Call Lua' ],
"     \ ])
"
" Example - File Type Specific Context Menu:
"
" function! s:show_python_menu()
"     let content = [
"         \ [ 'Run &Python', '!python %', 'Run current file' ],
"         \ [ 'Run &Tests', '!pytest', 'Run pytest' ],
"         \ [ 'Format with &Black', '!black %', 'Format with black' ],
"         \ ]
"     call quickui#context#open(content, {'index': line('.')})
" endfunction
"
" autocmd FileType python nnoremap <buffer> <leader>k :call <SID>show_python_menu()<CR>
"
" ============================================================================


