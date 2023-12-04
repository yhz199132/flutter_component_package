import 'package:flutter/material.dart';
import 'package:mysql_utils/mysql_utils.dart';

/// 作者：袁汉章 on 2023年10月30日 18:30
/// 邮箱：yhz199132@163.com
class MySqlPage extends StatefulWidget {
  const MySqlPage({super.key});

  @override
  State<MySqlPage> createState() => _MySqlPageState();
}

class _MySqlPageState extends State<MySqlPage> {
  MysqlUtils? db;
  String data = '';
  @override
  void initState() {
    initSQL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              query();
            },
            child: const Text('查询数据'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data),
          )
        ],
      ),
    );
  }

  void initSQL() {
    db = MysqlUtils(
        settings: {
          'host': '127.0.0.1',
          'port': 3306,
          'user': 'root',
          'password': '199132',
          'db': 'account',
          'maxConnections': 10,
          'secure': false,
          'prefix': '',
          'pool': false,
          'collation': 'utf8mb4_general_ci',
          'sqlEscape': true,
        },
        errorLog: (error) {
          print(error);
        },
        sqlLog: (sql) {
          print(sql);
        },
        connectInit: (db1) async {
          print('whenComplete');
        });
  }

  void query() async {
    var row = await db?.query('select * from account where organization_id=:id',
        values: {'id': 1});
    print("查询结果${row?.rows}");
    setState(() {
      data = "查询结果${row?.rows}";
    });
  }
}
