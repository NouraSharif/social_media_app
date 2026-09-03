// lib/core/utils/context_extension.dart
import 'package:flutter/material.dart';

/// حجم التصميم الأساسي من فريم الفيجما (iPhone ~375x812).
/// كل القيم بتتحسب كنسبة من هيك، فبتضل متناسقة على أي حجم شاشة.
const double _kDesignWidth = 375;
const double _kDesignHeight = 812;

extension ResponsiveContext on BuildContext {
  Size get _size => MediaQuery.sizeOf(this);

  double get screenWidth => _size.width;
  double get screenHeight => _size.height;

  /// أبعاد أفقية: paddings جانبية، عرض عناصر، أحجام أيقونات.
  double w(double value) => screenWidth * (value / _kDesignWidth);

  /// أبعاد رأسية: ارتفاعات، paddings عمودية.
  double h(double value) => screenHeight * (value / _kDesignHeight);

  /// حجم الخط بيتحسب على العرض، بيعطي نتيجة أثبت من الطول عبر أجهزة مختلفة.
  double sp(double value) => w(value);
}