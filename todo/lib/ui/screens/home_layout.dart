import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/database/cubit/cubit.dart';
import 'package:todo/database/cubit/states.dart';
import 'package:todo/style/colors.dart';
import 'package:todo/ui/components/main_app_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return SafeArea(
                child: Scaffold(
              key: scaffoldKey,
              appBar: MainAppBar(title: cubit.titles[cubit.currentIndex]),
              body: ConditionalBuilder(
                  condition: state is! AppGetDatabaseLoadingSate,
                  builder: (context) => cubit.screens[cubit.currentIndex],
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator())),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: seconderyColor,
                currentIndex: cubit.currentIndex,
                onTap: (value) {
                  cubit.changeIndex(value);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.task), label: cubit.titles[0]),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.task_alt_rounded),
                      label: cubit.titles[1]),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.archive_outlined),
                      label: cubit.titles[2]),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.add_circle_rounded),
                      label: cubit.titles[3])
                ],
              ),
            ));
          },
          listener: (context, state) {}),
    );
  }
}
