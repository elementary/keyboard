project('io.elementary.keyboard', 'c', 'vala')

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], 
                      language: 'vala')

gnome = import('gnome')

glib_dep = dependency('glib-2.0')
gio_dep = dependency('gio-2.0')
gobject_dep = dependency('gobject-2.0')
caribou_dep = dependency('caribou-1.0')
gtk_dep = dependency('gtk+-3.0')
gspell_dep = dependency('gspell-1')

dependencies = [
    glib_dep,
    gio_dep,
    gobject_dep,
    caribou_dep,
    gtk_dep,
    gspell_dep
]

subdir('src')
subdir('data')
