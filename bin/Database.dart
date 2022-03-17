import 'package:dartTelegaBot/secrets.dart' as secret;
import 'package:postgres/postgres.dart';

class Database {
  static final PostgreSQLConnection connection = PostgreSQLConnection(
      secret.host, secret.postgresPort, secret.postgresDatabaseName,
      username: secret.postgresUsername, password: secret.postgresPassword);

  static Future<void> init() async {
    await connection.open();
  }

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
    List<List<dynamic>> results = await conn
        .query('SELECT var_count FROM counter WHERE var_name = @varName FOR UPDATE', substitutionValues: {'varName': varName});
    if (results.isEmpty) {
      return null;
    }
    return results[0][0];
  }

  static Future<void> createVarCount(String varName, [PostgreSQLExecutionContext? conn]) async {
    conn ??= connection;
    await conn.query('INSERT INTO counter (var_name) VALUES (@varName)', substitutionValues: {'varName': varName});
  }
}
