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

public class Keyboard.Application : Gtk.Application {
    CaribouInterface caribou_interface;
    public Application () {
        Object(
            application_id: "io.elementary.keyboard",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        if (get_active_window () == null) {
            Caribou.DisplayAdapter.set_default (new LocalAdapter ());
            caribou_interface = new CaribouInterface ();
        }
    }
}

public int main (string[] args) {
    var app = new Keyboard.Application ();
    return app.run (args);
}
