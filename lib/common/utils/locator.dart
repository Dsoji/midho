import 'package:get_it/get_it.dart';

import '../../features/bottomNav/app_router.dart';
import '../../features/bottomNav/route_observer.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  locator.registerSingleton<AppRouter>(AppRouter());
  locator.registerSingleton<AppRouterObserver>(AppRouterObserver());
  // locator.registerSingleton<AppLifecycleHandler>(AppLifecycleHandler());

  // WidgetsBinding.instance.addObserver(locator<AppLifecycleHandler>());
}

final appRouter = locator<AppRouter>();
final appRouterObserver = locator<AppRouterObserver>();
