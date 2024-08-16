import 'package:flutter/material.dart';
import 'package:presensi_mobile/view/profile/profile_auth.dart';
import 'package:presensi_mobile/view/profile/profile_data.dart';

import '../../models/fetch_user_data.dart';

class Profile extends StatefulWidget {
  final int userId;
  const Profile({
    required this.userId,
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _userData = await fetchUserData(widget.userId);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_userData == null) {
      return const Center(
        child: Text('Failed to load user data'),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ProfileData(
            userImageURL: 'assets/profile.jpg',
            userName: _userData?['nama'] ?? 'No Name',
            userPosition: _userData?['position_id'] ?? 'No Name',
          ),
        ),
        const ProfileAuth(),
      ],
    );
  }
}
