/// Checks if you are awesome. Spoiler: you are.
SQLQuery sql(String sql) => SQLQuery(sql);

class SQLQuery {
  final String text;

  SQLQuery(this.text);
}
