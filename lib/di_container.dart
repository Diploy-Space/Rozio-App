import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:rozio_app/util/app_constants/app_constants.dart';
import 'package:rozio_app/util/helper/sharepreference_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/remote/dio/dio_client.dart';
import 'core/network/remote/dio/logging_interceptor.dart';


final sl = GetIt.instance;

Future<void> init() async {
  /// ---------------- CORE ----------------
  sl.registerLazySingleton(
    () => DioClient(
      AppConstants.baseUrl,
      sl(),
      loggingInterceptor: sl(),
      sharedPreferences: sl(),
    ),
  );

  /// ---------------- REPOSITORIES ----------------
  // sl.registerLazySingleton(
  //   () => SignInRepo(dioClient: sl(), sharedPreferencesClass: sl()),
  // );
  // sl.registerLazySingleton(
  //   () => SignUpRepo(dioClient: sl(), sharedPreferencesClass: sl()),
  // );
  // sl.registerLazySingleton(
  //   () => LogOutRepo(dioClient: sl(), sharedPreferencesClass: sl()),
  // );

  // sl.registerLazySingleton(
  //   () => HomeRepo(dioClient: sl(), sharedPreferencesClass: sl()),
  // );

  // sl.registerLazySingleton(
  //   () => AdsRepo(dioClient: sl()),
  // );

  // sl.registerLazySingleton(() => SignUpOtpRepo(dioClient: sl()));


  



  // /// ---------------- CONTROLLERS (GETX) ----------------



  // Get.lazyPut(
  //   () => SignInController(
  //     dioClient: sl(),
  //     signInRepo: sl(),
  //     sharedPreferencesClass: sl(),
  //   ),
  //   fenix: true,
  // );



 

  // Get.lazyPut(() => HomeController(homeRepo: sl()), fenix: true);


  

  /// ---------------- EXTERNAL ----------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => SharedPreferencesClass());
}
