abstract class AppStates {}

/// 初始化
class AppInitialState extends AppStates {}

/// 底部导航变化
class AppChangeBottomNavBarState extends AppStates {}

/// 底部弹框
class AppChangeBottomSheetSate extends AppStates {}

/// 创建数据库
class AppCreateDatabaseState extends AppStates {}

/// 数据库加载中
class AppGetDatabaseLoadingSate extends AppStates {}

/// 获取数据库
class AppGetDatabaseState extends AppStates {}

/// 插入数据库
class AppInsertDatabaseSate extends AppStates {}

/// 更新数据库
class AppUpdateDatabaseSate extends AppStates {}

/// 删除数据库
class AppDeleteDatabaseSate extends AppStates {}

/// 改变数据
class AppChangeDateState extends AppStates {}
