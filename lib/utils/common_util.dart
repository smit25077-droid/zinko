import 'package:flutter/material.dart';

/// Centralized utility for spacing, padding, margin, and border radius.
/// Using a consistent 16.0 pixel base as requested.
class CommonUtil {
  // --- Base Spacing Values ---
  static const double s4 = 4.0;
  static const double s6 = 6.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0; // Primary spacing
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s25 = 25.0;
  static const double s28 = 28.0;
  static const double s30 = 30.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s120 = 120.0;

  // --- Padding / Margin (EdgeInsets) ---
  static const EdgeInsets pAll4 = EdgeInsets.all(s4);
  static const EdgeInsets pAll8 = EdgeInsets.all(s8);
  static const EdgeInsets pAll12 = EdgeInsets.all(s12);
  static const EdgeInsets pAll16 = EdgeInsets.all(s16);
  static const EdgeInsets pAll20 = EdgeInsets.all(s20);
  static const EdgeInsets pAll24 = EdgeInsets.all(s24);
  static const EdgeInsets pAll32 = EdgeInsets.all(s32);

  static const EdgeInsets pV40 = EdgeInsets.symmetric(vertical: 40.0);

  static const EdgeInsets pH16 = EdgeInsets.symmetric(horizontal: s16);
  static const EdgeInsets pH8 = EdgeInsets.symmetric(horizontal: s8);
  static const EdgeInsets pV16 = EdgeInsets.symmetric(vertical: s16);
  static const EdgeInsets pH20 = EdgeInsets.symmetric(horizontal: s20);
  static const EdgeInsets pV20 = EdgeInsets.symmetric(vertical: s20);
  static const EdgeInsets pH20V4 = EdgeInsets.symmetric(horizontal: s20, vertical: s4);
  static const EdgeInsets pH16V12 = EdgeInsets.symmetric(horizontal: s16, vertical: s12);
  static const EdgeInsets pHor16V12 = pH16V12; // Alias for consistency
  static const EdgeInsets pHor8Ver4 = EdgeInsets.symmetric(horizontal: s8, vertical: s4);
  static const EdgeInsets pH16V18 = EdgeInsets.symmetric(horizontal: s16, vertical: s18);
  static const EdgeInsets pHor10Ver6 = EdgeInsets.symmetric(horizontal: s10, vertical: s6);
  static const EdgeInsets pHor12Ver4 = EdgeInsets.symmetric(horizontal: s12, vertical: s4);
  static const EdgeInsets pHor12Ver10 = EdgeInsets.symmetric(horizontal: s12, vertical: s10);
  static const EdgeInsets pHor20Ver12 = EdgeInsets.symmetric(horizontal: s20, vertical: s12);
  static const EdgeInsets pHor24Ver12 = EdgeInsets.symmetric(horizontal: s24, vertical: s12);
  static const EdgeInsets pHor24Ver8 = EdgeInsets.symmetric(horizontal: s24, vertical: s8);
  static const EdgeInsets pLTRB24_8_16_4 = EdgeInsets.fromLTRB(24.0, 8.0, 16.0, 4.0);
  static const EdgeInsets pH24 = EdgeInsets.symmetric(horizontal: s24);
  static const EdgeInsets pV24 = EdgeInsets.symmetric(vertical: s24);
  static const EdgeInsets pHor16Ver8 = EdgeInsets.symmetric(horizontal: s16, vertical: s8);
  static const EdgeInsets pHor16Ver12 = EdgeInsets.symmetric(horizontal: s16, vertical: s12);
  static const EdgeInsets pHor24Ver16 = EdgeInsets.symmetric(horizontal: s24, vertical: s16);
  static const EdgeInsets pHor32 = EdgeInsets.symmetric(horizontal: s32);
  static const EdgeInsets pHor32Ver20 = EdgeInsets.symmetric(horizontal: s32, vertical: s20);
  static const EdgeInsets pHor32Ver40Bottom = EdgeInsets.fromLTRB(32, 0, 32, 40);

