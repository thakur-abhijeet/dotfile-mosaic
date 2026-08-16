from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class Custom(ColorScheme):
    def use(self, context):
        fg, bg, attr = default_colors
        if context.reset: return default_colors
        elif context.in_browser:
            if context.selected: attr = reverse
            if context.directory: fg = 4
            elif context.executable: fg = 2
            if context.link: fg = 6
        elif context.in_titlebar:
            if context.hostname: fg = 1
        return fg, bg, attr
