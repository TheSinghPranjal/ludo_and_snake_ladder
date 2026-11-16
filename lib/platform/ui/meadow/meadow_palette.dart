import 'package:flutter/painting.dart';

/// Background, label chip and border of a Player Setup seat card.
typedef SeatTint = ({Color bg, Color chip, Color border});

/// Colours of the Home screen, sampled from its daytime illustration. Home
/// always shows that artwork, so these do not follow the light/dark theme.
abstract final class HomePalette {
  /// Background below the artwork.
  static const cream = Color(0xFFFEEDCF);

  /// Labels on the cream controls.
  static const ink = Color(0xFF272634);

  /// Profile pill and Settings button.
  static const chip = Color(0xFFFCF8F2);

  /// Top of the Stats / How to Play buttons.
  static const buttonTop = Color(0xFFFFFBF5);

  /// Bottom of the Stats / How to Play buttons.
  static const buttonBottom = Color(0xFFFCEBD3);

  /// Play button gradient, top.
  static const playTop = Color(0xFF2DA8FF);

  /// Play button gradient, middle.
  static const playMid = Color(0xFF0A6DFC);

  /// Play button gradient, bottom.
  static const playBottom = Color(0xFF0052E0);

  /// Blue glow under the Play button.
  static const playGlow = Color(0x660067FC);

  /// Shadow under the Play label.
  static const playShade = Color(0x66003C9E);

  /// Shadow under the play triangle.
  static const playShadeSoft = Color(0x55003C9E);

  /// Avatar ring, top.
  static const ringLight = Color(0xFFFDD280);

  /// Avatar ring, bottom.
  static const ringDark = Color(0xFFF39A2E);

  /// Soft shadow under the cream controls.
  static const shadow = Color(0x40A8763E);

  /// Soft light around the Play button rim.
  static const rimGlow = Color(0x33FFFFFF);

  /// Borders, the play icon and the gloss.
  static const white = Color(0xFFFFFFFF);

  /// Fully transparent, for fades.
  static const clear = Color(0x00FFFFFF);

  /// Meadow scaffold green background placeholder while loading.
  static const meadowGreen = Color(0xFF81C784);

  /// Settings and Hub cream card background.
  static const cardCream = Color(0xFFFFF9EE);

  /// Settings and Hub cream card border.
  static const cardBorder = Color(0xFFF0E5D0);

  /// Settings segmented pill background trough.
  static const trough = Color(0xFFF6EEDF);

  /// Settings segmented pill border.
  static const troughBorder = Color(0xFFEADDC8);

  /// Active pill gradient top.
  static const pillTop = Color(0xFF0095F6);

  /// Active pill gradient bottom.
  static const pillBottom = Color(0xFF006CD9);

  /// Active pill glow shadow.
  static const pillGlow = Color(0x44007AFF);

  /// Active pill border highlight.
  static const pillRim = Color(0x9940C4FF);

  /// Meadow controls dark ink label.
  static const meadowInk = Color(0xFF1D1B26);

  /// Inactive icon color in segments.
  static const iconMuted = Color(0xFF424242);

  /// Meadow divider line between settings sections.
  static const meadowDivider = Color(0xFFEEDFCB);

  /// Active switch track blue.
  static const switchTrack = Color(0xFF0079EE);

  /// Inactive switch track warm cream/grey.
  static const switchTrackInactive = Color(0xFFE5DAC8);

  /// Sound section icon.
  static const iconPurple = Color(0xFF7E57C2);

  /// Sound effects icon.
  static const iconSoundEffects = Color(0xFF9C27B0);

  /// Music icon.
  static const iconMusic = Color(0xFFEC407A);

  /// Haptics icon.
  static const iconHaptics = Color(0xFF43A047);

  /// Animation speed icon.
  static const iconSpeed = Color(0xFFFFA000);

  /// Turn timer icon.
  static const iconTimer = Color(0xFF5E35B1);

  /// AI difficulty icon.
  static const iconAi = Color(0xFF1E88E5);

  /// Light appearance icon.
  static const iconSun = Color(0xFFFFA000);

  /// Dark appearance icon.
  static const iconMoon = Color(0xFF5C6BC0);

  /// Reset stats button background.
  static const resetBg = Color(0xFFFFF0ED);

