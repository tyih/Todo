import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/database/cubit/states.dart';
import 'package:todo/ui/screens/add_tasks_screen.dart';
import 'package:todo/ui/screens/archive_tasks_screen.dart';
import 'package:todo/ui/screens/done_tasks_screen.dart';
import 'package:todo/ui/screens/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchiveTasksScreen(),
    const AddTasksScreen(),
  ];

  List<String> titles = ['任务', '已完成', '归档', '新增'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  /// 创建数据库
  createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      debugPrint('database created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        debugPrint('table Created');
      }).catchError((e) {
        debugPrint('create table error: ${e.toString()}');
      });
    }, onOpen: (database) {
      // 打开数据库，获取数据
      getDataFromDatabase(database);
      debugPrint('database opened');
    }).then((value) {
      // 数据库创建成功
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  /// 从数据库获取数据
  getDataFromDatabase(Database database) async {
    newTasks.clear();
    doneTasks.clear();
    archiveTasks.clear();
    emit(AppGetDatabaseLoadingSate());

    addToTasks(element) {
      if (element['status'] == 'new') {
        newTasks.add(element);
      } else if (element['status'] == 'done') {
        doneTasks.add(element);
      } else {
        archiveTasks.add(element);
      }
    }

    database.rawQuery('SELECT * FROM tasks').then((value) {
      // 将数据加入列表
      value.forEach(addToTasks);
      emit(AppGetDatabaseState());
    });
  }

  /// 插入到数据库
  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES ("$title", "$date", "$time", "new")')
          .then((value) {
        debugPrint('$value Inserted Success');
        emit(AppInsertDatabaseSate());

        getDataFromDatabase(database);
      }).catchError((e) {
        debugPrint('Insert database Error: ${e.toString()}');
      });
    });
  }

  /// 更新数据库
  void updateToDatabase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        [status, '$id']).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseSate());
    });
  }

  /// 从数据库删除
  void deleteFromDatabase({required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', ['$id']).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseSate());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetSate());
  }

  String date = '';
  changeDateState({required String date}) {
    date = date;
    emit(AppChangeDateState());
  }
}
