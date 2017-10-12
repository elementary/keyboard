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

public class Keyboard.SuggestionWidget : Gtk.Grid {
    private Gspell.Checker checker;
    private bool applying_suggestion = false;
    public SuggestionWidget () {
        
    }

    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        valign = Gtk.Align.CENTER;
        column_spacing = 12;
        checker = new Gspell.Checker (null);
        var display_adapter = (LocalAdapter)Caribou.DisplayAdapter.get_default ();
        display_adapter.notify["current-word"].connect (() => {
            if (!applying_suggestion) {
                search_for_word (display_adapter.current_word);
            }
        });

        search_for_word ("");
    }

    private void search_for_word (string word) {
        get_children ().foreach ((child) => {
            child.destroy ();
        });

        if (word == "") {
            var no_suggestion_label = new Gtk.Label ("No suggestion");
            no_suggestion_label.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);
            no_suggestion_label.show ();
            add (no_suggestion_label);
            return;
        }

        var suggestions = checker.get_suggestions (word, word.length);
        switch (suggestions.length ()) {
            case 0:
                var word_widget = add_suggestion (word);
                word_widget.sensitive = false;
                break;
            case 1:
                var word_widget = add_suggestion (word);
                word_widget.sensitive = false;
                add_suggestion (suggestions.nth_data (0));
                break;
            default:
                add_suggestion (suggestions.nth_data (0));
                var word_widget = add_suggestion (word);
                word_widget.sensitive = false;
                add_suggestion (suggestions.nth_data (1));
                break;
        }
    }

    private Gtk.Button add_suggestion (string suggestion) {
        var button = new Gtk.Button.with_label (suggestion);
        button.clicked.connect (() => apply_suggestion (suggestion));
        button.show ();
        add (button);
        return button;
    }

    private void apply_suggestion (string suggestion) {
        var display_adapter = (LocalAdapter)Caribou.DisplayAdapter.get_default ();
        var word = display_adapter.current_word;
        applying_suggestion = true;
        for (int i = 0; i< word.char_count (); i++) {
            display_adapter.keyval_press (Gdk.Key.BackSpace);
            display_adapter.keyval_release (Gdk.Key.BackSpace);
        }

        for (int i = 0; i< suggestion.char_count (); i++) {
            var keyval = Gdk.unicode_to_keyval (suggestion.get_char (i));
            display_adapter.keyval_press (keyval);
            display_adapter.keyval_release (keyval);
        }

        applying_suggestion = false;

        display_adapter.keyval_press (Gdk.Key.space);
        display_adapter.keyval_release (Gdk.Key.space);
    }
}
