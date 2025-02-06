import 'package:bloc/bloc.dart';
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
    "Home",
    "Home2",
    "Home3",
    "Home4",
  ];

  final List<IconData> icons = [
    Icons.home_filled,
    Icons.person,
    Icons.favorite,
    Icons.shopping_cart,
  ];
}
