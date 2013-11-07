"==============================================================================
" File: sunflower.vim
" Description: Adjust colorscheme depending on whether it is night or day.
" Maintainer: Göktuğ Kayaalp <self@gkayaalp.com>
" Version: 0.1.0
" License: BSD2 <../LICENSE>
"==============================================================================

if !exists('g:sunflower_lat') || !exists('g:sunflower_long') || !has('python')
    finish
endif

if !exists('g:sunflower_colorscheme_night')
    let g:sunflower_colorscheme_night='default'
endif

if !exists('g:sunflower_colorscheme_day')
    let g:sunflower_colorscheme_day='default'
endif

if !exists('g:sunflower_set_background')
    let g:sunflower_set_background=1
endif

if !exists('g:sunflower_install_autocommand')
    let g:sunflower_install_autocommand=1
endif

let g:__sunflower_has_autocmd=0
if has('autocmd')
    let g:__sunflower_has_autocmd=1
endif

python <<EOF
import vim
import ephem
from datetime import datetime

next_rise = None
next_set = None
previous_rise = None
previous_set = None
autocommand_installed = False

observer = ephem.Observer()
observer.lat = str(vim.vars['sunflower_lat'])
observer.long = str(vim.vars['sunflower_lat'])

def update():
    global next_rise, next_set, previous_rise, previous_set
    next_rise = ephem.localtime(observer.next_rising(ephem.Sun()))
    next_set = ephem.localtime(observer.next_setting(ephem.Sun()))
    previous_rise = ephem.localtime(observer.previous_rising(ephem.Sun()))
    previous_set = ephem.localtime(observer.previous_setting(ephem.Sun()))
    if (not autocommand_installed) and bool(vim.vars['sunflower_install_autocommand'])\
        and bool(vim.vars['__sunflower_has_autocmd']):
        vim.command('au CursorHold,BufWritePost,VimEnter * call FindTheSun()')

update()

def change():
    set_background = bool(vim.vars['sunflower_set_background'])
    now = datetime.now()
    if previous_set < now < next_rise:
        vim.command('colorscheme %s' % vim.vars['sunflower_colorscheme_night'])
        if set_background:
            vim.command('set background=dark')
        return True
    elif previous_rise < now < next_set:
        vim.command('colorscheme %s' % vim.vars['sunflower_colorscheme_day'])
        if set_background:
            vim.command('set background=light')
        return True
    return False

EOF


function! FindTheSun()
python <<EOF
if not change():
    update()
    change()
EOF
endfunction

call FindTheSun()

