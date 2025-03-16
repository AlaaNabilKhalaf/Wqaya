import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wqaya/Features/Chat/Presentation/Views/chat_welcome_view.dart';
import 'package:wqaya/Features/Home/Presentation/Views/home_view.dart';
import '../../../Profile/Presentation/Views/profile_view.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0); // Default to first tab

  void updateIndex(int index) {
    emit(index);
  }
  final List<Widget> pages = [
    const HomeView(),
    const ChatWelcomeView(),
    const ProfileView(),
  ];

  final List<String> labels = [
    'home'.tr(),
    'chat'.tr(),  // Chatbot at index 1
    'profile'.tr(),
  ];

  final List<IconData> icons = [
    Icons.home_filled,
    Icons.mark_unread_chat_alt_outlined,  // Chatbot icon
    Icons.person_outline,
  ];

  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
}
