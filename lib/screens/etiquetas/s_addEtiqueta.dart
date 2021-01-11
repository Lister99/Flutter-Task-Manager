import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/controllers/c_etiquetas.dart';
import 'package:scheduleapp/models/m_etiqueta.dart';
import 'package:scheduleapp/utils/u_color.dart';
import 'package:scheduleapp/widgets/w_snackBar.dart';
import 'package:scheduleapp/widgets/w_text.dart';
import 'package:scheduleapp/widgets/w_textField.dart';

class AddEtiquetaScreen extends StatefulWidget {
  final bool isEdit;
  final Etiqueta etiqueta;
  AddEtiquetaScreen({Key key, this.isEdit = false, this.etiqueta})
      : super(key: key);

  @override
  _AddEtiquetaScreenState createState() => _AddEtiquetaScreenState();
}

class _AddEtiquetaScreenState extends State<AddEtiquetaScreen> {
  Color _tempShadeColor = Colors.blue[200];
  Color _shadeColor = Colors.blue[800];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nombre = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setData();
  }

  void _setData() {
    if (widget.isEdit) {
      _nombre.text = widget.etiqueta.nombre;
      _tempShadeColor = widget.etiqueta.color;
      setState(() {});
    }
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(6.0),
              backgroundColor: MColors.dialogsColor(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(title),
              content: content,
              actions: [
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: Navigator.of(context).pop,
                ),
                FlatButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() => _shadeColor = _tempShadeColor);
                  },
                ),
              ],
            ));
      },
    );
  }

  BuildContext myScaContext;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Consumer<EtiquetaProvider>(builder: (context, value, _) {
      return Scaffold(
        backgroundColor: MColors.backgroundColor(context),
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: MColors.backgroundColor(context),
          elevation: 0,
          centerTitle: false,
          iconTheme: Theme.of(context).iconTheme,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
          actions: [
            if (widget.isEdit)
              if (widget.etiqueta.canDelete == 1)
                IconButton(
                  onPressed: () async {
                    final x = await value.deleteEtiqueta(widget.etiqueta);
                    if (x.identifier == "success") {
                      Navigator.pop(context);
                    } else {
                      SnackBars.showErrorSnackBar(myScaContext, context,
                          Icons.error, "Etiqueta", x.message);
                    }
                  },
                  icon: Icon(Icons.delete),
                ),
            IconButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  final x = !widget.isEdit
                      ? await value.addEtiqueta(_nombre.text, _shadeColor)
                      : await value.updateEtiqueta(
                          widget.etiqueta.id, _nombre.text, _shadeColor);
                  if (x.identifier == "success") {
                    Navigator.pop(context);
                  } else {
                    SnackBars.showErrorSnackBar(myScaContext, context,
                        Icons.error, "Etiqueta", x.message);
                  }
                }
              },
              icon: Icon(Icons.check),
            ),
          ],
          title: Text(
            "${widget.isEdit ? "Editar" : "Nueva"} Etiqueta",
            style: CText.primarycustomText(2.5, context, "CircularStdBold"),
          ),
        ),
        body: Builder(builder: (scaContezt) {
          myScaContext = scaContezt;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _size.width * .05),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CTextField(
                        label: "Nombre",
                        radius: 5,
                        controller: _nombre,
                        validator: (e) =>
                            e.isEmpty ? 'No puede estar vacio' : null,
                        padding: EdgeInsets.symmetric(
                            vertical: 5, horizontal: _size.width * .02)),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: _size.width * .08),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(200),
                            onTap: () {
                              _openDialog(
                                "Seleccionar Color",
                                MaterialColorPicker(
                                  shrinkWrap: true,
                                  selectedColor: _shadeColor,
                                  onColorChange: (color) =>
                                      setState(() => _tempShadeColor = color),
                                  onBack: () => print("Back button pressed"),
                                ),
                              );
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _tempShadeColor),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    _size.width * .05,
                                  ),
                                  child: Icon(
                                    Icons.color_lens,
                                    color: Colors.white,
                                    size: _size.width * .08,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
