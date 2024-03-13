import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeBluegray500 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray500,
      );
  static get bodyLargeBluegray50001 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray50001,
      );
  static get bodyLargeInterOnPrimaryContainer =>
      theme.textTheme.bodyLarge!.inter.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get bodyLargePrimary => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  // Display text style
  static get displaySmall36 => theme.textTheme.displaySmall!.copyWith(
        fontSize: 36.fSize,
      );
  static get displaySmallindigoA200 => theme.textTheme.displaySmall!.copyWith(
        color: appTheme.indigoA200,
        fontSize: 36.fSize,
      );
  // Title text style
  static get titleLargeDMSansOnPrimaryContainer =>
      theme.textTheme.titleLarge!.dMSans.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w700,
      );
  static get titleLargeOpenSansPrimary =>
      theme.textTheme.titleLarge!.openSans.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static get titleLargeRobotoGray50001 =>
      theme.textTheme.titleLarge!.roboto.copyWith(
        color: appTheme.gray50001,
      );
}

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get dMSans {
    return copyWith(
      fontFamily: 'DM Sans',
    );
  }

  TextStyle get openSans {
    return copyWith(
      fontFamily: 'Open Sans',
    );
  }


  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }
}