  static const EdgeInsets pV12 = EdgeInsets.symmetric(vertical: 12.0);
  static const EdgeInsets pV30 = EdgeInsets.symmetric(vertical: 30.0);

  static const EdgeInsets pLeft4 = EdgeInsets.only(left: 4.0);
  static const EdgeInsets pRight4 = EdgeInsets.only(right: 4.0);
  static const EdgeInsets pRight8 = EdgeInsets.only(right: 8.0);
  static const EdgeInsets pRight20 = EdgeInsets.only(right: s20);
  static const EdgeInsets pBottom12 = EdgeInsets.only(bottom: 12.0);
  static const EdgeInsets pBottom16 = EdgeInsets.only(bottom: s16);

  // --- Border Radius ---
  static const double r8 = 8.0;
  static const double r10 = 10.0;
  static const double r12 = 12.0;
  static const double r14 = 14.0;
  static const double r16 = 16.0;
  static const double r18 = 18.0;
  static const double r20 = 20.0;
  static const double r22 = 22.0;
  static const double r24 = 24.0;
  static const double r28 = 28.0;
  static const double r30 = 30.0;
  static const double r50 = 50.0;

  static final BorderRadius bRadius4 = BorderRadius.circular(4);
  static final BorderRadius bRadius8 = BorderRadius.circular(r8);
  static final BorderRadius bRadius10 = BorderRadius.circular(r10);
  static final BorderRadius bRadius12 = BorderRadius.circular(r12);
  static final BorderRadius bRadius14 = BorderRadius.circular(r14);
  static final BorderRadius bRadius16 = BorderRadius.circular(r16);
  static final BorderRadius bRadius18 = BorderRadius.circular(r18);
  static final BorderRadius bRadius20 = BorderRadius.circular(r20);
  static final BorderRadius bRadius22 = BorderRadius.circular(r22);
  static final BorderRadius bRadius24 = BorderRadius.circular(r24);
  static final BorderRadius bRadius28 = BorderRadius.circular(r28);
  static final BorderRadius bRadius30 = BorderRadius.circular(r30);
  static final BorderRadius bRadius50 = BorderRadius.circular(r50);

  // --- Gap Widgets (SizedBox) ---
  static const Widget vGap1 = SizedBox(height: 1.0);
  static const Widget vGap2 = SizedBox(height: 2.0);
  static const Widget vGap4 = SizedBox(height: s4);
  static const Widget vGap6 = SizedBox(height: s6);
  static const Widget vGap8 = SizedBox(height: s8);
  static const Widget vGap10 = SizedBox(height: s10);
  static const Widget vGap12 = SizedBox(height: s12);
  static const Widget vGap14 = SizedBox(height: 14.0);
  static const Widget vGap16 = SizedBox(height: s16);
  static const Widget vGap20 = SizedBox(height: s20);
  static const Widget vGap24 = SizedBox(height: s24);
  static const Widget vGap25 = SizedBox(height: s25);
  static const Widget vGap28 = SizedBox(height: 28.0);
  static const Widget vGap30 = SizedBox(height: 30.0);
  static const Widget vGap32 = SizedBox(height: s32);
  static const Widget vGap40 = SizedBox(height: s40);
  static const Widget vGap48 = SizedBox(height: s48);
  static const Widget vGap50 = SizedBox(height: 50.0);
  static const Widget vGap100 = SizedBox(height: 100.0);
  static const Widget vGap120 = SizedBox(height: s120);

  static const Widget hGap4 = SizedBox(width: s4);
  static const Widget hGap6 = SizedBox(width: s6);
  static const Widget hGap8 = SizedBox(width: s8);
  static const Widget hGap10 = SizedBox(width: s10);
  static const Widget hGap12 = SizedBox(width: s12);
  static const Widget hGap14 = SizedBox(width: s14);
  static const Widget hGap16 = SizedBox(width: s16);
  static const Widget hGap20 = SizedBox(width: s20);
  static const Widget hGap24 = SizedBox(width: s24);
  static const Widget hGap32 = SizedBox(width: s32);
}
