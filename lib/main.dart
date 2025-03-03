import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/bottomNav/app_router.dart';

import 'common/app_theme.dart';
import 'features/bottomNav/route_observer.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  MyApp({super.key});
  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: themeNotifier.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerDelegate: appRouter.delegate(
        navigatorObservers: () => [AppRouterObserver()],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
      routeInformationProvider: appRouter.routeInfoProvider(),
    );
  }
}
