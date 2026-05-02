using AppManager.Core;

int main(string[] args) {
    // Initialize translations before anything else
    i18n_init();

    // If DBUS_SESSION_BUS_ADDRESS names a unix socket that doesn't exist,
    // unset it so GLib.Application skips DBus registration gracefully instead
    // of failing. Happens on minimal desktops where the env var is set by a
    // display manager but no session bus is actually running.
    var dbus_addr = GLib.Environment.get_variable("DBUS_SESSION_BUS_ADDRESS");
    if (dbus_addr != null && dbus_addr.has_prefix("unix:path=")) {
        var socket_path = dbus_addr.substring("unix:path=".length);
        if (!GLib.FileUtils.test(socket_path, GLib.FileTest.EXISTS)) {
            GLib.Environment.unset_variable("DBUS_SESSION_BUS_ADDRESS");
        }
    }

    var app = new AppManager.Application();
    return app.run(args);
}
