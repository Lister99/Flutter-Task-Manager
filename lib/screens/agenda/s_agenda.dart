import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/controllers/c_home.dart';
import 'package:scheduleapp/utils/u_color.dart';
import 'package:scheduleapp/utils/u_time.dart';
import 'package:scheduleapp/widgets/w_calendar.dart';
import 'package:scheduleapp/widgets/w_text.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class AgendaScreen extends StatefulWidget {
  AgendaScreen({Key key}) : super(key: key);

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  AutoScrollController scrollController = AutoScrollController();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    scrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    _initData();
  }

  _initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<HomeProvider>(context, listen: false).initData();
      final em = Provider.of<HomeProvider>(context, listen: false).isEmpty();
      if (!em) {
        int position = await Provider.of<HomeProvider>(context, listen: false)
            .getActivyInProgress();
        await scrollController.scrollToIndex(position,
            preferPosition: AutoScrollPosition.begin,
            duration: Duration(seconds: 2));
        scrollController.highlight(position);
      }
      //Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return Scaffold(
            appBar: AppBar(
              brightness: Theme.of(context).brightness,
              backgroundColor: MColors.backgroundColor(context),
              elevation: 0,
              title: Text(
                "${_dayLabels[value.diaSelected.weekday - 1]}., ${monthPrevLabels[value.diaSelected.month - 1].toLowerCase()}. ${value.diaSelected.day}, ${value.diaSelected.year}",
                style:
                    CText.primarycustomText(2.4, context, "CircularStdMedium"),
              ),
              iconTheme: Theme.of(context).iconTheme,
              actions: [
                IconButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (_) {
                          return CalendarScreen(
                            initialDate: value.diaSelected,
                            onDatePressed: (d) {
                              Navigator.pop(context);
                              value.setDay(d);
                            },
                          );
                        });
                  },
                  icon: Icon(Icons.calendar_today),
                ),
              ],
            ),
            backgroundColor: MColors.backgroundColor(context),
            body: GestureDetector(
              onHorizontalDragEnd: (dragEndDetails) {
                print("Hi");
                if (dragEndDetails.primaryVelocity < 0) {
                  final x = value.diaSelected.add(Duration(days: 1));
                  value.setDay(x);
                } else if (dragEndDetails.primaryVelocity > 0) {
                  final x = value.diaSelected.add(Duration(days: -1));
                  value.setDay(x);
                }
              },
              child: value.actividades.length == 0
                  ? Center(
                      child: Container(
                        color: Theme.of(context).backgroundColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Aun no tiene actividades para este dia",
                            style: CText.primarycustomText(
                                1.8, context, 'CircularStdMedium'),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ListView.builder(
                          //controller: scrollController,
                          shrinkWrap: true,
                          addAutomaticKeepAlives: true,
                          addRepaintBoundaries: false,
                          controller: scrollController,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemCount: value.actividades.length,
                          itemBuilder: (BuildContext listContext, int index) {
                            return FadeIn(
                              duration: Duration(seconds: 2),
                              animate: true,
                              delay: Duration(milliseconds: index * 200),
                              child: AutoScrollTag(
                                key: ValueKey(index),
                                controller: scrollController,
                                index: index,
                                highlightColor: Colors.black.withOpacity(0.1),
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
                                          offset: Offset(1,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      elevation: 0,
                                      color: value.actividades[index].tipo == 1
                                          ? MColors.thirdBackgroundColor(
                                              context)
                                          : MColors.navigationBarColor(context),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Container(
                                              width: _size.width * 0.02,
                                              decoration: BoxDecoration(
                                                color: value
                                                    .actividades[index].color,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    topRight:
                                                        Radius.circular(0),
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(0)),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal:
                                                        _size.width * 0.05),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          if (value
                                                                  .actividades[
                                                                      index]
                                                                  .tipo ==
                                                              1)
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '${TimeValidator.getTimeOfDayS(value.actividades[index].timeInit)} - ${TimeValidator.getTimeOfDayS(value.actividades[index].timeFinish)}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: value
                                                                          .actividades[
                                                                              index]
                                                                          .color),
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Icon(
                                                                  value.actividades[index].notificar ==
                                                                          1
                                                                      ? Icons
                                                                          .alarm_on
                                                                      : Icons
                                                                          .alarm_off,
                                                                  color: value
                                                                      .actividades[
                                                                          index]
                                                                      .color,
                                                                  size: 17,
                                                                )
                                                              ],
                                                            ),
                                                          Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: Text(
                                                                  value
                                                                      .actividades[
                                                                          index]
                                                                      .etiquetaName,
                                                                  style: value.actividades[index].tipo ==
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
                                                          if (value
                                                                  .actividades[
                                                                      index]
                                                                  .tipo ==
                                                              1)
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  child: Text(
                                                                      value
                                                                          .actividades[
                                                                              index]
                                                                          .comentario,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                      style: CText.secondarycustomText(
                                                                          1.5,
                                                                          context,
                                                                          'CircularStdMedium')),
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (value.actividades[index]
                                                            .tipo ==
                                                        1)
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_right,
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
                          })),
            ));
      },
    );
  }

  static List<String> monthPrevLabels = [
    "Ene",
    "Feb",
    "Mar",
    "Abr",
    "May",
    "Jun",
    "Jul",
    "Ago",
    "Sep",
    "Oct",
    "Nov",
    "Dic"
  ];

  static List<String> _dayLabels = [
    "Lun",
    "Mar",
    "Mie",
    "Jue",
    "Vie",
    "Sab",
    "Dom"
  ];
}
