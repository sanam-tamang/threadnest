import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:threadnest/features/chat/pages/chat_room_page.dart';
import 'package:threadnest/features/community/pages/community_page.dart';
import 'package:threadnest/features/home/pages/home.dart';
import 'package:threadnest/features/profile/pages/user_profile.dart';
import 'package:threadnest/router.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  late PageController _pageController;

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CommunityPage(),
    Container(),
    const ChatRoomPage(),
    const UserProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        // index:  _selectedIndex,
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ModernNavigationBar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              _pageController.jumpToPage(index);
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

class ModernNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const ModernNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, LineIcons.home, 'Home'),
          _buildNavItem(1, LineIcons.users, 'Communities'),
          _buildCreateButton(context),
          _buildNavItem(3, LineIcons.facebookMessenger, 'Message'),
          _buildNavItem(4, LineIcons.user, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onItemSelected(index),
      child: Container(
        width: 56,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Container(
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.black : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(AppRouteName.questionAskingPage),
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            LineIcons.plus,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
