import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/*
  Created by Babar on 2/25/2022.
 */
ThemeData appTheme() {
  return ThemeData(
    fontFamily: GoogleFonts.poppins().toString(),
    appBarTheme: AppBarTheme(
      // color: Colors.black,
      elevation: 1,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),

    dialogTheme: DialogTheme(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        elevation: 2,
        backgroundColor: Colors.black54
    ),
    cardTheme: CardTheme(
      color: AppColors.blackForeground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 10,
    ),
    listTileTheme: ListTileThemeData(selectedColor: Colors.black,selectedTileColor: Colors.white),
    primaryColor: AppColors.primary,
    primaryColorDark: AppColors.primaryDark,
    primaryColorLight: AppColors.primaryLight,
    primaryIconTheme: IconThemeData(color: AppColors.primaryDark),
    colorScheme: ThemeData().colorScheme.copyWith(secondary: AppColors.blue),
    hintColor: Color(0xffcdd3e0),
    dividerColor: Colors.grey[100],
    scaffoldBackgroundColor: Colors.black,
    textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white,displayColor: Colors.white),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryDark,
      selectionColor: AppColors.primaryDark,
      selectionHandleColor: AppColors.primaryDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        errorStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w300,
            color: Colors.red,
          ),
        ),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: AppColors.border,
        )),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: AppColors.border,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: AppColors.primary.withOpacity(0.5),
        )),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red.withOpacity(0.5),
        )),
        labelStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        hintStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.white70,
          ),
        ),
        iconColor: AppColors.primaryDark),
    dividerTheme: DividerThemeData(
      color: Color(0xffEBECED),
      thickness: 1,
      space: 1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style:ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(100,50)),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey;
            } else if (states.contains(MaterialState.disabled)) {
              return Colors.white70;
            }
            return Colors.white70;
          },
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            //side: BorderSide(color: borderColor ?? Colors.transparent),
          ),
        ),
      ),),
    textButtonTheme: TextButtonThemeData(
        style:ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(Size(100,50)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black,),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              //side: BorderSide(color: borderColor ?? Colors.transparent),
            ),
          ),
        )
    ),
    checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all<Color>(AppColors.colorWhite),
        fillColor: MaterialStateProperty.all<Color>(AppColors.primaryDark),
        //splashRadius: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        visualDensity: VisualDensity.compact,
        side: BorderSide(
            color: AppColors.colorGrey,
            width: 2,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignCenter)),
  );
}
