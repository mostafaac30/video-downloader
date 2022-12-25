import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

GetIt locator = GetIt.instance;

Future baseDio() async {
  final options = BaseOptions(
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );

  var dio = Dio(options);

  dio.interceptors.add(
    PrettyDioLogger(),
  );

  locator.registerSingleton<Dio>(dio);
}
