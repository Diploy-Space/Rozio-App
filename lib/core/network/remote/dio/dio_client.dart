

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rozio_app/util/app_constants/app_constants.dart';
import 'package:rozio_app/util/helper/sharepreference_class.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'logging_interceptor.dart';


class DioClient{
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio? dio;
  String? token;
  String? countryCode;


  DioClient(this.baseUrl,Dio? dioC,{required this.loggingInterceptor,required this.sharedPreferences,}){

    dio = dioC ?? Dio();
    dio!
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(milliseconds: 20000)
      ..options.receiveTimeout = const Duration(milliseconds: 20000)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        // 'Accept-Language': 'en',
      };
    dio!.interceptors.add(loggingInterceptor);
    updateHeader();

  }

  Future<void> updateHeader() async {
    try {
    

      String? token = await SharedPreferencesClass.getValue(AppConstants.token);
      if (kDebugMode) {
        log('==========Current Token: $token');
      }
      

      if(token != null) {
        if(!token.startsWith('Bearer ')) {
          token = 'Bearer $token';
        }

        dio?.options.headers = {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': token,
        };
      } else {
        dio?.options.headers = {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        };
      }

      if (kDebugMode) {
        log("Updated Headers: ${dio?.options.headers}");
      }
    } catch(e) {
      if (kDebugMode) {
        log('Header update error: $e');
      }
      rethrow;
    }
  }


  Future<Response> get(String uri, {Map<String, dynamic>? queryParameters, Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,}) async {
    try {
      await updateHeader();
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }


  Future<Response> post(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (kDebugMode) {
        log("#DATA...$data");
      }
      await updateHeader();
      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }


  Future<Response> put(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await updateHeader();
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> patch(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (kDebugMode) {
        log("#DATA...$data");
      }
      await updateHeader();
      var response = await dio!.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }



  Future<Response> delete(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await updateHeader();
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }



  Future<Response> postMultipart(String uri, {
    Map<String, dynamic>? data,
    XFile? file,              // single file
    List<XFile?>? files,      // multiple files
    String fileKey = 'file',
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}');

    try {
      // Prepare formData
      FormData formData = FormData.fromMap(data ?? {});

      //  SINGLE FILE SUPPORT
      if (file != null) {
        formData.files.add(
          MapEntry(
            fileKey,
            MultipartFile.fromBytes(
              await file.readAsBytes(),
              filename: file.name,
            ),
          ),
        );
      }

      // 🔥 MULTIPLE FILE SUPPORT
      if (files != null && files.isNotEmpty) {
        for (var f in files) {
          formData.files.add(
            MapEntry(
              "$fileKey[]",
              MultipartFile.fromBytes(
                await f!.readAsBytes(),
                filename: f.name,
              ),
            ),
          );
        }
      }

      var response = await dio!.post(
        uri,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }


}