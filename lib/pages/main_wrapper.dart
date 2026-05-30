import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'kendaraan_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainWrapper extends StatelessWidget {
  final RxInt _currentIndex = 0.obs;
  final List<Widget> _screens = [HomePage(), KendaraanPage(), ProfilePage()];

  MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: _currentIndex.value, children: _screens),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _currentIndex.value,
          onTap: (index) => _currentIndex.value = index,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          // KATA KUNCI 'const' DI SINI SUDAH DIHAPUS
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.build),
              label: 'Kendaraan',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
