import 'package:flutter/material.dart';
import 'Pages/activites_screen.dart'; // Import your screen classes
import 'Pages/ajout_screen.dart';
import 'Pages/profil_screen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  // List of screens corresponding to each tab
  final List<Widget> _screens = [
    ActivitesScreen(),
    AjoutScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IMAD FLUTTER activities IA'),
      ),
      body: _screens[_currentIndex], // Switch body content based on the selected tab
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Activités',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Ajout',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
