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

public class LocalAdapter : Caribou.XAdapter {
    public string current_word { get; private set; default = ""; }

    public override void register_button_func (uint button, Caribou.KeyButtonCallback? func) {
        warning ("%u", button);
        base.register_button_func (button, func);
    }

    public override void register_key_func (uint keyval, Caribou.KeyButtonCallback? func) {
        warning ("%u", Gdk.keyval_to_unicode (keyval));
        base.register_key_func (keyval, func);
    }

    public override void keyval_press (uint keyval) {
        // FIXME: We need to get the string directly from the input target, this is a dirty hack
        if (keyval == Gdk.Key.space) {
            current_word = "";
        } else if (keyval == Gdk.Key.BackSpace) {
            if (current_word != "") {
                int end = current_word.index_of_nth_char (current_word.char_count () - 1);
                current_word = current_word.slice (0, end);
            }
        } else {
            current_word = "%s%c".printf (current_word, (char)Gdk.keyval_to_unicode (keyval));
        }

        base.keyval_press (keyval);
    }

    public override void keyval_release (uint keyval) {
        warning ("%u", Gdk.keyval_to_unicode (keyval));
        base.keyval_release (keyval);
    }
}
