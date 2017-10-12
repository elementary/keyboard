configuration_data = configuration_data()
configuration_data.set('EXEC_NAME', join_paths(get_option('prefix'), get_option('bindir'), meson.project_name()))

config_file = configure_file(
    input: 'io.elementary.Keyboard.service.in',
    output: 'io.elementary.Keyboard.service',
    configuration: configuration_data,
    install_dir: join_paths(get_option('datadir'), 'dbus-1', 'services')
)
