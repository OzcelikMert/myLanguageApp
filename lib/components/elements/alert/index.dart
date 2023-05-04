import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/alert/icons/error.dart';
import 'package:my_language_app/components/elements/alert/icons/confirm.dart';
import 'package:my_language_app/components/elements/alert/icons/success.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';

class ComponentDialog extends StatefulWidget {
  final ComponentDialogOptions options;

  ComponentDialog({
    required this.options,
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
    controller = AnimationController(vsync: this);
    tween = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.animateTo(1.0,
        duration: Duration(milliseconds: 300),
        curve: widget.options.curve);

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

  void confirm() async {
    if (_options.onPressed != null && (await _options.onPressed!(true)) == false) return;
    Navigator.pop(context);
  }

  void cancel() async {
    if (_options.onPressed != null && (await _options.onPressed!(false)) == false) return;
    Navigator.pop(context);
  }

  Widget getIconWidget() {
    Widget icon;
    switch (_options.icon) {
      case ComponentDialogIcon.success:
        icon = SizedBox(
          width: 64.0,
          height: 64.0,
          child: SuccessView(),
        );
        break;
      case ComponentDialogIcon.confirm:
        icon = SizedBox(
          width: 64.0,
          height: 64.0,
          child: ConfirmView(),
        );
        break;
      case ComponentDialogIcon.error:
        icon = SizedBox(
          width: 64.0,
          height: 64.0,
          child: ErrorView(),
        );
        break;
      case ComponentDialogIcon.loading:
        icon = SizedBox(
          width: 64.0,
          height: 64.0,
          child: Center(
            child: CircularProgressIndicator(
              color: ThemeConst.colors.primary,
              backgroundColor: ThemeConst.colors.light,
            ),
          ),
        );
        break;
      default:
        icon = Container();
        break;
    }
    return icon;
  }

  Widget getButtonsWidget() {
    return _options.showCancelButton == true
        ? Padding(
            padding: EdgeInsets.only(top: ThemeConst.paddings.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  onPressed: cancel,
                  color: _options.cancelButtonColor ?? ThemeConst.colors.gray,
                  child: Text(
                    _options.cancelButtonText ?? "Cancel",
                    style: TextStyle(fontSize: ThemeConst.fontSizes.md),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: ThemeConst.paddings.sm)),
                MaterialButton(
                  onPressed: confirm,
                  color: _options.confirmButtonColor ?? ThemeConst.colors.primary,
                  child: Text(
                    _options.confirmButtonText ?? "Confirm",
                    style: TextStyle(fontSize: ThemeConst.fontSizes.md),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: ThemeConst.paddings.sm),
            child: MaterialButton(
              onPressed: confirm,
              color: _options.confirmButtonColor ?? ThemeConst.colors.primary,
              child: Text(
                _options.confirmButtonText ?? "Okay",
                style: TextStyle(fontSize: ThemeConst.fontSizes.md),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedBuilder(
            animation: controller,
            builder: (c, w) {
              return ScaleTransition(
                scale: tween,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Container(
                      width: double.infinity,
                      color: ThemeConst.colors.dark,
                      child: Padding(
                        padding: EdgeInsets.all(ThemeConst.paddings.md),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            getIconWidget(),
                            Padding(
                              padding: EdgeInsets.only(left: ThemeConst.paddings.sm, top: ThemeConst.paddings.sm),
                              child: Text(
                                _options.title ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ThemeConst.fontSizes.lg,
                                  color: ThemeConst.colors.light,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: ThemeConst.paddings.sm),
                              child: Text(
                                _options.content ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ThemeConst.fontSizes.md,
                                  color: ThemeConst.colors.light,
                                ),
                              ),
                            ),
                            _options.icon != ComponentDialogIcon.loading
                                ? getButtonsWidget()
                                : Container()
                          ],
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
