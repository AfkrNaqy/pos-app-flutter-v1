import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  static TextStyle get title => GoogleFonts.textMeOne(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 0, 0, 0),
  );
  static TextStyle get subTitle => GoogleFonts.textMeOne(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 0, 0, 0),
  );
  static TextStyle get body => GoogleFonts.textMeOne(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color.fromARGB(255, 0, 0, 0),
  );
  static TextStyle get caption => GoogleFonts.textMeOne(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: Color.fromARGB(255, 0, 0, 0),
  );
}
