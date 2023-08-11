import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatefulWidget {
  CustomElevatedButton({
    super.key,
    this.width,
    this.height,
    this.text,
    this.backgroundColor,
    required this.onPressed,
    this.textStyle,
    this.borderColor,
    this.textColor,
    this.radius,
    this.customChild,
    this.elevation,
  });
  double? width;
  double? height;
  Color? backgroundColor;
  Color? borderColor;
  String? text;
  TextStyle? textStyle;
  Color? textColor;
  void Function() onPressed;
  double? radius;
  Widget? customChild;
  double? elevation;
  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            widget.backgroundColor,
          ),
          elevation: MaterialStateProperty.resolveWith<double>(
            // As you said you dont need elevation. I'm returning 0 in both case
            (Set<MaterialState> states) {
              if (widget.elevation != null) {
                return widget.elevation!;
              }
              return 0; // Defer to the widget's default.
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 30.r),
              side: BorderSide(
                color: widget.borderColor!,
              ),
            ),
          ),
        ),
        onPressed: widget.onPressed,
        child: Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: widget.customChild ??
              Text(
                widget.text!,
                style: widget.textStyle,
              ),
        ),
      ),
    );
  }
}
