import 'package:get_it/get_it.dart';

import 'auth.dart';

GetIt locator = GetIt.instance;

/// setup GetIt for the repository, model or provider class.
///
/// registerLazySingleton: Only the first time you call get<T>() this factory
/// function will be called to create a new instance. After that you will always
/// get the same instance returned.
///
/// registerFactory: each time you call get<T>() you will get a new instance returned.
void setupLocator() {
  locator.registerLazySingleton<AuthModel>(() => AuthModel());
}
