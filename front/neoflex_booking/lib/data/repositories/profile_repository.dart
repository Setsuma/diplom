import 'dart:io';
import 'package:neoflex_booking/data/api/api_client.dart';
import 'package:neoflex_booking/domain/models/user_profile.dart';
import 'package:dio/dio.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<UserProfile> getProfile() async {
    final response = await _apiClient.get('/profile');
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserProfile> updateProfile({
    String? name,
    String? email,
    String? department,
    String? position,
  }) async {
    final data = <String, dynamic>{
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (department != null) 'department': department,
      if (position != null) 'position': position,
    };

    final response = await _apiClient.put('/profile', data: data);
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserProfile> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });

    final response = await _apiClient.post(
      '/profile/avatar',
      data: formData,
    );
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserProfile> deleteAvatar() async {
    final response = await _apiClient.delete('/profile/avatar');
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }
}
