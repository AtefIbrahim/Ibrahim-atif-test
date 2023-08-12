import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task/core/utils/palette.dart';
import 'package:task/core/utils/styles.dart';

class RowTextInfo  extends StatelessWidget {
  const RowTextInfo({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title: ",
            textAlign: TextAlign.start,
            style: Styles.titleStyle20.copyWith(
              color: Palette.kBlack,
              fontWeight: FontWeight.w700,
            )),
        SizedBox(
          width: 15.w,
        ),
        Text(value,
            textAlign: TextAlign.start,
            style: Styles.titleStyle20.copyWith(
              color: Palette.kBlack.withOpacity(0.5),
              fontWeight: FontWeight.w700,
            )),
      ],
    );
  }
}
