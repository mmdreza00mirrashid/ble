import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheel_picker/wheel_picker.dart';

import 'constants.dart';

class LegSelectionWidget extends StatefulWidget {
  final bool isEditAllowed;
  final String selectedLeg;
  final ValueChanged<String> onSelectionChanged;

  const LegSelectionWidget({
    Key? key,
    required this.isEditAllowed,
    required this.selectedLeg,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<LegSelectionWidget> createState() => _LegSelectionWidgetState();
}

class _LegSelectionWidgetState extends State<LegSelectionWidget> {
  late String legSelection;

  @override
  void initState() {
    super.initState();
    legSelection = widget.selectedLeg;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(
            value: "Left",
            label: Text("Left"),
          ),
          ButtonSegment(
            value: "Both",
            label: Text("Both"),
          ),
          ButtonSegment(
            value: "Right",
            label: Text("Right"),
          ),
        ],
        selected: {legSelection},
        onSelectionChanged: widget.isEditAllowed
            ? (newSelection) {
                setState(() {
                  legSelection = newSelection.first;
                });
                widget.onSelectionChanged(legSelection);
              }
            : null,
        showSelectedIcon: false,
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all(
            Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double? width;
  final double? height;
  final String? initialValue;
  final TextStyle? textStyle;
  final double? fontSize;

  final bool? obscure;
  final bool isFilled;
  final bool? enableSuggestions;
  final bool? autocorrect;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.width,
    this.initialValue,
    this.height,
    this.textStyle,
    this.fontSize,
    this.isFilled = true,
    this.obscure,
    this.enableSuggestions,
    this.autocorrect,
  });

  @override
  Widget build(BuildContext context) {
    if (initialValue != null && controller.text.isEmpty) {
      controller.text = initialValue!;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width ?? 0,
          minHeight: height ?? 0,
        ),
        child: TextField(
          controller: controller,
          obscureText: obscure ?? false,
          enableSuggestions: enableSuggestions ?? true,
          autocorrect: autocorrect ?? true,
          decoration: InputDecoration(
            label: Text(hintText),
            filled: isFilled,
          ),
        ),
      ),
    );
  }
}

class CustomDateField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double? width;
  final double? height;
  final bool isLeftAligned;
  final bool isFilled;
  final Function(String)? onChanged;

  const CustomDateField({
    super.key,
    required this.hintText,
    required this.controller,
    this.height,
    this.width,
    this.isFilled = true,
    this.isLeftAligned = false,
    this.onChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1914),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                ),
            dialogBackgroundColor:
                Theme.of(context).datePickerTheme.backgroundColor,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      controller.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width ?? 0,
          minHeight: height ?? 0,
        ),
        child: TextField(
          controller: controller,
          readOnly: true,
          onChanged: onChanged,
          // textAlign: isLeftAligned ? TextAlign.left : TextAlign.center,
          decoration: InputDecoration(
            label: Text(hintText),
            filled: isFilled,
          ),
          onTap: () => _selectDate(context),
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double? width;
  final double? height;
  final Function(String)? onChanged;

  const SearchTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.height,
    this.width,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SearchBar(
        controller: controller,
        hintText: hintText,
        onChanged: onChanged,
        leading: const Icon(Icons.search),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final bool isDisabled;
  final String text;
  final double? width;
  final double? height;
  final bool? hasBorder;
  final double? fontSize;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.onPressed,
    this.hasBorder,
    this.isDisabled = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width ?? 0,
          minHeight: height ?? 0,
        ),
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ButtonStyle(
            elevation: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.hovered) ? 4.0 : 2.0;
            }),
            padding: WidgetStateProperty.resolveWith((states) {
              return EdgeInsets.symmetric(
                vertical: height == null ? 8.0 : 0.0,
                horizontal: width == null ? horizontalPadding : 0.0,
              );
            }),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 14.0,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final String text;
  final Color? fillColor;
  final Color? borderColor;
  final Color? textColorNorm;
  final Color? textColorFill;
  final double? width;
  final double? height;
  final double? fontSize;
  final ValueNotifier<bool> controller;
  final VoidCallback? onTap;

  const CustomCheckbox({
    super.key,
    required this.text,
    required this.controller,
    this.fillColor,
    this.textColorFill,
    this.textColorNorm,
    this.width,
    this.height,
    this.borderColor,
    this.fontSize,
    this.onTap,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    _listener = () {
      if (mounted) {
        setState(() {});
      }
    };

    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.width ?? 0,
        minHeight: widget.height ?? 0,
      ),
      child: ElevatedButton(
        onPressed: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return widget.controller.value
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.3);
          }),
          padding: WidgetStateProperty.resolveWith((states) {
            return EdgeInsets.symmetric(
              vertical: widget.height == null ? 12.0 : 0.0,
              horizontal: widget.width == null ? horizontalPadding : 0.0,
            );
          }),
        ),
        child: Text(
          widget.text,
        ),
      ),
    );
  }
}

