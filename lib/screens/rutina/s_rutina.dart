import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/controllers/c_rutina.dart';
import 'package:scheduleapp/models/m_actividad.dart';
import 'package:scheduleapp/screens/rutina/s_addActividad.dart';
import 'package:scheduleapp/utils/u_color.dart';
import 'package:scheduleapp/utils/u_time.dart';
import 'package:scheduleapp/widgets/w_text.dart';

class RutinaScreen extends StatefulWidget {
  RutinaScreen({Key key}) : super(key: key);

  @override
  _RutinaScreenState createState() => _RutinaScreenState();
}

class _RutinaScreenState extends State<RutinaScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Consumer<RutinaProvider>(builder: (context, value, _) {
      return Scaffold(
        backgroundColor: MColors.backgroundColor(context),
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: MColors.backgroundColor(context),
          elevation: 0,
          centerTitle: false,
          iconTheme: Theme.of(context).iconTheme,
          automaticallyImplyLeading: false,
          title: Text(
            "Mi Rutina",
            style: CText.primarycustomText(2.5, context, "CircularStdBold"),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: InkWell(
          onTap: () async {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: AddActividad()));
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
        body: DefaultTabController(
          length: 7,
          child: Column(children: [
            TabBar(
              unselectedLabelColor: MColors.textColor(context),
              labelColor: MColors.main,
              indicatorColor: MColors.main,
              tabs: value.actividadesSemana
                  .map((e) => Tab(
                        child: Text(
                          dias[value.actividadesSemana.indexOf(e)],
                        ),
                      ))
                  .toList(),
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (index) {
                value.setDay(index);
              },
            ),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: value.actividadesSemana
                        .map((e) => ActividadesPorDia(
                              key: UniqueKey(),
                              index: value.actividadesSemana.indexOf(e),
                              actividades: e,
                            ))
                        .toList())),
          ]),
        ),
      );
    });
  }

  List<String> dias = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'];
}

// ignore: must_be_immutable
class ActividadesPorDia extends StatelessWidget {
  List<Actividad> actividades;
  int index;
  ActividadesPorDia({Key key, this.actividades, this.index}) : super(key: key);

  List<String> dias = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo'
  ];

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return actividades.isEmpty
        ? Center(
            child: Text(
              "Aun no tiene actividades para el dia ${dias[index]}",
              style: CText.primarycustomText(1.8, context, 'CircularStdMedium'),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 20),
            child: ListView.builder(
                //controller: scrollController,
                shrinkWrap: true,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: false,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: actividades.length,
                itemBuilder: (BuildContext listContext, int index) {
                  return FadeIn(
                    duration: Duration(seconds: 1),
                    animate: true,
                    delay: Duration(milliseconds: index * 200),
                    child: InkWell(
                      onTap: () async {
                        if (actividades[index].tipo == 1)
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: AddActividad(
                                    isEdit: true,
                                    actividad: actividades[index],
                                  )));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _size.width * 0.03),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                spreadRadius: 0,
                                blurRadius: 11,
                                offset:
                                    Offset(1, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                            color: actividades[index].tipo == 1
                                ? MColors.thirdBackgroundColor(context)
                                : MColors.navigationBarColor(context),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    width: _size.width * 0.02,
                                    decoration: BoxDecoration(
                                      color: actividades[index].color,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(0),
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(0)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20,
                                          horizontal: _size.width * 0.05),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                if (actividades[index].tipo ==
                                                    1)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        '${TimeValidator.getTimeOfDayS(actividades[index].timeInit)} - ${TimeValidator.getTimeOfDayS(actividades[index].timeFinish)}',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: actividades[
                                                                    index]
                                                                .color),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Icon(
                                                        actividades[index]
                                                                    .notificar ==
                                                                1
                                                            ? Icons.alarm_on
                                                            : Icons.alarm_off,
                                                        color:
                                                            actividades[index]
                                                                .color,
                                                        size: 17,
                                                      )
                                                    ],
                                                  ),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        actividades[index]
                                                            .etiquetaName,
                                                        style: actividades[
                                                                        index]
                                                                    .tipo ==
                                                                1
                                                            ? CText.primarycustomText(
                                                                1.8,
                                                                context,
                                                                'CircularStdMedium')
                                                            : CText.secondarycustomText(
                                                                1.6,
                                                                context,
                                                                'CircularStdBook'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (actividades[index].tipo ==
                                                    1)
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                            actividades[index]
                                                                .comentario,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: CText
                                                                .secondarycustomText(
                                                                    1.5,
                                                                    context,
                                                                    'CircularStdMedium')),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                          if (actividades[index].tipo == 1)
                                            Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
