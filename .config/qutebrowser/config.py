# pylint: skip-file
import os

main_color = os.getenv('THEME_MAIN')
main2_color = os.getenv('THEME_MAIN2')
bg_color = os.getenv('THEME_BG')
bgalt_color = os.getenv('THEME_BG_ALT')
hl2_color = os.getenv('THEME_HL2')
hl_color = os.getenv('THEME_HL')
fg_color = os.getenv('THEME_FG')
alert_color = os.getenv('THEME_ALERT')
yellow = os.getenv('THEME_YELLOW')

config.bind(';', 'set-cmd-text :')

config.bind('h', 'tab-prev')
config.bind('l', 'tab-next')

config.bind('H', 'scroll-px -150 0')
config.bind('L', 'scroll-px 150 0')

config.bind('K', 'scroll-page 0 -0.7')
config.bind('J', 'scroll-page 0 0.7')

config.bind('u', 'back')
config.bind('<Alt-u>', 'forward')
config.bind(',v', 'config-source')

config.bind('x', 'tab-close')
config.bind(' x', 'undo')

config.bind('tc', 'tab-close')
config.bind('tn', 'set-cmd-text -s :open -t')
config.bind('tn', 'set-cmd-text -s :open -t')
config.bind('b',  'set-cmd-text -s :buffer')

# color
c.colors.hints.bg = hl2_color
c.colors.hints.fg = fg_color
c.colors.hints.match.fg = hl_color

c.colors.keyhint.bg = bg_color
c.colors.keyhint.suffix.fg = hl2_color

c.colors.messages.error.bg = alert_color
c.colors.messages.error.fg = fg_color

c.colors.messages.info.bg = alert_color

c.colors.messages.warning.bg = yellow

c.colors.completion.category.bg = main_color
c.colors.completion.category.border.bottom = main_color
c.colors.completion.category.border.top = main_color
c.colors.completion.even.bg = bg_color
c.colors.completion.odd.bg = bgalt_color

c.colors.statusbar.normal.bg = bg_color
c.colors.statusbar.insert.bg = main_color

c.fonts.monospace = 'DejaVu Sans Mono'
font = 'DejaVu Sans 8pt'
c.fonts.tabs = font

# keyhint
c.keyhint.delay = 0

# hint
c.hints.border = '1px solid ' + hl2_color
c.hints.chars = 'abcdefghijklmnopqrstuvwxyz'
c.hints.hide_unmatched_rapid_hints = False

c.auto_save.session = True
c.url.searchengines = {
    'DEFAULT': 'https://www.google.com/search?q={}',
    'd': 'https://duckduckgo.com/?q={}'
}
c.zoom.default = 75

# vim: nofoldenable
