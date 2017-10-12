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

public class Keyboard.CaribouInterface : Caribou.KeyboardService {
    private Window window;
    construct {
        window = new Keyboard.Window ();
        register_keyboard ("elementary");
    }

    public override void show (uint32 timestamp) {
        window.show_all ();
    }

    public override void hide (uint32 timestamp) {
        window.hide ();
    }

    public override void set_cursor_location (int x, int y, int w, int h) {
        
    }

    public override void set_entry_location (int x, int y, int w, int h) {
        
    }

    protected override void name_lost (string name) {
        Gtk.main_quit ();
    }
}
