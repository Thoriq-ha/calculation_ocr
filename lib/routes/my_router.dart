import 'package:calculation_ocr/core/widgets/flavor_banner.dart';
import 'package:calculation_ocr/features/calculation/presentation/pages/camera_page.dart';
import 'package:calculation_ocr/features/calculation/presentation/pages/file_storage_page.dart';
import 'package:calculation_ocr/features/calculation/presentation/pages/menu_page.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class MyRouter {
  get router => GoRouter(
        initialLocation: "/",
        routes: [
          GoRoute(
            path: "/",
            name: "menu",
            pageBuilder: (context, state) => NoTransitionPage(
                child: flavorBanner(
              child: const MenuPage(),
              show: kDebugMode,
            )),
            // sub routes
            routes: [
              GoRoute(
                path: "camera",
                name: "camera",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CameraPage(),
                ),
              ),
              GoRoute(
                path: "file_storage",
                name: "file_storage",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: FileStoragePage(),
                ),
              ),
            ],
          ),
        ],
      );
}
