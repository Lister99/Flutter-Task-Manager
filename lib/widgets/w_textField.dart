import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scheduleapp/utils/u_color.dart';

class CTextField extends StatefulWidget {
  final String label;
  final Function(String) validator;
  final String labelText;
  final bool sisecure;
  final TextInputType inputType;
  final double fontSize;
  final bool isEnable;
  final EdgeInsetsGeometry padding;
  final IconData prefixicon;
  final IconData sufixicon;
  final TextEditingController controller;
  final VoidCallback onTap;
  final Function function;
  final Function saveFunction;
  final int maxLines;
  final int minLines;
  final double borderWidth;
  final double radius;
  final bool isUnderline;
  final Widget specialIcon;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;
  const CTextField(
      {Key key,
      @required this.label,
      this.validator,
      this.labelText,
      this.minLines,
      this.isEnable,
      this.saveFunction,
      this.onTap,
      this.sisecure = false,
      this.maxLines,
      this.borderWidth = 1,
      this.function,
      this.inputType = TextInputType.text,
      this.fontSize,
      this.maxLength,
      this.specialIcon,
      this.inputFormatters,
      @required this.padding,
      this.prefixicon,
      this.controller,
      this.isUnderline,
      this.sufixicon,
      this.radius})
      : super(key: key);
  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<CTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters:
          widget.inputFormatters == null ? null : widget.inputFormatters,
      maxLength: widget.maxLength == null ? null : widget.maxLength,
      keyboardType: widget.inputType,
      minLines: widget.minLines != null ? 1 : widget.minLines,
      maxLines: widget.maxLines == null ? 1 : widget.maxLines,
      obscureText: widget.sisecure,
      cursorColor: Theme.of(context).buttonColor,
      style: TextStyle(
          fontFamily: 'CircularStdBook',
          fontSize: widget.fontSize == null ? 17 : widget.fontSize),
      enabled: widget.isEnable == null ? true : widget.isEnable,
      validator: widget.validator,
      //initialValue: widget.labelText == null ? 'fsdfdd' : ' widget.labelText',
      controller: widget.controller,
      onTap: () {
        if (widget.onTap != null) widget.onTap();
      },
      onChanged: widget.function,
      onSaved: widget.saveFunction,
      keyboardAppearance: Theme.of(context).brightness,
      decoration: InputDecoration(
        //labelText: widget.labelText == null ? null : widget.labelText,
        icon: widget.specialIcon == null ? null : widget.specialIcon,
        counterText: "",

        filled: true,
        fillColor: MColors.textFieldBackgroundColor(context),
        hintText: widget.label,
        errorStyle: TextStyle(
            color: Colors.red.shade500, fontFamily: 'CircularStdBook'),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(widget.radius == null ? 20 : widget.radius),
          borderSide:
              BorderSide(color: Colors.red.shade500, width: widget.borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: MColors.textFieldBorderColor(context),
              width: widget.borderWidth),
        ),
        focusedBorder: widget.isUnderline != null
            ? OutlineInputBorder(
                borderSide: BorderSide(
                    color: MColors.textFieldEnabledBorderColor(),
                    width: widget.borderWidth),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    widget.radius == null ? 20 : widget.radius),
                borderSide: BorderSide(
                    color: Colors.transparent, width: widget.borderWidth),
              ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(widget.radius ==null ?20:widget.radius),borderSide: BorderSide(color: Colors.transparent),
        // ),
        disabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(widget.radius == null ? 20 : widget.radius),
          borderSide:
              BorderSide(color: Colors.transparent, width: widget.borderWidth),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(widget.radius ==null ?20:widget.radius),borderSide: BorderSide(color: Colors.transparent),
        // ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(widget.radius == null ? 20 : widget.radius),
          borderSide:
              BorderSide(color: Color(0xffFF647C), width: widget.borderWidth),
        ),

        //border: InputBorder.none,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(widget.radius == null ? 20 : widget.radius),
          borderSide:
              BorderSide(color: Colors.transparent, width: widget.borderWidth),
        ),
        prefixIcon: widget.prefixicon == null ? null : Icon(widget.prefixicon),
        suffixIcon: widget.sufixicon == null ? null : Icon(widget.sufixicon),
        hintStyle: TextStyle(
            fontFamily: 'CircularStdBook',
            color: Theme.of(context).accentColor),
        labelStyle: TextStyle(
            fontSize: widget.fontSize == null ? 17 : widget.fontSize,
            fontFamily: 'CircularStdBook'),
        contentPadding: widget.padding,
      ),
    );
  }
}
