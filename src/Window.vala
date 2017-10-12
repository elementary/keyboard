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

public class Keyboard.Window : Gtk.Window {
    private int monitor_number;
    private int monitor_width;
    private int monitor_height;
    private int monitor_x;
    private int monitor_y;
    private int panel_displacement = 0;

    public Window () {
        Object (
            application: (Gtk.Application)GLib.Application.get_default (),
            gravity: Gdk.Gravity.SOUTH_WEST,
            type_hint: Gdk.WindowTypeHint.DOCK,
            skip_pager_hint: true,
            skip_taskbar_hint: true,
            vexpand: false,
            decorated: false,
            resizable: false
        );
    }

    construct {
        var grid = new Gtk.Grid ();
        grid.orientation = Gtk.Orientation.VERTICAL;

        var hide_action = new Gtk.Button.from_icon_name ("window-minimize-symbolic", Gtk.IconSize.BUTTON);
        hide_action.get_style_context ().remove_class (Gtk.STYLE_CLASS_BUTTON);
        hide_action.get_style_context ().add_class ("titlebutton");
        hide_action.get_style_context ().add_class ("minimize");

        var action_bar = new Gtk.ActionBar ();
        action_bar.get_style_context ().add_class ("titlebar");
        action_bar.add (hide_action);

        var suggestion_widget = new SuggestionWidget ();
        action_bar.set_center_widget (suggestion_widget);

        grid.add (action_bar);
        grid.add (new KeyboardGrid ());
        add (grid);

        screen.size_changed.connect (update_panel_dimensions);
        screen.monitors_changed.connect (update_panel_dimensions);
        realize.connect (() => {
            update_panel_dimensions ();
        });
        hide_action.clicked.connect (() => hide ());
    }

    private void update_panel_dimensions () {
        var panel_height = get_allocated_height ();

        monitor_number = screen.get_primary_monitor ();
        Gdk.Rectangle monitor_dimensions;
        screen.get_monitor_geometry (monitor_number, out monitor_dimensions);

        monitor_width = monitor_dimensions.width;
        monitor_height = monitor_dimensions.height;

        width_request = monitor_width;
        var geometry_hints = Gdk.Geometry ();
        geometry_hints.max_width = width_request;
        geometry_hints.max_height = -1;
        set_geometry_hints (null, geometry_hints, Gdk.WindowHints.MAX_SIZE);
        resize (width_request, panel_height);

        monitor_x = monitor_dimensions.x;
        monitor_y = monitor_dimensions.y;

        move (monitor_x, monitor_height - panel_height + panel_displacement);

        update_struts ();
    }

    private void update_struts () {
        if (!this.get_realized ()) {
            return;
        }

        var monitor = monitor_number == -1 ? this.screen.get_primary_monitor () : monitor_number;

        var position_top = monitor_y - panel_displacement;

        Gdk.Atom atom;
        Gdk.Rectangle primary_monitor_rect;

        long struts[12];

        this.screen.get_monitor_geometry (monitor, out primary_monitor_rect);
        position_top -= primary_monitor_rect.height + get_allocated_height ();

        // We need to manually include the scale factor here as GTK gives us unscaled sizes for widgets
        struts = { 0, 0, position_top * this.get_scale_factor () , 0, /* strut-left, strut-right, strut-top, strut-bottom */
                   0, 0, /* strut-left-start-y, strut-left-end-y */
                   0, 0, /* strut-right-start-y, strut-right-end-y */
                   monitor_x, monitor_x + monitor_width - 1, /* strut-top-start-x, strut-top-end-x */
                   0, 0 }; /* strut-bottom-start-x, strut-bottom-end-x */

        atom = Gdk.Atom.intern ("_NET_WM_STRUT_PARTIAL", false);

        Gdk.property_change (this.get_window (), atom, Gdk.Atom.intern ("CARDINAL", false),
                             32, Gdk.PropMode.REPLACE, (uint8[])struts, 12);
    }
}
