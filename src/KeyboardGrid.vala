/*
 * Copyright (c) 2017 elementary LLC. (https://elementary.io)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA  02110-1301, USA.
 * 
 * 
 */

public class Keyboard.KeyboardGrid : Gtk.Grid {
    private Caribou.Scanner scanner;
    private Gtk.Stack stack;
    public KeyboardGrid () {
        
    }

    construct {
        stack = new Gtk.Stack ();
        add (stack);
        scanner = new Caribou.Scanner ();
        var model = new TouchModel ("/usr/share/caribou/layouts/touch/fr.xml");
        scanner.set_keyboard (model);
        foreach (var group_name in model.get_groups ()) {
            var group = model.get_group (group_name);
            foreach (var level_name in group.get_levels ()) {
                var level = group.get_level (level_name);
                var grid = new LevelGrid (level);
                var scrolled = new Gtk.ScrolledWindow (null, null);
                scrolled.vscrollbar_policy = Gtk.PolicyType.NEVER;
                scrolled.add_with_viewport (grid);
                stack.add_named (scrolled, level_name);
            }

            stack.visible_child_name = group.active_level;
            group.notify["active-level"].connect (() => {
                stack.visible_child_name = group.active_level;
            });
        }
    }
}

public class Keyboard.TouchModel : Caribou.KeyboardModel {
    public TouchModel (string file) {
        Object (
            keyboard_type: "touch",
            keyboard_file: file
        );
    }
}
