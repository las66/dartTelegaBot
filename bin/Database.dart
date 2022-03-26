import 'package:dartTelegaBot/secrets.dart' as secret;
import 'package:postgres/postgres.dart';

class Database {
  // todo сделать пулл коннекшенов
  static final PostgreSQLConnection connection = PostgreSQLConnection(
      secret.host, secret.postgresPort, secret.postgresDatabaseName,
      username: secret.postgresUsername, password: secret.postgresPassword);

  static Future<void> init() async {
    await connection.open();
  }

  // todo Переделать на insert ... on duplicate key update
  static Future<int> countPlus1(String varName) async {
    var result = await connection.transaction((ctx) async {
      var varCount = await count(varName, ctx);
      if (varCount == null) {
        await createVarCount(varName, ctx);
        varCount = 0;
      }
      var newVarCount = varCount + 1;
      await ctx.query('UPDATE counter SET var_count = @varCount WHERE var_name = @varName',
          substitutionValues: {'varCount': newVarCount, 'varName': varName});
      return newVarCount;
    });
    return result;
  }

  static Future<int> countMinus1(String varName) async {
    var result = await connection.transaction((ctx) async {
      var varCount = await count(varName, ctx);
      if (varCount == null) {
        await createVarCount(varName, ctx);
        varCount = 0;
      }
      var newVarCount = varCount - 1;
      await ctx.query('UPDATE counter SET var_count = @varCount WHERE var_name = @varName',
          substitutionValues: {'varCount': newVarCount, 'varName': varName});
      return newVarCount;
    });
    return result;
  }

  static Future<int?> count(String varName, [PostgreSQLExecutionContext? conn]) async {
    conn ??= connection;
    List<List<dynamic>> results = await conn.query('SELECT var_count FROM counter WHERE var_name = @varName FOR UPDATE',
        substitutionValues: {'varName': varName});
    if (results.isEmpty) {
      return null;
    }
    return results[0][0];
  }

  static Future<void> createVarCount(String varName, [PostgreSQLExecutionContext? conn]) async {
    conn ??= connection;
    await conn.query('INSERT INTO counter (var_name) VALUES (@varName)', substitutionValues: {'varName': varName});
  }

  static Future<String> getMudrecAnek() async {
    List<List<dynamic>> results = await connection.query('SELECT anek FROM mudrec');
    if (results.isEmpty) {
      return 'Мудрец спит';
    } else {
      var aneks = results.toList();
      aneks.shuffle();
      return aneks[0][0];
    }
  }

  static Future<void> addMudrecAnek(String anek, int userId) async {
    await connection.query('INSERT INTO mudrec (anek, user_id) VALUES (@anek, @user_id)',
        substitutionValues: {'anek': anek, 'user_id': userId});
  }
}
