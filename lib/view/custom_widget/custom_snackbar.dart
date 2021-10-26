import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

const double _singleLineVerticalPadding = 14.0;
const Color _kSnackBackground = Color(0xFF323232);
const Curve _snackBarFadeInCurve =
    Interval(0.45, 1.0, curve: Curves.fastOutSlowIn);
const Curve _snackBarFadeOutCurve =
    Interval(0.72, 1.0, curve: Curves.fastOutSlowIn);

const Duration _kSnackBarTransitionDuration = Duration(milliseconds: 250);
const Duration _kSnackBarDisplayDuration = Duration(milliseconds: 4000);
const Curve _snackBarHeightCurve = Curves.fastOutSlowIn;
const Curve _snackBarFadeCurve =
    Interval(0.72, 1.0, curve: Curves.fastOutSlowIn);

class MySnack extends StatefulWidget implements SnackBar {
  const MySnack({
    Key key,
    this.backgroundColor,
    this.action,
    this.duration = _kSnackBarDisplayDuration,
    this.animation,
  })  : assert(duration != null),
        super(key: key);

  final Color backgroundColor;

  final CustomSnackBarAction action;

  final Duration duration;

  final Animation<double> animation;

  @override
  _MySnackState createState() => _MySnackState();

  static AnimationController createAnimationController(
      {@required TickerProvider vsync}) {
    return AnimationController(
      duration: _kSnackBarTransitionDuration,
      debugLabel: 'SnackBar',
      vsync: vsync,
    );
  }

  @override
  // TODO: implement behavior
  SnackBarBehavior get behavior => SnackBarBehavior.floating;

  @override
  // TODO: implement elevation
  double get elevation => 10;

  @override
  // TODO: implement onVisible
  get onVisible => () {};

  @override
  // TODO: implement shape
  ShapeBorder get shape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0));

  @override
  MySnack withAnimation(Animation<double> newAnimation, {Key fallbackKey}) {
    return MySnack(
      key: key ?? fallbackKey,
      backgroundColor: backgroundColor,
      action: action,
      duration: duration,
      animation: newAnimation,
    );
  }

  @override
  // TODO: implement content
  Widget get content => throw UnimplementedError();

  @override
  // TODO: implement margin
  EdgeInsetsGeometry get margin => throw UnimplementedError();

  @override
  // TODO: implement padding
  EdgeInsetsGeometry get padding => throw UnimplementedError();

  @override
  // TODO: implement width
  double get width => throw UnimplementedError();
}

