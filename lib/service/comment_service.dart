import 'dart:convert';

import 'package:flutter_blog_app/constant.dart';
import 'package:flutter_blog_app/model/api_response.dart';
import 'package:flutter_blog_app/model/comment.dart';
import 'package:flutter_blog_app/service/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getComments(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$postsURL/$postId/comments'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        final List<dynamic> commentsJson = jsonDecode(response.body)['comments'];
        apiResponse.data = commentsJson.map((p) => Comment.fromJson(p)).toList();
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError + e.toString();
  }
  return apiResponse;
}

Future<ApiResponse> createComments(int postId, String? comment) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse('$postsURL/$postId/comments'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {'comment': comment},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError + e.toString();
  }
  return apiResponse;
}

Future<ApiResponse> editComments(int commentId, String? comment) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse('$commentsURL/$commentId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {'comment': comment},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError + e.toString();
  }
  return apiResponse;
}

Future<ApiResponse> deleteComments(int commentId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('$commentsURL/$commentId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError + e.toString();
  }
  return apiResponse;
}
