import 'package:flutter/material.dart';
import 'package:rgbremote/core/config/app_color.dart';

import '../../../core/config/app_text.dart';
import '../../../core/constants/app_strings.dart';

class TooltipWidget extends StatelessWidget {
  const TooltipWidget({
    super.key,
    this.onDismiss,
  });

  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 8, 30, 8),
          child: Text(AppStrings.assistMessage, style: AppTextStyle.kBS13W400),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: onDismiss,
            icon: Icon(
              Icons.close,
              color: AppColors.kBlackColor,
              size: 18,
            ),
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ],
    );
  }
}
