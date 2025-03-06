import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wqaya/Features/Home/Presentation/Views/home_view.dart';
import 'package:wqaya/Features/NavBar/Presentation/Views/nav_bar_view.dart';

import '../../../Profile/Presentation/Views/profile_view.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0); // Default to first tab

  void updateIndex(int index) {
    emit(index);
  }
  final List<Widget> pages = [
    const HomeView(),
    const BotView(),
    const ProfileView(),

  ];
  final List<String> labels =[
    'home'.tr(),
    'chat'.tr(),
    'profile'.tr(),
  ];

  final List<IconData> icons = [
    Icons.home_filled,
    Icons.maps_ugc,
    Icons.person_outline,
  ];
}
