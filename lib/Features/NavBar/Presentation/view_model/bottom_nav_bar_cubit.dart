import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wqaya/Features/Home/Presentation/Views/home_view.dart';
import 'package:wqaya/Features/NavBar/Presentation/Views/nav_bar_view.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0); // Default to first tab

  void updateIndex(int index) {
    emit(index);
  }
  final List<Widget> pages = [
    const HomeView(),
    ProfileView(),
    FavoritesView(),
    CartView(),
  ];
  final List<String> labels =[
    "home".tr(),
    "messages".tr(),
    "notifications".tr(),
    "myAcc".tr(),
  ];

  final List<IconData> icons = [
    Icons.home_filled,
    Icons.message_outlined,
    Icons.notifications_none_outlined,
    Icons.person_outline,
  ];
}