class _MySnackState extends State<MySnack> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    assert(widget.animation != null);
    final ThemeData theme = Theme.of(context);
    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      accentColor: theme.accentColor,
      accentColorBrightness: theme.accentColorBrightness,
    );
    final List<Widget> children = <Widget>[
      const SizedBox(width: 14),
      Icon(Icons.keyboard_arrow_up),
      widget.action,
      const SizedBox(width: 19),
    ];
    final CurvedAnimation heightAnimation =
        CurvedAnimation(parent: widget.animation, curve: _snackBarHeightCurve);
    final CurvedAnimation fadeAnimation = CurvedAnimation(
        parent: widget.animation,
        curve: _snackBarFadeCurve,
        reverseCurve: const Threshold(0.0));
    Widget snackbar = SafeArea(
      bottom: false,
      top: false,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
    snackbar = Semantics(
      container: true,
      liveRegion: true,
      onDismiss: () {
        Scaffold.of(context)
            .removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
      },
      child: Dismissible(
        key: const Key('dismissible'),
        direction: DismissDirection.down,
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          Scaffold.of(context)
              .removeCurrentSnackBar(reason: SnackBarClosedReason.swipe);
        },
        //TODO: Update Padding from here
        child: Padding(
          padding: EdgeInsets.only(
            bottom: ScreenUtil().setSp(40, allowFontScalingSelf: true),
            left: ScreenUtil().setSp(90, allowFontScalingSelf: true),
          ),
          child: Container(
            //TODO: Update Border Radius from here
            decoration: BoxDecoration(
                color: widget.backgroundColor ?? _kSnackBackground,
                borderRadius: BorderRadius.circular(25.0)),

            child: Material(
              elevation: 0.0,
              color: Colors.transparent,
              child: Theme(
                data: darkTheme,
                child: mediaQueryData.accessibleNavigation
                    ? snackbar
                    : FadeTransition(
                        opacity: fadeAnimation,
                        child: snackbar,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
    return ClipRect(
      child: mediaQueryData.accessibleNavigation
          ? snackbar
          : AnimatedBuilder(
              animation: heightAnimation,
              builder: (BuildContext context, Widget child) {
                return Align(
                  alignment: AlignmentDirectional.topStart,
                  heightFactor: heightAnimation.value,
                  child: child,
                );
              },
              child: snackbar,
            ),
    );
  }

  SnackBar withAnimation(Animation<double> newAnimation, {Key fallbackKey}) {
    return MySnack(
      key: fallbackKey,
      backgroundColor: widget.backgroundColor,
      action: widget.action,
      duration: widget.duration,
      animation: newAnimation,
    );
  }

  @override
  // TODO: implement behavior
  SnackBarBehavior get behavior => SnackBarBehavior.floating;

  @override
  State<SnackBar> createState() => _CustomSnackBarState();

  @override
  // TODO: implement elevation
  double get elevation => 10;

  @override
  // TODO: implement onVisible
  get onVisible => () {};

  @override
  // TODO: implement shape
  ShapeBorder get shape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0));
}

class _CustomSnackBarState extends State<SnackBar> {
  bool _wasVisible = false;

  @override
  void initState() {
    super.initState();
    widget.animation.addStatusListener(_onAnimationStatusChanged);
  }

  @override
  void didUpdateWidget(SnackBar oldWidget) {
    if (widget.animation != oldWidget.animation) {
      oldWidget.animation.removeStatusListener(_onAnimationStatusChanged);
      widget.animation.addStatusListener(_onAnimationStatusChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus animationStatus) {
    switch (animationStatus) {
      case AnimationStatus.dismissed:
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.completed:
        if (widget.onVisible != null && !_wasVisible) {
          widget.onVisible();
        }
        _wasVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    assert(widget.animation != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final SnackBarThemeData snackBarTheme = theme.snackBarTheme;
    final bool isThemeDark = theme.brightness == Brightness.dark;

    // SnackBar uses a theme that is the opposite brightness from
    // the surrounding theme.
    final Brightness brightness =
        isThemeDark ? Brightness.light : Brightness.dark;
    final Color themeBackgroundColor = isThemeDark
        ? colorScheme.onSurface
        : Color.alphaBlend(
            colorScheme.onSurface.withOpacity(0.80), colorScheme.surface);
    final ThemeData inverseTheme = ThemeData(
      brightness: brightness,
      backgroundColor: themeBackgroundColor,
      colorScheme: ColorScheme(
        primary: colorScheme.onPrimary,
        primaryVariant: colorScheme.onPrimary,
        // For the button color, the spec says it should be primaryVariant, but for
        // backward compatibility on light themes we are leaving it as secondary.
        secondary:
            isThemeDark ? colorScheme.primaryVariant : colorScheme.secondary,
        secondaryVariant: colorScheme.onSecondary,
        surface: colorScheme.onSurface,
        background: themeBackgroundColor,
        error: colorScheme.onError,
        onPrimary: colorScheme.primary,
        onSecondary: colorScheme.secondary,
        onSurface: colorScheme.surface,
        onBackground: colorScheme.background,
        onError: colorScheme.error,
        brightness: brightness,
      ),
      snackBarTheme: snackBarTheme,
    );

    final TextStyle contentTextStyle =
        snackBarTheme.contentTextStyle ?? inverseTheme.textTheme.subtitle1;
    final SnackBarBehavior snackBarBehavior =
        widget.behavior ?? snackBarTheme.behavior ?? SnackBarBehavior.fixed;
    final bool isFloatingSnackBar =
        snackBarBehavior == SnackBarBehavior.floating;
    final double snackBarPadding = isFloatingSnackBar ? 16.0 : 24.0;

    final CurvedAnimation heightAnimation =
        CurvedAnimation(parent: widget.animation, curve: _snackBarHeightCurve);
    final CurvedAnimation fadeInAnimation =
        CurvedAnimation(parent: widget.animation, curve: _snackBarFadeInCurve);
    final CurvedAnimation fadeOutAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: _snackBarFadeOutCurve,
      reverseCurve: const Threshold(0.0),
    );

    Widget snackBar = SafeArea(
      top: false,
      bottom: !isFloatingSnackBar,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: snackBarPadding),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: _singleLineVerticalPadding),
              child: DefaultTextStyle(
                style: contentTextStyle,
                child: widget.content,
              ),
            ),
          ),
          if (widget.action != null)
            ButtonTheme(
              textTheme: ButtonTextTheme.accent,
              minWidth: 64.0,
              padding: EdgeInsets.symmetric(horizontal: snackBarPadding),
              child: widget.action,
            )
          else
            SizedBox(width: snackBarPadding),
        ],
      ),
    );

    final double elevation = widget.elevation ?? snackBarTheme.elevation ?? 6.0;
    final Color backgroundColor = widget.backgroundColor ??
        snackBarTheme.backgroundColor ??
        inverseTheme.backgroundColor;
    final ShapeBorder shape = widget.shape ??
        snackBarTheme.shape ??
        (isFloatingSnackBar
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))
            : null);

    snackBar = Material(
      shape: shape,
      elevation: elevation,
      color: backgroundColor,
      child: Theme(
        data: inverseTheme,
        child: mediaQueryData.accessibleNavigation
            ? snackBar
            : FadeTransition(
                opacity: fadeOutAnimation,
                child: snackBar,
              ),
      ),
    );

    if (isFloatingSnackBar) {
      snackBar = Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
        child: snackBar,
      );
    }

    snackBar = Semantics(
      container: true,
      liveRegion: true,
      onDismiss: () {
        Scaffold.of(context)
            .removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
      },
      child: Dismissible(
        key: const Key('dismissible'),
        direction: DismissDirection.down,
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          Scaffold.of(context)
              .removeCurrentSnackBar(reason: SnackBarClosedReason.swipe);
        },
        child: snackBar,
      ),
    );

    Widget snackBarTransition;
    if (mediaQueryData.accessibleNavigation) {
      snackBarTransition = snackBar;
    } else if (isFloatingSnackBar) {
      snackBarTransition = FadeTransition(
        opacity: fadeInAnimation,
        child: snackBar,
      );
    } else {
      snackBarTransition = AnimatedBuilder(
        animation: heightAnimation,
        builder: (BuildContext context, Widget child) {
          return Align(
            alignment: AlignmentDirectional.topStart,
            heightFactor: heightAnimation.value,
            child: child,
          );
        },
        child: snackBar,
      );
    }

    return ClipRect(child: snackBarTransition);
  }
}