class CustomDropdownMenu extends StatefulWidget {
  final List<String> options;
  final String? hintText;
  final ValueNotifier<String> selectedOption;
  final bool isFilled;
  const CustomDropdownMenu({
    super.key,
    required this.options,
    this.hintText,
    this.isFilled = true,
    required this.selectedOption,
  });

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  late String? _currentSelectedOption;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _currentSelectedOption = widget.selectedOption.value;
    widget.selectedOption.addListener(() {
      setState(() {
        _currentSelectedOption = widget.selectedOption.value;
      });
    });
  }

  void _onOptionSelected(String option) {
    widget.selectedOption.value = option;
    setState(() {
      _currentSelectedOption = option;
    });
  }

  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          readOnly: true,
          controller: TextEditingController(text: _currentSelectedOption),
          decoration: InputDecoration(
            label: Text(widget.hintText ?? ''),
            filled: widget.isFilled,
          ),
          onTap: () => _toggleMenu(context),
        ),
      ),
    );
  }

  void _toggleMenu(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(context);
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder: (context) => Positioned(
        width: renderBox.size.width,
        left: offset.dx,
        top: offset.dy + renderBox.size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: widget.options
                  .map(
                    (option) => ListTile(
                      title: Text(option),
                      onTap: () {
                        _onOptionSelected(option);
                        _toggleMenu(context);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}

class SortButtonDropdownMenu extends StatefulWidget {
  final List<String> options;
  final String? hintText;
  final ValueNotifier<String> selectedOption;

  const SortButtonDropdownMenu({
    super.key,
    required this.options,
    this.hintText,
    required this.selectedOption,
  });

  @override
  State<SortButtonDropdownMenu> createState() => _SortButtonDropdownMenuState();
}

class _SortButtonDropdownMenuState extends State<SortButtonDropdownMenu> {
  late String? _currentSelectedOption;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _currentSelectedOption = widget.selectedOption.value;

    widget.selectedOption.addListener(() {
      setState(() {
        _currentSelectedOption = widget.selectedOption.value;
      });
    });
  }

  void _onOptionSelected(String option) {
    widget.selectedOption.value = option;
    setState(() {
      _currentSelectedOption = option;
    });
  }

  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: SizedBox(
          width: _calculateButtonWidth(context),
          child: ElevatedButton(
            onPressed: () => _toggleMenu(context),
            child: _currentSelectedOption?.isEmpty ?? true
                ? Text(
                    widget.hintText ?? 'Sort',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  )
                : Icon(
                    _currentSelectedOption == "Ascending"
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
          ),
        ),
      ),
    );
  }

  void _toggleMenu(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(context);
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: renderBox.size.width,
        left: offset.dx,
        top: offset.dy + renderBox.size.height,
        child: Material(
          elevation: 4.0,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: widget.options
                .map(
                  (option) => ListTile(
                    title: Text(
                      option,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
                    onTap: () {
                      _onOptionSelected(option);
                      _toggleMenu(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  double _calculateButtonWidth(BuildContext context) {
    final textOptions = [...widget.options];
    if (widget.hintText != null) textOptions.add(widget.hintText!);

    final textStyle = TextStyle(color: Theme.of(context).colorScheme.onSurface);

    final maxWidth = textOptions.map((text) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: textStyle,
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      return textPainter.width;
    }).reduce((value, element) => value > element ? value : element);

    const double horizontalPadding = 16.0; // Adjust this value as needed
    return maxWidth + horizontalPadding * 2; // Add padding on both sides
  }

  // double _calculateButtonWidth(BuildContext context) {
  //   final textOptions = [...widget.options];
  //   if (widget.hintText != null) textOptions.add(widget.hintText!);
  //
  //   final maxWidth = textOptions.map((text) {
  //     final textPainter = TextPainter(
  //       text: TextSpan(
  //         text: text,
  //       ),
  //       maxLines: 1,
  //       textDirection: TextDirection.ltr,
  //     )..layout();
  //
  //     return textPainter.width;
  //   }).reduce((value, element) => value > element ? value : element);
  //
  //   return maxWidth + 64.0;
  // }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}

class CustomIcon extends StatefulWidget {
  final String label;
  final String assetPath;
  final double iconSize;
  final VoidCallback? onPressed;
  final bool isPressed;
  final bool hasCircle;
  final double? bgRadius;
  final double? maxWidth;

  const CustomIcon({
    Key? key,
    required this.label,
    required this.assetPath,
    required this.iconSize,
    this.onPressed,
    this.isPressed = false,
    this.hasCircle = true,
    this.bgRadius,
    this.maxWidth,
  }) : super(key: key);

  @override
  _CustomIconState createState() => _CustomIconState();
}

class _CustomIconState extends State<CustomIcon> {
  void _handlePress() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color circleColor = widget.isPressed
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;
    final Color iconColor = widget.isPressed
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurfaceVariant;
    final Color labelColor = widget.isPressed
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    double circleRadius = widget.iconSize / 2 + (widget.bgRadius ?? 5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handlePress,
        borderRadius: BorderRadius.circular(circleRadius),
        splashColor: theme.colorScheme.primary.withOpacity(0.2),
        highlightColor: theme.colorScheme.primary.withOpacity(0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (widget.hasCircle)
                  Container(
                    width: circleRadius * 2,
                    height: circleRadius * 2,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ImageIcon(
                  AssetImage(widget.assetPath),
                  color: iconColor,
                  size: widget.iconSize,
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width:
                  widget.maxWidth ?? MediaQuery.of(context).size.width * 0.15,
              child: Text(
                widget.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: labelColor,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class CustomButtonWithWidget extends StatelessWidget {
  final Widget child;
  final Color? colorBg;
  final Color? fillColor;
  final Color? hoverColor;
  final double? width;
  final double? height;
  final bool? hasBorder;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final double horizontalPadding;
  final Alignment alignment;

  const CustomButtonWithWidget({
    super.key,
    required this.child,
    this.colorBg,
    this.fillColor,
    this.hoverColor,
    this.width,
    this.height,
    this.onPressed,
    this.hasBorder = false,
    this.isDisabled = false,
    this.horizontalPadding = 0.0,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: horizontalPadding),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: hasBorder == true
              ? BorderSide(
                  color: Theme.of(context).buttonTheme.colorScheme!.onSecondary,
                )
              : BorderSide.none,
        ),
      ),
      alignment: alignment,
      elevation: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled) ? 0 : 4.0;
      }),
    );

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: width ?? 0,
            minHeight: height ?? 0,
          ),
          child: ElevatedButton(
            style: style,
            onPressed: isDisabled ? null : onPressed,
            child: _applyPrimaryColor(child),
          ),
        ));
  }

  Widget _applyPrimaryColor(Widget widget) {
    if (widget is Text) {
      return Text(
        widget.data ?? '',
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
        softWrap: widget.softWrap,
        textScaler: widget.textScaler,
      );
    } else if (widget is Icon) {
      return Icon(
        widget.icon,
        size: widget.size,
        semanticLabel: widget.semanticLabel,
      );
    }
    return widget;
  }
}

class CustomSwitch extends StatefulWidget {
  final String text;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    Key? key,
    required this.text,
    this.initialValue = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch> {
  late bool _isSwitched;

  @override
  void initState() {
    super.initState();
    _isSwitched = widget.initialValue;
  }

  void setSwitchValue(bool value) {
    setState(() {
      _isSwitched = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.text,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(
          value: _isSwitched,
          onChanged: (value) {
            setState(() {
              _isSwitched = value;
            });
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}

class DeviceBox extends StatelessWidget {
  final String name;
  final bool isConnected;
  final double? height;
  final double? width;
  final VoidCallback? onPressed;

  const DeviceBox({
    Key? key,
    required this.name,
    this.isConnected = false,
    this.height,
    this.width,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(
          vertical: 12.0, horizontal: horizontalPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: isConnected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
          width: 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isConnected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isConnected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                isConnected ? "Connected" : "Not Connected",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isConnected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfo extends StatefulWidget {
  final String name;
  final String sirname;
  final String? role;
  final Color? bgIconColor;
  final Color? textColor;
  final Color? boxColor;
  final String id;
  final double? iconRadius;

  const UserInfo({
    super.key,
    required this.name,
    required this.sirname,
    required this.id,
    this.iconRadius = 12.0,
    this.bgIconColor = Colors.white,
    this.textColor,
    this.role = "Patient",
    this.boxColor,
  });

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    double iconSize = (widget.iconRadius ?? 12) * 2;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                  color: widget.bgIconColor,
                ),
                child: _getRoleIcon(iconSize),
              ),
              const SizedBox(width: horizontalPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.name} ${widget.sirname}",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      widget.id,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: widget.textColor ??
                            Theme.of(context as BuildContext)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getRoleIcon(double size) {
    switch (widget.role) {
      case "Doctor":
        return ImageIcon(
          AssetImage("assets/phisioIconG.png"),
          size: size,
          color: Colors.purple,
        );
      case "Nurse":
        return ImageIcon(
          AssetImage("assets/DrIconG.png"),
          size: size,
          color: Colors.lightBlue,
        );
      default:
        return ImageIcon(
          AssetImage("assets/userIcon.png"),
          size: size,
          color: Colors.green,
        );
    }
  }
}

class EditableTextField extends StatefulWidget {
  final String? initialValue;
  final String label;
  final double? width;
  final double? height;
  final double? fontSize;

  final ValueChanged<String>? onChanged;

  const EditableTextField({
    Key? key,
    this.initialValue,
    required this.label,
    this.width,
    this.height,
    this.fontSize,
    this.onChanged,
  }) : super(key: key);

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 2,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Container(
          width: widget.width ?? 300.0,
          height: widget.height ?? 60.0,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Label
              Text(
                widget.label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: widget.fontSize ?? horizontalPadding,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8.0),

              Expanded(
                child: TextField(
                  controller: controller,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: widget.fontSize ?? horizontalPadding,
                  ),
                  onChanged: widget.onChanged,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.initialValue,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditableImageField extends StatefulWidget {
  final String? initialImagePath;
  final String label;
  final Color? labelColor;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final double? fontSize;
  final ValueChanged<String>? onChanged;

  const EditableImageField({
    Key? key,
    this.initialImagePath,
    required this.label,
    this.labelColor,
    this.backgroundColor,
    this.width,
    this.height,
    this.fontSize,
    this.onChanged,
  }) : super(key: key);

  @override
  _EditableImageFieldState createState() => _EditableImageFieldState();
}

class _EditableImageFieldState extends State<EditableImageField> {
  String? imagePath;

  @override
  void initState() {
    super.initState();
    imagePath = widget.initialImagePath;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
      widget.onChanged?.call(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: widget.width ?? double.infinity,
              height: widget.height ?? 56.0,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: imagePath == null
                          ? Text(
                              "Tap to select an image",
                            )
                          : Text(
                              "Image selected",
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: imagePath != null
                          ? Image.file(
                              File(imagePath!),
                              width: 40.0,
                              height: 40.0,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.image,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
