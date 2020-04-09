import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

//Screens
import 'screens/coupons_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/order_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Montserrat',
      ),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new MyHome(title: 'amifood')
      },
      title: 'Amifood',
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHome extends StatefulWidget {
  MyHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int selectedIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget _buildPageView() {
    return PageView(
      physics: new NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        DashboardScreen(),
        CouponsScreen(),
        OrderScreen(),
        ProfileScreen()
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void bottomTapped(int index) {
    setState(() {
      selectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: _buildPageView(),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: Colors.grey[100],
          animationCurve: Curves.easeInOutCirc,
          items: <Widget>[
            Icon(Icons.dashboard, size: 30, color: Colors.black87),
            Icon(Icons.card_giftcard, size: 30, color: Colors.black87),
            Icon(Icons.shopping_cart, size: 30, color: Colors.black87),
            Icon(Icons.person, size: 30, color: Colors.black87),
          ],
          onTap: (index) {
            setState(() {
              selectedIndex = index;
              bottomTapped(index);
            });
          },
        ));
  }
}
