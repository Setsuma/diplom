import 'package:flutter/material.dart';
import '../../domain/models/user_profile.dart';
import '../widgets/user_profile_widget.dart';
import '../widgets/user_bookings_list.dart';
import '../dialogs/edit_profile_dialog.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileRepository = ProfileRepository();
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final profile = await _profileRepository.getProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при загрузке профиля: $e'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleEditProfile() async {
    if (_userProfile == null) return;

    final updatedProfile = await showDialog<UserProfile>(
      context: context,
      builder: (context) => EditProfileDialog(user: _userProfile!),
    );

    if (updatedProfile != null && mounted) {
      try {
        final savedProfile = await _profileRepository.updateProfile(
          name: updatedProfile.name,
          email: updatedProfile.email,
          department: updatedProfile.department,
          position: updatedProfile.position,
        );

        setState(() {
          _userProfile = savedProfile;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Профиль успешно обновлен'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка при обновлении профиля: $e'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _userProfile == null
              ? const Center(
                  child: Text('Профиль не найден'),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserProfileWidget(
                        user: _userProfile!,
                        onEditPressed: _handleEditProfile,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Мои бронирования',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      UserBookingsList(userId: _userProfile!.id),
                    ],
                  ),
                ),
    );
  }
}
