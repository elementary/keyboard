# On-Screen Keyboard

## Building, Testing, and Installation

You'll need the following dependencies:
* caribou
* libglib2.0-dev
* libgtk-3-dev
* libcaribou-dev
* libgspell-1-dev
* valac

Run `meson build` to configure the build environment and then change to the build directory and run `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`, then execute with `io.elementary.keyboard`

    sudo ninja install
    io.elementary.keyboard

You might need to use the caribou-gtk-module if the hook isn't available on your end

    my-gtk-app --gtk-module=caribou-gtk-module
