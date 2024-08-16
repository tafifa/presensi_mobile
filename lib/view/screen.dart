import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:presensi_mobile/view/riwayat/riwayat.dart';
import 'package:presensi_mobile/view/presensi/presensi.dart';
import 'package:presensi_mobile/view/profile/profile.dart';

import '../models/fetch_user_data.dart';

class Screen extends StatefulWidget {
  final int userId;
  const Screen({
    required this.userId,
    super.key,
  });

  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  late List<Widget> _screens;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  int _selectedIndex = 1;

  Future<void> _fetchUserData() async {
    _userData = await fetchUserData(widget.userId);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _screens = <Widget>[
      Riwayat(
        userId: widget.userId,
      ),
      Presensi(
        userId: widget.userId,
      ),
      Profile(
        userId: widget.userId,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userName = _userData?['nama'] ?? 'No Name';

    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_userData == null) {
      return const Center(
        child: Text('Failed to load user data'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Halo, $userName 👋',
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Pusat Bantuan'),
                      content: const Text('\nChat Admin jika mengalami kendala\n(Tafif - wa.me/6281945033812)'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2,
                      color: (Colors.blue[900]!)
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FaIcon(
                    FontAwesomeIcons.headset,
                    size: 20,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ),

          ),
        ],
      ),
      // body: _screens[_selectedIndex],
      body: SingleChildScrollView(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.clockRotateLeft),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.fingerprint),
              label: 'Presensi',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidUser),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[900], // Set color for selected icon
          unselectedItemColor: Colors.blue, // Set color for unselected icons
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
