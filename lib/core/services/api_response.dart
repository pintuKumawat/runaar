import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiMethods {
  // final String baseUrl = "https://superradical-earlean-grapier.ngrok-free.dev";
  final String baseUrl = dotenv.get("BASE_URL");

  Future<T> get<T>({
    required String endpoint,
    required T Function(dynamic responseData) onSuccess,
    Map<String, dynamic>? body,
  }) async {
    final Map<String, String>? queryParameters = body?.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    final Uri url = Uri.parse(
      '$baseUrl/$endpoint',
    ).replace(queryParameters: queryParameters);

    try {
      final response = await http
          .get(url, headers: {"Content-Type": "application/json"})
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response, onSuccess);
    } on SocketException catch (_) {
      throw ApiException("No internet connection or server unreachable.");
    } on TimeoutException catch (_) {
      throw ApiException("Request timed out. Server may be down.");
    } catch (e) {
      debugPrint("API ERROR: $e");

      throw ApiException("Something went wrong. Please try again later.");
    }
  }

  Future<T> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(dynamic responseData) onSuccess,
  }) async {
    final Uri url = Uri.parse('$baseUrl/$endpoint');

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response, onSuccess);
    } on SocketException catch (_) {
      throw ApiException("No internet connection or server unreachable.");
    } on TimeoutException catch (_) {
      throw ApiException("Request timed out. Server may be down.");
    } catch (e) {
      debugPrint("API ERROR: $e");

      throw ApiException("Something went wrong. Please try again later.");
    }
  }

  Future<T> postMultipart<T>({
    required String endpoint,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? files,
    Map<String, String>? headers,
    required T Function(dynamic responseData) onSuccess,
  }) async {
    final Uri url = Uri.parse('$baseUrl/$endpoint');
    final request = http.MultipartRequest('POST', url);

    if (headers != null && headers.isNotEmpty) {
      request.headers.addAll(headers);
    }

    void addField(String key, dynamic value) {
      if (value == null) return;
      if (value is Iterable) {
        final base = key.endsWith('[]')
            ? key.substring(0, key.length - 2)
            : key;
        var i = 0;
        for (final item in value) {
          request.fields['$base[$i]'] = item.toString();
          i++;
        }
      } else {
        request.fields[key] = value.toString();
      }
    }

    fields?.forEach(addField);

    Future<void> addBytes(
      String field,
      Uint8List bytes, {
      String? filename,
    }) async {
      request.files.add(
        http.MultipartFile.fromBytes(
          field,
          bytes,
          filename: filename ?? 'upload.png',
          contentType: MediaType('image', 'png'),
        ),
      );
    }

    Future<void> addFile(String field, File file, {String? filename}) async {
      request.files.add(
        await http.MultipartFile.fromPath(
          field,
          file.path,
          filename: filename,
          contentType: MediaType('image', 'png'),
        ),
      );
    }

    Future<void> addAny(String field, dynamic value) async {
      if (value == null) return;

      // SPECIAL CASE — FULL IMAGE MUST BE SINGLE
      if (field == "fullImage") {
        if (value is Uint8List) {
          await addBytes(field, value, filename: 'full_image.png');
          return;
        } else if (value is File) {
          await addFile(field, value, filename: 'full_image.png');
          return;
        } else {
          throw ApiException("fullImage must be a single file");
        }
      }

      // OTHER FILES (images[] CAN be multiple)
      if (value is Uint8List) {
        await addBytes(field, value, filename: 'image.png');
      } else if (value is File) {
        await addFile(field, value, filename: 'image.png');
      } else if (value is Iterable) {
        int i = 0;
        for (final v in value) {
          if (v is Uint8List) {
            await addBytes(field, v, filename: 'user_image_$i.png');
          } else if (v is File) {
            await addFile(field, v, filename: 'user_image_$i.png');
          }
          i++;
        }
      }
    }

    if (files != null) {
      for (final entry in files.entries) {
        await addAny(entry.key, entry.value);
      }
    }
    try {
      final streamed = await request.send().timeout(
        const Duration(seconds: 20),
      );
      final response = await http.Response.fromStream(streamed);
      return _handleResponse(response, onSuccess);
    } on SocketException catch (_) {
      throw ApiException("No internet connection or server unreachable.");
    } on TimeoutException catch (_) {
      throw ApiException("Request timed out. Server may be down.");
    } catch (e) {
      debugPrint("API ERROR: $e");

      throw ApiException("Something went wrong. Please try again later.");
    }
  }

  static T _handleResponse<T>(
    http.Response response,
    T Function(dynamic responseData) onSuccess,
  ) {
    final contentType = response.headers['content-type'] ?? '';
    final isJsonResponse = contentType.contains('application/json');

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (isJsonResponse) {
        final responseData = json.decode(response.body);
        return onSuccess(responseData);
      } else {
        throw ApiException("Something Went Wrong, Please Try Again Later");
      }
    } else {
      String errorMessage;
      if (isJsonResponse) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        debugPrint(errorData.toString());
        errorMessage =
            errorData['message'] ??
            errorData['error'] ??
            "An unknown error occurred.";
      } else {
        errorMessage = "An unknown error occurred.";
      }
      debugPrint("⚠ RAW RESPONSE:");
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      debugPrint(response.headers.toString());

      throw ApiException(errorMessage);
    }
  }
}

final ApiMethods apiMethods = ApiMethods();
