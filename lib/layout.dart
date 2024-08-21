import 'package:aanchal_ai/global_vars.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  late PageController pageController;
  int _page=0;

  @override
  void initState(){
    super.initState();
    pageController=PageController();
  }

  @override
  void dispose(){
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: Items,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          elevation: 6,
          shadowColor: Colors.black,
          backgroundColor: Color.fromARGB(255, 119, 157, 169),
          indicatorColor: Color.fromARGB(255, 119, 157, 169),
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white
              )
            )
        ),
        child: NavigationBar(
          height: 80,
          destinations: [
            NavigationDestination(
                icon: Icon(
                  _page==0?Icons.home_filled:Icons.home_outlined,
                  color: Colors.white,
                ),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(
                  _page==1?Icons.folder_sharp:Icons.folder_open_outlined,
                  color: Colors.white,
                ),
                label: "Files",
              ),
          ],
          onDestinationSelected: navigationTapped,
        ),
      ),
    );
  }
}