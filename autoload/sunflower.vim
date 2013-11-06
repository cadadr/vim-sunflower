"==============================================================================
" File: sunflower.vim
" Description: Adjust colorscheme depending on whether it is night or day.
" Maintainer: Göktuğ Kayaalp <self@gkayaalp.com>
" Version: 0.1.0
" License: BSD2 <../LICENSE>
"==============================================================================

" TODO See `:help help-writing' for help on documentation.

if !exists('g:sunflower_lat') || !exists('g:sunflower_long') || !has('python')
    finish
endif

if !exists('g:sunflower_colorscheme_night')
    let g:sunflower_colorscheme_night='default'
endif

if !exists('g:sunflower_colorscheme_day')
    let g:sunflower_colorscheme_day='default'
endif

if exists('g:sunflower_colorscheme_all')
    let g:sunflower_colorscheme_night=g:sunflower_colorscheme_all
    let g:sunflower_colorscheme_day=g:sunflower_colorscheme_all
endif

function! sunflower#FindTheSun()
python <<EOF
import vim
import ephem
from datetime import datetime

day_colours = vim.vars['sunflower_colorscheme_day']
night_colours = vim.vars['sunflower_colorscheme_night']

observer = ephem.Observer()
observer.lat = str(vim.vars['sunflower_lat'])
observer.long = str(vim.vars['sunflower_lat'])
sun = ephem.Sun()
sun.compute()
next_rise = ephem.localtime(observer.next_rising(sun))

now = datetime.now()

if next_rise > now:
    vim.command('colorscheme %s' % night_colours)
    vim.command('set background=dark')
else:
    vim.command('colorscheme %s' % day_colours)
    vim.command('set background=light')
EOF
endfunction

