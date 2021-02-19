import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_ui/screen/pages/LoginScreen.dart';
import 'package:flutter_tiktok_ui/screen/pages/add_video_page.dart';
import 'package:flutter_tiktok_ui/screen/pages/discover_page.dart';
import 'package:flutter_tiktok_ui/screen/pages/home_page.dart';
import 'package:flutter_tiktok_ui/screen/pages/inbox_page.dart';
import 'package:flutter_tiktok_ui/screen/pages/me_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainScreen extends StatefulWidget {

  var video_list;
  static var list;
  MainScreen(vd){
    list=vd;
  }

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  int _cIndex = 0;

  List<Widget> _pages=[HomePage(),DiscoverPage(),InboxPage(),MePage()];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        return Scaffold(
          backgroundColor: Colors.black,
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            notchMargin: 4,
            child: BottomNavigationBar(
                  currentIndex: 0,
                  backgroundColor: Colors.white,
                  type: BottomNavigationBarType.fixed ,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home,color: Color.fromARGB(255, 0, 0, 0)),
                        title: new Text('Home',style: TextStyle(color: Colors.black))
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.explore,color: Color.fromARGB(255, 0, 0, 0)),
                        title: new Text('Explore',style: TextStyle(color: Colors.black))
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.power,color: Color.fromARGB(255, 0, 0, 0)),
                        title: new Text('')
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person,color: Color.fromARGB(255, 0, 0, 0)),
                        title: new Text('Profile',style: TextStyle(color: Colors.black))
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.menu,color: Color.fromARGB(255, 0, 0, 0)),
                        title: new Text('More',style: TextStyle(color: Colors.black))
                    )
                  ],
                  onTap: (index) {bottomTapped(index);},
                ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton:  Container(
            height: 65.0,
            width: 65.0,
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add,size: 45.0,color: Colors.white,),
              backgroundColor: Colors.deepOrange,
            ),
          ),
          // body: _pages[_pageController],
          body:  PageView(
            controller: pageController,
            onPageChanged: (index) {
              pageChanged(index);
            },
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomePage(),
              Container(color: Colors.red),
              Container(color: Colors.orange),
              Container(color: Colors.green),
              Container(color: Colors.black12)
            ],
          ),
        );
      },
    );
  }

  Widget _navBarItem({String title,IconData icon}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon),
        Text(title)
      ],
    );
  }


  void pageChanged(int index) {
    setState(() {
      _cIndex = index;
    });
  }


  void bottomTapped(int index) {
    if(index==3){
      _settingModalBottomSheet(context);
    }else{
      setState(() {
        _cIndex = index;
        pageController.jumpToPage(index);
      });
    }
  }

  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return LoginScreen();
        }
    );
  }

}
