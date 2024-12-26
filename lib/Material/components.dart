import 'dart:io';

import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final bool isDisabled;
  final String text;
  final Color? textColor;
  final Color? fillColor;
  final Color? hoverColor;
  final Color? colorBg;
  final double? width;
  final double? height;
  final bool? hasBorder;
  final double? fontSize;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.textColor,
    this.fillColor,
    this.hoverColor,
    this.width,
    this.height,
    this.onPressed,
    this.hasBorder,
    this.colorBg,
    this.isDisabled = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: width ?? 100.0,
        height: height ?? 40.0,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return theme.colorScheme.surfaceContainerHighest;
              } else if (states.contains(WidgetState.hovered)) {
                return hoverColor ??
                    theme.colorScheme.primary.withOpacity(0.85);
              }
              return fillColor ?? theme.colorScheme.primary;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.disabled)
                  ? theme.colorScheme.onSurfaceVariant
                  : textColor ?? theme.colorScheme.onPrimary;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return theme.colorScheme.primaryContainer;
              }
              return null;
            }),
            elevation: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.hovered) ? 4.0 : 2.0;
            }),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: hasBorder != false
                    ? BorderSide(color: theme.colorScheme.outline, width: 1.5)
                    : BorderSide.none,
              ),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 14.0,
              fontWeight: FontWeight.w500,
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
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width ?? 100.0,
        height:
            widget.height ?? 48.0, // Slightly taller for better touch target
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.controller.value
                ? (widget.fillColor ?? Theme.of(context).colorScheme.secondary)
                : (widget.borderColor ??
                    Theme.of(context).colorScheme.onSurface),
            width: 1.5,
          ),
          color: widget.controller.value
              ? (widget.fillColor ??
                  (widget.fillColor ?? Theme.of(context).colorScheme.secondary))
              : Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12.0), // Updated rounded corners
          boxShadow: widget.controller.value
              ? [
                  BoxShadow(
                    color: (widget.fillColor ?? Theme.of(context).primaryColor)
                        .withOpacity(0.4),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize ?? 16.0, // Slightly larger text size
            color: widget.controller.value
                ? (widget.textColorFill ??
                    (widget.fillColor ??
                        Theme.of(context).colorScheme.onSecondary))
                : (widget.textColorNorm ??
                    Theme.of(context).colorScheme.onSurface),
            fontWeight:
                FontWeight.w500, // Medium font weight for better readability
          ),
        ),
      ),
    );
  }
}

class CustomDropdownMenu extends StatefulWidget {
  final List<String> options;
  final String? hintText;
  final ValueNotifier<String> selectedOption;
  final double? width;
  final double? fontSize;
  final double? height;
  final double? itemHeight;
  final Color? borderColor;
  final Color? textColor;
  final Color? dropColor;
  final bool isLeftAligned;
  final Function(String)? onChangeSelected;

  const CustomDropdownMenu({
    super.key,
    required this.options,
    required this.selectedOption,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.fontSize,
    this.dropColor,
    this.hintText,
    this.isLeftAligned = false,
    this.onChangeSelected,
    this.itemHeight,
  });

  @override
  _CustomDropdownMenuState createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: widget.width ?? 200,
        height: widget.height ?? 56,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                widget.borderColor ?? Theme.of(context).colorScheme.onSurface,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12.0),
          color: Theme.of(context).colorScheme.surfaceContainer,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ValueListenableBuilder<String>(
          valueListenable: widget.selectedOption,
          builder: (context, selectedValue, child) {
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                focusNode: _focusNode,
                isExpanded: true,
                value: selectedValue.isEmpty ? null : selectedValue,
                alignment: widget.isLeftAligned
                    ? Alignment.centerLeft
                    : Alignment.center,
                hint: Text(
                  widget.hintText ?? 'Select Option',
                  textAlign:
                      widget.isLeftAligned ? TextAlign.left : TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: widget.fontSize ?? 14.0,
                  ),
                ),
                items: widget.options.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Align(
                      alignment: widget.isLeftAligned
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: widget.textColor ??
                              Theme.of(context).colorScheme.onSurface,
                          fontSize: widget.fontSize ?? 14.0,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    widget.selectedOption.value = newValue;
                    widget.onChangeSelected?.call(newValue);
                  }
                  _focusNode.unfocus();
                },
                dropdownColor: widget.dropColor ??
                    Theme.of(context)
                        .colorScheme
                        .surface, // Dropdown background
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                style: TextStyle(
                  color: widget.textColor ??
                      Theme.of(context).colorScheme.onSurface,
                  fontSize: widget.fontSize ?? 14.0,
                ),
                menuMaxHeight: 240, // Limit dropdown height
              ),
            );
          },
        ),
      ),
    );
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
        : theme.colorScheme.surfaceVariant;
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

