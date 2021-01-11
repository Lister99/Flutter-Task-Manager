import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/controllers/c_etiquetas.dart';
import 'package:scheduleapp/screens/etiquetas/s_addEtiqueta.dart';
import 'package:scheduleapp/utils/u_color.dart';
import 'package:scheduleapp/widgets/w_text.dart';

class EtiquetasScreen extends StatefulWidget {
  EtiquetasScreen({Key key}) : super(key: key);

  @override
  _EtiquetasScreenState createState() => _EtiquetasScreenState();
}

class _EtiquetasScreenState extends State<EtiquetasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Provider.of<EtiquetaProvider>(context, listen: false).obtenerEtiquetas();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Consumer<EtiquetaProvider>(builder: (context, value, _) {
      return Scaffold(
        backgroundColor: MColors.backgroundColor(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: InkWell(
          onTap: () async {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: AddEtiquetaScreen()));
          },
          borderRadius: BorderRadius.circular(300),
          splashColor: Colors.white.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        MColors.main,
                        MColors.main,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        spreadRadius: 0,
                        blurRadius: 11,
                        offset: Offset(1, 5), // changes position of shadow
                      ),
                    ]),
                padding: EdgeInsets.symmetric(
                    horizontal: _size.width * 0.04,
                    vertical: _size.width * 0.04),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ),
        ),
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: MColors.backgroundColor(context),
          elevation: 0,
          title: Text(
            "Etiquetas",
            style: CText.primarycustomText(2.5, context, "CircularStdBold"),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            value.obtenerEtiquetas();
          },
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: AddEtiquetaScreen(
                            isEdit: true,
                            etiqueta: value.etiquetas[index],
                          )));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: _size.width * .05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: value.etiquetas[index].color,
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: _size.width * .05, vertical: 10),
                          child: Text(
                            value.etiquetas[index].nombre,
                            style: CText.menucustomText(
                                1.9, context, "CircularStdBook"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: value.etiquetas.length,
          ),
        ),
      );
    });
  }
}
