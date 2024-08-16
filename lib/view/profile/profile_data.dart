import 'package:flutter/material.dart';

class ProfileData extends StatelessWidget {
  final String userImageURL;
  final String userName;
  final int userPosition;
  const ProfileData({
    required this.userImageURL,
    required this.userName,
    required this.userPosition,
    super.key,
  });

  String _getPositionName(int positionId) {
    switch (positionId) {
      case 1:
        return 'Barista';
      case 2:
        return 'Kasir';
      case 3:
        return 'Dishwasher';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue, // Warna border
                width: 4.0, // Lebar border
              ),
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CircleAvatar(
              radius: 120,
              backgroundImage: AssetImage(userImageURL),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
          child: Column(
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  color: Colors.blueAccent,
                ),
              ),
              Text(
                _getPositionName(userPosition),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
