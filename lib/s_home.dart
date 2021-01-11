import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/controllers/c_etiquetas.dart';
import 'package:scheduleapp/controllers/c_home.dart';
import 'package:scheduleapp/controllers/c_rutina.dart';
import 'package:scheduleapp/screens/agenda/s_agenda.dart';
import 'package:scheduleapp/screens/etiquetas/s_etiquetas.dart';
import 'package:scheduleapp/screens/rutina/s_rutina.dart';
import 'package:scheduleapp/screens/settings/s_settings.dart';
import 'package:scheduleapp/utils/u_color.dart';
import 'package:scheduleapp/utils/u_responsive.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Provider.of<RutinaProvider>(context, listen: false).initData();
    Provider.of<EtiquetaProvider>(context, listen: false).obtenerEtiquetas();
    Provider.of<HomeProvider>(context, listen: false).initData();
  }

  final List<Widget> _children = [
    AgendaScreen(),
    RutinaScreen(),
    EtiquetasScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final _responsive = Responsive(context);
    return Consumer<HomeProvider>(builder: (context, value, _) {
      return Scaffold(
          backgroundColor: MColors.backgroundColor(context),
          body: _children[value.selectedIndex],
          bottomNavigationBar: FlashyTabBar(
            animationCurve: Curves.bounceInOut,
            height: 70,
            animationDuration: Duration(milliseconds: 300),
            selectedIndex: value.selectedIndex,
            backgroundColor: MColors.dialogsColor(context),
            iconSize: _responsive.ip(2.3),
            showElevation: true,
            onItemSelected: (index) => value.setTabBarIndex(index),
            items: [
              FlashyTabBarItem(
                activeColor: MColors.buttonColor(),
                inactiveColor: MColors.textColor(context).withOpacity(0.7),
                icon: Icon(AntDesign.home),
                title: Text('Agenda',
                    style: TextStyle(fontFamily: 'CircularStdBold')),
              ),
              FlashyTabBarItem(
                activeColor: MColors.buttonColor(),
                inactiveColor: MColors.textColor(context).withOpacity(0.7),
                icon: Icon(AntDesign.calendar),
                title: Text('Rutina',
                    style: TextStyle(fontFamily: 'CircularStdBold')),
              ),
              FlashyTabBarItem(
                activeColor: MColors.buttonColor(),
                inactiveColor: MColors.textColor(context).withOpacity(0.7),
                icon: Icon(Icons.tag_faces),
                title: Text('Etiquetas',
                    style: TextStyle(fontFamily: 'CircularStdBold')),
              ),
              FlashyTabBarItem(
                activeColor: MColors.buttonColor(),
                inactiveColor: MColors.textColor(context).withOpacity(0.7),
                icon: Icon(AntDesign.setting),
                title: Text('Configuracion',
                    style: TextStyle(fontFamily: 'CircularStdBold')),
              ),
            ],
          ));
    });
  }
}
