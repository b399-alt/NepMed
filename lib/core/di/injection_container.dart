import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

import '../../features/medicine/data/datasources/medicine_local_datasource.dart';
import '../../features/medicine/data/models/medicine_model.dart';
import '../../features/medicine/data/repositories/medicine_repository_impl.dart';
import '../../features/medicine/domain/repositories/medicine_repository.dart';
import '../../features/medicine/domain/usecases/add_medicine_usecase.dart';
import '../../features/medicine/domain/usecases/delete_medicine_usecase.dart';
import '../../features/medicine/domain/usecases/get_medicine_by_id_usecase.dart';
import '../../features/medicine/domain/usecases/get_medicines_usecase.dart';
import '../../features/medicine/domain/usecases/search_medicines_usecase.dart';
import '../../features/medicine/domain/usecases/update_medicine_usecase.dart';
import '../../features/medicine/presentation/providers/medicine_provider.dart';

import '../../features/subscription/data/datasources/subscription_local_datasource.dart';
import '../../features/subscription/data/models/subscription_model.dart';
import '../../features/subscription/data/repositories/subscription_repository_impl.dart';
import '../../features/subscription/domain/repositories/subscription_repository.dart';
import '../../features/subscription/domain/usecases/cancel_subscription_usecase.dart';
import '../../features/subscription/domain/usecases/create_subscription_usecase.dart';
import '../../features/subscription/domain/usecases/get_subscriptions_usecase.dart';
import '../../features/subscription/domain/usecases/update_subscription_usecase.dart';
import '../../features/subscription/presentation/providers/subscription_provider.dart';

import '../../features/cart/presentation/providers/cart_provider.dart';

import '../../features/image/data/datasources/image_local_datasource.dart';
import '../../features/image/data/datasources/image_remote_datasource.dart';
import '../../features/image/data/repositories/image_repository_impl.dart';
import '../../features/image/domain/repositories/image_repository.dart';
import '../../features/image/domain/usecases/delete_image_usecase.dart';
import '../../features/image/domain/usecases/get_image_by_id_usecase.dart';
import '../../features/image/domain/usecases/get_images_usecase.dart';
import '../../features/image/domain/usecases/upload_image_usecase.dart';
import '../../features/image/presentation/providers/image_provider.dart';

import '../constants/hive_constants.dart';
import '../network/api_config.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await Hive.initFlutter();

  // Register Hive Adapters
  if (!Hive.isAdapterRegistered(HiveConstants.userTypeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveConstants.medicineTypeId)) {
    Hive.registerAdapter(MedicineModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveConstants.subscriptionTypeId)) {
    Hive.registerAdapter(SubscriptionModelAdapter());
  }

  // Open Hive Boxes
  final userBox = await Hive.openBox<UserModel>(HiveConstants.userBox);
  final authBox = await Hive.openBox<bool>(HiveConstants.authBox);
  final medicineBox = await Hive.openBox<MedicineModel>(HiveConstants.medicineBox);
  final subscriptionBox = await Hive.openBox<SubscriptionModel>(HiveConstants.subscriptionBox);

  // Register Boxes
  sl.registerLazySingleton<Box<UserModel>>(() => userBox);
  sl.registerLazySingleton<Box<bool>>(() => authBox);
  sl.registerLazySingleton<Box<MedicineModel>>(() => medicineBox);
  sl.registerLazySingleton<Box<SubscriptionModel>>(() => subscriptionBox);

  // ==================== Auth ====================
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(userBox: sl<Box<UserModel>>(), authBox: sl<Box<bool>>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerFactory(() => AuthProvider(
    loginUseCase: sl(), registerUseCase: sl(), logoutUseCase: sl(),
    getCurrentUserUseCase: sl(), checkAuthStatusUseCase: sl(),
  ));

  // ==================== Medicine ====================
  sl.registerLazySingleton<MedicineLocalDataSource>(
    () => MedicineLocalDataSourceImpl(medicineBox: sl<Box<MedicineModel>>()),
  );
  sl.registerLazySingleton<MedicineRepository>(
    () => MedicineRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetMedicinesUseCase(sl()));
  sl.registerLazySingleton(() => GetMedicineByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddMedicineUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMedicineUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMedicineUseCase(sl()));
  sl.registerLazySingleton(() => SearchMedicinesUseCase(sl()));
  sl.registerFactory(() => MedicineProvider(
    getMedicinesUseCase: sl(), addMedicineUseCase: sl(),
    updateMedicineUseCase: sl(), deleteMedicineUseCase: sl(),
    searchMedicinesUseCase: sl(),
  ));

  // ==================== Subscription ====================
  sl.registerLazySingleton<SubscriptionLocalDataSource>(
    () => SubscriptionLocalDataSourceImpl(subscriptionBox: sl<Box<SubscriptionModel>>()),
  );
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetSubscriptionsUseCase(sl()));
  sl.registerLazySingleton(() => CreateSubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => CancelSubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => PauseSubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => ResumeSubscriptionUseCase(sl()));
  sl.registerFactory(() => SubscriptionProvider(
    getSubscriptionsUseCase: sl(), createSubscriptionUseCase: sl(),
    updateSubscriptionUseCase: sl(), cancelSubscriptionUseCase: sl(),
    pauseSubscriptionUseCase: sl(), resumeSubscriptionUseCase: sl(),
  ));

  // ==================== Cart (singleton - shared state) ====================
  sl.registerLazySingleton(() => CartProvider());

  // ==================== Image ====================
  sl.registerLazySingleton<Dio>(() {
    return Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
  });
  sl.registerLazySingleton<ImageRemoteDataSource>(
    () => ImageRemoteDataSourceImpl(dio: sl(), baseUrl: ApiConfig.baseUrl),
  );
  sl.registerLazySingleton<ImageLocalDataSource>(
    () => ImageLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton(() => UploadImageUseCase(sl()));
  sl.registerLazySingleton(() => GetImagesUseCase(sl()));
  sl.registerLazySingleton(() => GetImageByIdUseCase(sl()));
  sl.registerLazySingleton(() => DeleteImageUseCase(sl()));
  sl.registerFactory(() => ImageStateProvider(
    uploadImageUseCase: sl(), getImagesUseCase: sl(),
    getImageByIdUseCase: sl(), deleteImageUseCase: sl(),
  ));
}
