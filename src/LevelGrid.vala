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

public class Keyboard.LevelGrid : Gtk.Grid {
    public LevelGrid (Caribou.LevelModel level) {
        margin = 6;
        orientation = Gtk.Orientation.VERTICAL;
        row_spacing = 6;
        foreach (var row in level.get_rows ()) {
            foreach (var column in row.get_columns ()) {
                var row_grid = new Gtk.Grid ();
                row_grid.column_spacing = 6;
                row_grid.hexpand = true;
                row_grid.column_homogeneous = true;
                row_grid.orientation = Gtk.Orientation.HORIZONTAL;
                add (row_grid);

                foreach (var child in column.get_scan_children ()) {
                    var button = new Keyboard.KeyButton ((Caribou.KeyModel)child);
                    row_grid.add (button);
                }
            }
        }
    }

    construct {
        
    }
}
