import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:todo/database/cubit/cubit.dart';
import 'package:todo/database/cubit/states.dart';
import 'package:todo/style/colors.dart';
import 'package:todo/ui/components/common.dart';

class AddTasksScreen extends StatefulWidget {
  const AddTasksScreen({super.key});

  @override
  State<AddTasksScreen> createState() => _AddTasksScreenState();
}

class _AddTasksScreenState extends State<AddTasksScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  String? date;
  String? time;

  _showTimePicker() async {
    showCustomTimePicker(
            context: context,
            onFailValidation: (context) => debugPrint('Unavailable selection'),
            initialTime: const TimeOfDay(hour: 2, minute: 0))
        .then((times) {
      setState(() {
        time = times!.format(context);
        timeController.text = time!;
        debugPrint('time is: $time');
      });
    }).catchError((e) {
      debugPrint('error: $e');
    });
  }

  _showDataPicker() async {
    var picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2024));
    if (picker == null) {
      return;
    }

    setState(() {
      var newDate = DateFormat('EEE, d MMM').format(picker!);
      date = newDate.toString();
      dateController.text = date!;
      debugPrint('date is: $date');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: Text(
                  '管理任务',
                  style: textStyle(
                      color: seconderyColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: defaultFormField(
                      controller: titleController,
                      type: TextInputType.text,
                      label: '任务名称',
                      prefix: Icons.title)),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showTimePicker();
                  });
                },
                child: defaultContainer(
                    title: time ?? '任务时间', icon: Icons.watch_later_rounded),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showDataPicker();
                  });
                },
                child: defaultContainer(
                    title: date ?? '任务日期', icon: Icons.date_range),
              ),
              const SizedBox(height: 50.0),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                color: mainColor,
                child: MaterialButton(
                  height: 50,
                  onPressed: () {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  },
                  child: Text('新增任务',
                      style:
                          textStyle(color: white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          );
        });
  }
}
