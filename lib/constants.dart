// Arquivo de constantes para facilitar a edição de widgets
// Centralize aqui todas as dimensões, cores, tamanhos, etc.

import 'package:flutter/material.dart';

// ===== DIMENSÕES GERAIS =====
const double kPaddingSmall = 8.0;
const double kPaddingMedium = 16.0;
const double kPaddingLarge = 24.0;
const double kPaddingExtraLarge = 32.0;

const double kBorderRadiusSmall = 8.0;
const double kBorderRadiusMedium = 12.0;
const double kBorderRadiusLarge = 20.0;

const double kSpacingSmall = 8.0;
const double kSpacingMedium = 12.0;
const double kSpacingLarge = 16.0;
const double kSpacingExtraLarge = 24.0;

// ===== TAMANHOS DE IMAGENS =====
const double kLogoWidth = 150.0;
const double kLogoHeight = 150.0;

const double kProductImageWidth = 60.0;
const double kProductImageHeight = 60.0;

const double kCardImageHeightRatio = 3.0; // Flex para Expanded
const double kCardInfoHeightRatio = 2.0; // Flex para Expanded

// ===== TAMANHOS DE CARDS =====
const double kProductCardElevation = 3.0;
const double kProductCardBorderRadius = 40.0;
const double kProductCardPadding = 1.0;

// ===== TAMANHOS DE TEXTO =====
const double kTitleFontSize = 33.0;
const double kSubtitleFontSize = 20.0;
const double kBodyFontSize = 16.0;
const double kSmallFontSize = 13.0;
const double kTinyFontSize = 10.0;

// ===== TAMANHOS DE ÍCONES =====
const double kIconSizeSmall = 20.0;
const double kIconSizeMedium = 30.0;
const double kIconSizeLarge = 40.0;

// ===== TAMANHOS DE BOTÕES =====
const double kButtonHeight = 50.0;
const double kButtonBorderRadius = 15.0;
const Size kButtonMinSize = Size(double.infinity, 40.0);

// ===== TAMANHOS DE TEXT FIELDS =====
const double kTextFieldBorderRadius = 12.0;

// ===== GRID LAYOUT =====
const double kGridCrossAxisSpacing = 6.0;
const double kGridMainAxisSpacing = 6.0;
const double kGridChildAspectRatio = 1.0;

const double kGridBreakpointMedium = 600.0;
const double kGridBreakpointLarge = 900.0;
const int kGridColumnsSmall = 2;
const int kGridColumnsMedium = 3;
const int kGridColumnsLarge = 4;

// ===== CORES =====
const Color kPrimaryColor = Color(0xFFF9BC15);
const Color kSecondaryColor = Color(0xFF8B1A10);
const Color kAccentColor = Color(0xFFFFC107);
const Color kBackgroundColor = Color(0xFF8B1A10);
const Color kSurfaceColor = Color(0xFFFFC107);
const Color kTextColor = Colors.black;
const Color kErrorColor = Colors.red;

// ===== TEMAS =====
const TextStyle kTitleTextStyle = TextStyle(
  fontSize: kTitleFontSize,
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
);

const TextStyle kSubtitleTextStyle = TextStyle(
  fontSize: kSubtitleFontSize,
  color: kPrimaryColor,
);

const TextStyle kBodyTextStyle = TextStyle(
  fontSize: kBodyFontSize,
  fontWeight: FontWeight.bold,
);

const TextStyle kSmallTextStyle = TextStyle(
  fontSize: kSmallFontSize,
  fontWeight: FontWeight.bold,
);

// ===== DECORAÇÕES =====
const BoxDecoration kProductCardDecoration = BoxDecoration(
  color: kSurfaceColor,
  borderRadius: BorderRadius.all(Radius.circular(kProductCardBorderRadius)),
);

InputDecoration kTextFieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kTextFieldBorderRadius),
    ),
    filled: true,
    fillColor: const Color.fromARGB(255, 56, 45, 45),
  );
}

ButtonStyle kElevatedButtonStyle(Color backgroundColor) {
  return ElevatedButton.styleFrom(
    backgroundColor: backgroundColor,
    foregroundColor: kTextColor,
    minimumSize: kButtonMinSize,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kButtonBorderRadius),
    ),
  );
}

// ===== OUTROS =====
const Duration kSnackBarDuration = Duration(seconds: 1);
const double kAppBarElevation = 0.0;
