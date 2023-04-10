import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/database/cubit/cubit.dart';
import 'package:todo/database/cubit/states.dart';
import 'package:todo/ui/components/common.dart';

class ArchiveTasksScreen extends StatelessWidget {
  const ArchiveTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).archiveTasks;
          return tasksBuilder(tasks: tasks);
        });
  }
}
