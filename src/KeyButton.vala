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

public class Keyboard.KeyButton : Gtk.Button {
    public Caribou.KeyModel key_model { get; construct; }

    public KeyButton (Caribou.KeyModel key_model) {
        Object (key_model: key_model);
        height_request = 36;
    }

    construct {
        label = key_model.label;
        button_press_event.connect (() => {
            key_model.press ();
            return false;
        });

        button_release_event.connect (() => {
            key_model.release ();
            return false;
        });

        key_model.key_hold.connect (() => {
            if (key_model.show_subkeys) {
                show_popover ();
            }
        });
    }

    private void show_popover () {
        var popover = new Gtk.Popover (this);
        var popover_grid = new Gtk.Grid ();
        popover_grid.margin = 6;
        popover_grid.column_spacing = 6;
        foreach (var key in key_model.get_extended_keys ()) {
            var button = new KeyButton (key);
            popover_grid.add (button);
        }

        popover.add (popover_grid);
        popover.show_all ();
        popover.hide.connect (() => {
            popover.destroy ();
        });
    }
}