class CustomSnackBarAction extends StatefulWidget implements SnackBarAction {
  /// Creates an action for a [SnackBar].
  ///
  /// The [label] and [onPressed] arguments must be non-null.
  const CustomSnackBarAction({
    Key key,
    this.textColor,
    this.disabledTextColor,
    @required this.label,
    @required this.onPressed,
  })  : assert(label != null),
        assert(onPressed != null),
        super(key: key);

  /// The button label color. If not provided, defaults to [accentColor].
  final Color textColor;

  /// The button disabled label color. This color is shown after the
  /// [snackBarAction] is dismissed.
  final Color disabledTextColor;

  /// The button label.
  final String label;

  /// The callback to be called when the button is pressed. Must not be null.
  ///
  /// This callback will be called at most once each time this action is
  /// displayed in a [SnackBar].
  final VoidCallback onPressed;

  @override
  State<CustomSnackBarAction> createState() => _CustomSnackBarActionState();
}

class _CustomSnackBarActionState extends State<CustomSnackBarAction> {
  bool _haveTriggeredAction = false;

  void _handlePressed() {
    if (_haveTriggeredAction) return;
    setState(() {
      _haveTriggeredAction = true;
    });
    widget.onPressed();
    Scaffold.of(context)
        .hideCurrentSnackBar(reason: SnackBarClosedReason.action);
  }

  @override
  Widget build(BuildContext context) {
    final SnackBarThemeData snackBarTheme = Theme.of(context).snackBarTheme;
    final Color textColor = widget.textColor ?? snackBarTheme.actionTextColor;
    final Color disabledTextColor =
        widget.disabledTextColor ?? snackBarTheme.disabledActionTextColor;

    return FlatButton(
      onPressed: _haveTriggeredAction ? null : _handlePressed,
      child: Text(widget.label),
      textColor: textColor,
      disabledTextColor: disabledTextColor,
      padding: EdgeInsets.all(0),
    );
  }
}
