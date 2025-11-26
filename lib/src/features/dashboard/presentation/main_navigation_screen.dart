import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../social_rivals/presentation/rivals_screen.dart';
import 'home_screen.dart';
import '../../technique_library/presentation/technique_library_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  final PageController? externalPageController;
  
  const MainNavigationScreen({
    super.key,
    this.externalPageController,
  });

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  late final PageController _pageController;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    // Use external controller if provided, otherwise create internal one
    _pageController = widget.externalPageController ?? PageController(initialPage: 1);
  }

  @override
  void dispose() {
    // Only dispose if we created the controller internally
    if (widget.externalPageController == null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          RivalsScreen(),
          HomeScreen(),
          TechniqueLibraryScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1565C0),
          unselectedItemColor: Colors.grey[600],
          selectedFontSize: 11,
          unselectedFontSize: 10,
          iconSize: 22,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Social',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Principal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Técnicas',
            ),
          ],
        ),
      ),
    );
  }
}
