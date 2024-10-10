enum Flavor {
  app_red_camera_roll,
  app_red_filesystem,
  app_green_filesystem,
  app_green_camera_roll,
}

enum FlavorTheme {
  red,
  green,
}

enum UIFunctionality {
  filesystem,
  camera,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.app_red_camera_roll:
        return 'App Red Camera Roll';
      case Flavor.app_red_filesystem:
        return 'App Red Filesystem';
      case Flavor.app_green_filesystem:
        return 'App Green Filesystem';
      case Flavor.app_green_camera_roll:
        return 'App Green Camera Roll';
      default:
        return 'title';
    }
  }

  static FlavorTheme get theme {
    switch (appFlavor) {
      case Flavor.app_red_camera_roll:
        return FlavorTheme.red;
      case Flavor.app_red_filesystem:
        return FlavorTheme.red;
      case Flavor.app_green_filesystem:
        return FlavorTheme.green;
      case Flavor.app_green_camera_roll:
        return FlavorTheme.green;
      default:
        return FlavorTheme.green;
    }
  }

  static UIFunctionality get uIFunctionality {
    switch (appFlavor) {
      case Flavor.app_red_camera_roll:
        return UIFunctionality.camera;
      case Flavor.app_red_filesystem:
        return UIFunctionality.filesystem;
      case Flavor.app_green_filesystem:
        return UIFunctionality.filesystem;
      case Flavor.app_green_camera_roll:
        return UIFunctionality.camera;
      default:
        return UIFunctionality.camera;
    }
  }
}