  /// Reset stats button border.
  static const resetBorder = Color(0xFFF28B82);

  /// Reset stats text and icon red.
  static const resetRed = Color(0xFFD32F2F);

  /// Continue chip warm background.
  static const continueBg = Color(0xFFFFF3E0);

  /// Continue chip border.
  static const continueBorder = Color(0xFFFFB74D);

  /// Continue chip icon.
  static const continueIcon = Color(0xFFF57C00);

  /// Continue chip text.
  static const continueText = Color(0xFFE65100);

  /// Soft dark shadow for cards.
  static const cardShadow = Color(0x22000000);

  /// Bar chart blue bar color.
  static const chartBlue = Color(0xFF42A5F5);

  /// Darker lip under the raised cream controls.
  static const creamEdge = Color(0xFFE6CC9C);

  /// Bottom of the raised cream pills.
  static const pillCream = Color(0xFFF8EBD2);

  /// Navy ink of the back chevron and How to Play label.
  static const navy = Color(0xFF1B2A5C);

  /// Settings panel, top.
  static const panelTop = Color(0xFFFFFAF0);

  /// Settings panel, bottom.
  static const panelBottom = Color(0xFFFBF1DE);

  /// Darker lip under the blue selected segment.
  static const pillEdge = Color(0xFF0048B0);

  /// Reset stats button, bottom of its gradient.
  static const resetBottom = Color(0xFFFAD6CD);

  /// Orange "ta-da" strokes beside the Start button.
  static const burst = Color(0xFFFFA726);

  /// Name field background on the seat cards.
  static const field = Color(0xFFFFFCF8);

  /// Seat card tint, chip and border per player colour.
  static const SeatTint seatRed = (
    bg: Color(0xFFFCEDE9),
    chip: Color(0xFFFADBD3),
    border: Color(0xFFF0C2B7),
  );

  /// Blue seat tints.
  static const SeatTint seatBlue = (
    bg: Color(0xFFEAF4FD),
    chip: Color(0xFFD2E7FA),
    border: Color(0xFFB4D6F3),
  );

  /// Green seat tints.
  static const SeatTint seatGreen = (
    bg: Color(0xFFECF7E7),
    chip: Color(0xFFD5EECB),
    border: Color(0xFFBADFAE),
  );

  /// Yellow seat tints.
  static const SeatTint seatYellow = (
    bg: Color(0xFFFFF7E0),
    chip: Color(0xFFFCEBB8),
    border: Color(0xFFF0D894),
  );

  /// Gold frame around the board preview, top.
  static const frameTop = Color(0xFFFFD54F);

  /// Gold frame, bottom.
  static const frameBottom = Color(0xFFFFA726);

  /// Gold frame edge.
  static const frameEdge = Color(0xFFE08A00);

  /// Night wash over the meadow behind a game in dark mode.
  static const nightWash = Color(0xB30B1530);

  /// Name on the wooden title sign.
  static const signText = Color(0xFFFFFBF2);

  /// Outline of the sign text.
  static const signStroke = Color(0xFF6B2E0C);

  /// Orange border of the cream stat chip.
  static const chipEdge = Color(0xFFF2A93B);

  /// Light blue Turn chip, top.
  static const turnTop = Color(0xFFF4FAFF);

  /// Light blue Turn chip, bottom.
  static const turnBottom = Color(0xFFD6ECFF);

  /// Waiting player card, cream.
  static const cardWaiting = Color(0xFFFFF4DC);

  /// Muted line on a player card.
  static const cardMuted = Color(0xFF4A5378);

  /// Dice pedestal, red top.
  static const pedestalRed = Color(0xFFF0372E);

  /// Dice pedestal, red side.
  static const pedestalRedDark = Color(0xFFB8170F);

  /// Dice pedestal, gold base top.
  static const pedestalGold = Color(0xFFFFD34A);

  /// Dice pedestal, gold base side.
  static const pedestalGoldDark = Color(0xFFE88B00);

  /// Sun glow behind the dice.
  static const glow = Color(0xCCFFF59D);

  /// Rays behind the dice.
  static const ray = Color(0xAAFFE36B);

  /// Yellow dashes beside the status line.
  static const statusBurst = Color(0xFFFFC21A);
}
