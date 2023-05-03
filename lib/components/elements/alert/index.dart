import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/alert/icons/cancel.dart';
import 'package:my_language_app/components/elements/alert/icons/confirm.dart';
import 'package:my_language_app/components/elements/alert/icons/success.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';

class ComponentDialog extends StatefulWidget {
  /// animation curve when showing,if null,default value is `DialogLib.showCurve`
  final Curve? curve;

  final ComponentDialogOptions options;

  ComponentDialog({
    required this.options,
    this.curve,
  }) : assert(options != null);

  @override
  State<StatefulWidget> createState() => ComponentDialogState();
}

class ComponentDialogState extends State<ComponentDialog>
    with SingleTickerProviderStateMixin, DialogLib {
  late AnimationController controller;

  late Animation<double> tween;

  late ComponentDialogOptions _options;

  @override
  void initState() {
    _options = widget.options;
    controller =  AnimationController(vsync: this);
    tween =  Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.animateTo(1.0,
        duration:  Duration(milliseconds: 300),
        curve: widget.curve ?? DialogLib.showCurve);

    DialogLib.state = this;
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    DialogLib.state = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(ComponentDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void confirm() {
    if (_options.onPress != null && _options.onPress!(true) == false) return;
    Navigator.pop(context);
  }

  void cancel() {
    if (_options.onPress != null && _options.onPress!(false) == false) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listOfChildren = [];

    switch (_options.style) {
      case ComponentDialogStyle.success:
        listOfChildren.add( SizedBox(
          width: 64.0,
          height: 64.0,
          child: SuccessView(),
        ));
        break;
      case ComponentDialogStyle.confirm:
        listOfChildren.add( SizedBox(
          width: 64.0,
          height: 64.0,
          child: ConfirmView(),
        ));
        break;
      case ComponentDialogStyle.error:
        listOfChildren.add( SizedBox(
          width: 64.0,
          height: 64.0,
          child: CancelView(),
        ));
        break;
      case ComponentDialogStyle.loading:
        listOfChildren.add( SizedBox(
          width: 64.0,
          height: 64.0,
          child:  Center(
            child:  CircularProgressIndicator(),
          ),
        ));
        break;
    }

    if (_options.title != null) {
      listOfChildren.add(Padding(
        padding: this._options.titlePadding ??
            EdgeInsets.only(left: 10.0, top: 10.0),
        child:  Text(
          _options.title ?? "",
          textAlign: this._options.titleTextAlign ?? TextAlign.left,
          style: this._options.titleStyle ??
               TextStyle(
                fontSize: 25.0,
                color:  Color(0xff575757),
              ),
        ),
      ));
    }

    if (_options.subtitle != null) {
      listOfChildren.add( Padding(
        padding:
        this._options.subtitlePadding ??  EdgeInsets.only(top: 10.0),
        child:  Text(
          _options.subtitle ?? "",
          textAlign: this._options.subtitleTextAlign ?? TextAlign.left,
          style: this._options.subtitleStyle ??
               TextStyle(
                fontSize: 16.0,
                color:  Color(0xff797979),
              ),
        ),
      ));
    }

    if (_options.style != ComponentDialogStyle.loading) {
      if (_options.showCancelButton == true) {
        listOfChildren.add( Padding(
          padding:  EdgeInsets.only(top: 10.0),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               MaterialButton(
                onPressed: cancel,
                color: _options.cancelButtonColor ?? DialogLib.cancel,
                child:  Text(
                  _options.cancelButtonText ?? DialogLib.cancelText,
                  style:  TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
               SizedBox(
                width: 10.0,
              ),
               MaterialButton(
                onPressed: confirm,
                color: _options.confirmButtonColor ?? DialogLib.danger,
                child:  Text(
                  _options.confirmButtonText ?? DialogLib.confirmText,
                  style:  TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ));
      } else {
        listOfChildren.add( Padding(
          padding:  EdgeInsets.only(top: 10.0),
          child:  MaterialButton(
            onPressed: confirm,
            color: _options.confirmButtonColor ?? DialogLib.success,
            child:  Text(
              _options.confirmButtonText ?? DialogLib.successText,
              style:  TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ));
      }
    }

    return  Center(
        child:  AnimatedBuilder(
            animation: controller,
            builder: (c, w) {
              return  ScaleTransition(
                scale: tween,
                child:  ClipRRect(
                  borderRadius:  BorderRadius.all( Radius.circular(5.0)),
                  child:  Container(
                      color: Colors.white,
                      width: double.infinity,
                      child:  Padding(
                        padding:  EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child:  Column(
                          mainAxisSize: MainAxisSize.min,
                          children: listOfChildren,
                        ),
                      )),
                ),
              );
            }));
  }

  void update(ComponentDialogOptions options) {
    setState(() {
      _options = options;
    });
  }
}