import 'dart:math';
import 'package:flutter/widgets.dart';

enum NumberPadInfoPosition { Top, Bottom }

class NumberPad extends StatefulWidget {
  final Widget title;
  final Icon backIcon;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String doneBtnText;
  final Color doneBtnColor;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final BorderRadius doneBtnRadius;
  final Color doneBtnBackgroundColor;
  final BoxDecoration buttonDecoration;
  final void Function(String value) onUpdate;
  final bool Function(String value) enableOnDone;
  final Widget Function(String value) extraInfos;
  final NumberPadInfoPosition extraInfosPosition;
  final String Function(String value) formatDisplay;
  final NumberPadInfoPosition doneBtnExtraInfosPosition;
  final void Function(String value, String formatedValue) onDone;
  final List<InlineSpan> Function(String value) doneBtnExtraInfos;

  const NumberPad(
      {Key key,
      this.onDone,
      this.onUpdate,
      this.buttonDecoration,
      this.backIcon,
      this.formatDisplay,
      this.doneBtnExtraInfos,
      this.doneBtnText,
      this.doneBtnColor,
      this.doneBtnBackgroundColor,
      this.doneBtnRadius,
      this.extraInfos,
      this.doneBtnExtraInfosPosition,
      this.extraInfosPosition,
      this.padding,
      this.backgroundColor,
      this.borderRadius,
      this.margin,
      this.title,
      this.enableOnDone})
      : super(key: key);
  @override
  _NumberPadState createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  String value = "";
  void _appendToOutput(String _value) {
    setState(() {
      if (_value.isNotEmpty && (_value != "." || !value.contains(".")))
        value += _value;
      if (widget.onUpdate != null) widget.onUpdate(value);
    });
  }

  Widget numericInputButton(String value) {
    return GestureDetector(
      onTap: () {
//This will append the value, also note that decimal value is not appended twice.
        _appendToOutput(value);
      },
      child: (value ?? "").isEmpty
          ? Container(height: 50, width: 50)
          : Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: widget.buttonDecoration != null
                  ? widget.buttonDecoration
                  : BoxDecoration(
                      color: widget.backgroundColor ?? Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(min(1, 0)),
                          blurRadius: 3.0,
                        )
                      ],
                    ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121)),
              ),
            ),
    );
  }

  Widget backButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (value.isNotEmpty)
                value = value.substring(0, value.length - 1);
              if (widget.onUpdate != null) widget.onUpdate(value);
            });
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFF5F5F5),
                  blurRadius: 3.0,
                )
              ],
            ),
            child: widget.backIcon != null
                ? IconTheme(
                    data: IconThemeData(
                      color: Color(0xFF212121),
                      size: 25,
                    ),
                    child: widget.backIcon)
                : Text("DEL"),
          ),
        )
      ],
    );
  }

  String get _formated =>
      widget.formatDisplay != null ? widget.formatDisplay(value) : value;
  @override
  Widget build(BuildContext context) {
    List<InlineSpan> _doneBtnChildren =
        widget.doneBtnExtraInfos != null ? widget.doneBtnExtraInfos(value) : [];
    String __eol = ((_doneBtnChildren ?? []).isNotEmpty ? "\n" : "");
    List<List<InlineSpan>> doneBtnChildren = [[], _doneBtnChildren];
    List<String> _eol = ["", __eol];
    List<List<Widget>> _extra = widget.extraInfos != null
        ? [
            [],
            [
              Container(
                  height: 0.5,
                  color: (widget.doneBtnBackgroundColor ?? Color(0x8a000000))
                      .withOpacity(0.3)),
              Container(
                  color: (widget.doneBtnBackgroundColor ?? Color(0xFFFFFFFF))
                      .withOpacity(0.1),
                  child: widget.extraInfos(value)),
              Container(
                  height: 0.5,
                  color: (widget.doneBtnBackgroundColor ?? Color(0x8a000000))
                      .withOpacity(0.3)),
            ],
          ]
        : [[], []];
    if ((widget.doneBtnExtraInfosPosition ?? NumberPadInfoPosition.Bottom) ==
        NumberPadInfoPosition.Top) {
      doneBtnChildren = doneBtnChildren.reversed.toList();
      _eol = _eol.reversed.toList();
    }
    if ((widget.extraInfosPosition ?? NumberPadInfoPosition.Bottom) ==
        NumberPadInfoPosition.Top) {
      _extra = _extra.reversed.toList();
    }
    ;
    return Container(
      // height: 411.0,
      margin: widget.margin ?? EdgeInsets.zero,
      padding: widget.padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
          color: widget.backgroundColor ?? Color(0xFFFFFFFF),
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.title != null)
            Container(
              color: Color(0xFFaeaeae).withOpacity(0.07),
              child: widget.title,
            ),
          ..._extra[0],
          Expanded(
            child: Container(
              color: Color(0xFFaeaeae).withOpacity(0.07),
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                _formated,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ..._extra[1],
          Container(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      numericInputButton('1'),
                      numericInputButton('2'),
                      numericInputButton('3'),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      numericInputButton('4'),
                      numericInputButton('5'),
                      numericInputButton('6'),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      numericInputButton('7'),
                      numericInputButton('8'),
                      numericInputButton('9'),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      numericInputButton(''),
                      numericInputButton('0'),
                      backButton()
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Opacity(
              opacity: widget.enableOnDone == null ||
                      (widget.enableOnDone != null &&
                          (widget.enableOnDone(value) ?? false))
                  ? 1
                  : 0.5,
              child: GestureDetector(
                // color: (widget.doneBtnBackgroundColor ?? Color(0xFFFFFFFF)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        widget.doneBtnRadius ?? BorderRadius.circular(10.0),
                    color: widget.doneBtnBackgroundColor ?? Color(0xFFFFFFFF),
                  ),
                  padding: EdgeInsets.all(10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: widget.doneBtnColor ?? Color(0xFF212121),
                      ),
                      children: [
                        ...doneBtnChildren[0],
                        TextSpan(
                          text: _eol[0] +
                              ((widget.doneBtnText ?? "").isNotEmpty
                                  ? widget.doneBtnText
                                  : "DONE") +
                              _eol[1],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.doneBtnColor ?? Color(0xFF212121),
                          ),
                        ),
                        ...doneBtnChildren[1],
                      ],
                    ),
                  ),
                ),
                onTap: widget.enableOnDone == null ||
                        (widget.enableOnDone != null &&
                            (widget.enableOnDone(value) ?? false))
                    ? () {
                        if (widget.onDone != null)
                          widget.onDone(value, _formated);
                      }
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
