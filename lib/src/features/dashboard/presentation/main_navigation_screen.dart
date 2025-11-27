import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../social_rivals/presentation/rivals_screen.dart';
import 'home_screen.dart';
import '../../technique_library/presentation/technique_library_screen.dart';
import '../../tutorial/presentation/tutorial_keys.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  final PageController? externalPageController;
  final GlobalKey? socialTabKey;
  final GlobalKey? socialTabActiveKey;
  final GlobalKey? techniquesTabKey;
  final GlobalKey? techniquesTabActiveKey;
  final GlobalKey? missionsKey;
  final GlobalKey? classesKey;
  final GlobalKey? profileKey;
  final GlobalKey? addTrainingFabKey;
  
  const MainNavigationScreen({
    super.key,
    this.externalPageController,
    this.socialTabKey,
    this.socialTabActiveKey,
    this.techniquesTabKey,
    this.techniquesTabActiveKey,
    this.missionsKey,
    this.classesKey,
    this.profileKey,
    this.addTrainingFabKey,
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
    
    // Listen to page changes to update bottom nav
    _pageController.addListener(_handlePageChange);
  }

  void _handlePageChange() {
    if (_pageController.hasClients && _pageController.page != null) {
      final page = _pageController.page!.round();
      if (page != _currentIndex) {
        setState(() {
          _currentIndex = page;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
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
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          const RivalsScreen(),
          HomeScreen(
            missionsKey: widget.missionsKey,
            classesKey: widget.classesKey,
            profileKey: widget.profileKey,
          ),
          TechniqueLibraryScreen(
            addTrainingFabKey: widget.addTrainingFabKey,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1565C0),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.people, key: widget.socialTabKey),
              activeIcon: Icon(Icons.people, key: widget.socialTabActiveKey),
              label: 'Social',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Principal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books, key: widget.techniquesTabKey),
              activeIcon: Icon(Icons.library_books, key: widget.techniquesTabActiveKey),
              label: 'Técnicas',
            ),
          ],
        ),
      ),
    );
  }
}
