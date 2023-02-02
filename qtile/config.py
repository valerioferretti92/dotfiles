# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

font_size_screen1 = 14
bar_heigth_screen1 = 24
font_size_screen2 = 14
bar_heigth_screen2 = 24
column_margin = 4
column_margin_on_single = 8
script_path = "/home/stacksmasher/.config/qtile/scripts/"
rofi_path = "/home/stacksmasher/.config/rofi/"

# Respectively 14 - 24 for 1920x1080, 28 - 48 for 3840x2160
primary_screen_res = os.environ.get('PRIMARY_SCREEN_RESOLUTION')
secondary_screen_res = os.environ.get('SECONDARY_SCREEN_RESOLUTION')
if primary_screen_res == "3840x2160" or secondary_screen_res == "3840x2160":
    font_size_screen1 = 28
    bar_heigth_screen1 = 48
    font_size_screen2 = 28
    bar_heigth_screen2 = 48
    column_margin = 8
    column_margin_on_single = 16


@hook.subscribe.startup_once
def autostart_once():
    home = os.path.expanduser('~/.config/qtile/scripts/autostart.sh')
    subprocess.Popen([home])


colors = [["#282c34", "#282c34"],
          ["#1c1f24", "#1c1f24"],
          ["#dfdfdf", "#dfdfdf"],
          ["#ff6c6b", "#ff6c6b"],
          ["#98be65", "#98be65"],
          ["#da8548", "#da8548"],
          ["#51afef", "#51afef"],
          ["#c678dd", "#c678dd"],
          ["#46d9ff", "#46d9ff"],
          ["#a9a1e1", "#a9a1e1"],
          ["#eec900", "#eec900"],
          ["#94aabb", "#94aabb"]]

mod = "mod4"
terminal = guess_terminal()

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(),
        desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(),
        desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(),
        desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(),
        desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),
    Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    Key([mod, "mod1"], "h", lazy.layout.flip_left()),
    Key([mod, "mod1"], "l", lazy.layout.flip_right()),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(),
        desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(),
        desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split unsplit"),
    Key([mod], "Return", lazy.spawn(terminal),
        desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(),
        desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(),
        desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(),
        desc="Reload the config"),
    Key([mod, "control"], "k", lazy.shutdown(),
        desc="Shutdown Qtile"),

    # Custom key bindings
    Key([mod], "g", lazy.spawn("google-chrome-stable"),
        desc="Launch google chrome browser"),
    Key([mod, "control"], "q", lazy.spawn("betterlockscreen --lock"),
        desc="Lock screen"),
    Key([mod], "r", lazy.spawn(rofi_path+"launchers/type-4/launcher.sh"),
        desc="Rofi app launcher"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer set Master 5%+"),
        desc="Volume up"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer set Master 5%-"),
        desc="Volume down"),
    Key([], "XF86AudioMute", lazy.spawn("amixer -q sset Master toggle"),
        desc="Volume zero"),
    Key([], "Print", lazy.spawn(script_path+"screenshot -f"),
        desc="Screenshoot"),
    Key([mod], "Print", lazy.spawn(script_path+"screenshot.sh -s"),
        desc="Screenshoot of selection")
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        Key(
            [mod],
            i.name,
            lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name),
        ),
        Key(
            [mod, "shift"],
            i.name,
            lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name),
        )
    ])

layouts = [
    layout.Columns(
        border_focus=colors[6],
        border_normal=colors[0],
        border_focus_stack=[colors[9], colors[0]],
        border_width=2,
        margin=column_margin,
        margin_on_single=column_margin_on_single),
    layout.Max()
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()


def get_widget_list(font_size):
    widgets_list = [
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colors[2],
            background=colors[0]
        ),
        widget.GroupBox(
            font="JetBrainsMono Nerd Font Bold",
            fontsize=font_size,
            margin_y=3,
            margin_x=0,
            padding_y=5,
            padding_x=3,
            borderwidth=3,
            active=colors[4],
            inactive=colors[2],
            rounded=False,
            highlight_color=colors[1],
            highlight_method="text",
            this_current_screen_border=colors[6],
            this_screen_border=colors[4],
            other_current_screen_border=colors[6],
            other_screen_border=colors[4],
            foreground=colors[2],
            background=colors[0]
        ),
        widget.TextBox(
            text='|',
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            foreground='474747',
            padding=2,
        ),
        widget.CurrentLayout(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            foreground=colors[2],
            background=colors[0],
            padding=5
        ),
        widget.TextBox(
            text='|',
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            foreground='474747',
            padding=2,
        ),
        widget.WindowName(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            max_chars=30,
            format='{name}',
            foreground=colors[2],
            background=colors[0],
            padding=0
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colors[0],
            background=colors[0]
        ),
        widget.ThermalSensor(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            tag_sensor='Core 0',
            format='{tag} - {temp:.1f}',
            foreground=colors[4],
            background=colors[0],
            fmt='{}',
            padding=5
        ),
        widget.TextBox(
            text='|',
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            foreground='474747',
            padding=2,
        ),
        widget.ThermalSensor(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            tag_sensor='Core 1',
            format='{tag} - {temp:.1f}',
            foreground=colors[4],
            background=colors[0],
            fmt='{}',
            padding=5
        ),
        widget.TextBox(
            text='|',
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            foreground='474747',
            padding=2,
        ),
        widget.CPU(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            foreground=colors[7],
            background=colors[0],
            fmt='{}',
            padding=5
        ),
        widget.TextBox(
            text='|',
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            foreground='474747',
            padding=2,
        ),
        widget.Memory(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            foreground=colors[6],
            background=colors[0],
            fmt='{}',
            padding=5
        ),
        widget.TextBox(
            text='|\u2601',
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            foreground='474747',
            padding=2,
        ),
        widget.Net(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            interface="wlan0",
            format='{down} ↓↑ {up}',
            foreground=colors[10],
            background=colors[0],
            padding=5
        ),
        widget.TextBox(
            text='|\u26a1',
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            foreground='474747',
            padding=2,
        ),
        widget.Battery(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            charge_char='\u25b2',
            discharge_char='\u25bc',
            format='{char} {percent:2.0%} {watt:.2f} W',
            foreground=colors[5],
            background=colors[0],
            padding=5,
            update_interval=5
        ),
        widget.TextBox(
            text='|\U0001f50a',
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            foreground='474747',
            padding=2,
        ),
        widget.Volume(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            format='{}',
            foreground=colors[3],
            background=colors[0],
            padding=5
        ),
        widget.TextBox(
            text='|',
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            foreground='474747',
            padding=2,
        ),
        widget.Clock(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            foreground=colors[11],
            background=colors[0],
            format="\U0001f567 %A, %B %d - %H:%M:%S"
        ),
        widget.TextBox(
            text='|',
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            foreground='474747',
            padding=2,
        ),
        widget.QuickExit(
            font="JetBrainsMono Nerd Font",
            fontsize=font_size,
            background=colors[0],
            default_text=' \u23fc ',
            countdown_format='[{}]'
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colors[2],
            background=colors[0]
        )
    ]
    return widgets_list


screens = [
    Screen(
        wallpaper='~/Pictures/cloud_castle_3840x2160.jpg',
        wallpaper_mode='fill',
        top=bar.Bar(get_widget_list(font_size_screen1), bar_heigth_screen1)),
    Screen(
        wallpaper='~/Pictures/cloud_castle_3840x2160.jpg',
        wallpaper_mode='fill',
        top=bar.Bar(get_widget_list(font_size_screen2), bar_heigth_screen2)
    )
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the WM class and name.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry")  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
# wmname = "LG3D"
wmname = "Qtile"
