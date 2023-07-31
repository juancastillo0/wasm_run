import 'package:typesql/typesql.dart';
import 'dart:convert' show jsonDecode;

class UsersUpdate with BaseDataClass implements SqlUpdateModel<Users> {
  final int? id;
  final String? name;
  const UsersUpdate({
    this.id,
    this.name,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('UsersUpdate', {
        'id': id,
        'name': name,
      });
  factory UsersUpdate.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['id', 'name'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
        final name,
      ] =>
        UsersUpdate(
          id: id == null ? null : id as int,
          name: name == null ? null : name as String,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for UsersUpdate.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'users';
}

typedef UsersInsert = Users;

class Users
    with BaseDataClass
    implements SqlInsertModel<Users>, SqlReturnModel {
  final int id;
  final String name;
  const Users({
    required this.id,
    required this.name,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('users', {
        'id': id,
        'name': name,
      });
  factory Users.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['id', 'name'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
        final name,
      ] =>
        Users(
          id: id as int,
          name: name as String,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for Users.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'users';
}

class UsersKeyId
    with BaseDataClass
    implements SqlUniqueKeyModel<Users, UsersUpdate> {
  final int id;
  const UsersKeyId({
    required this.id,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('UsersKeyId', {
        'id': id,
      });
  factory UsersKeyId.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['id'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
      ] =>
        UsersKeyId(
          id: id as int,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for UsersKeyId.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'users';
}

class TopicsUpdate with BaseDataClass implements SqlUpdateModel<Topics> {
  final String? code;
  final Option<int>? priority;
  final Option<String>? description;
  const TopicsUpdate({
    this.code,
    this.priority,
    this.description,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('TopicsUpdate', {
        'code': code,
        'priority': priority,
        'description': description,
      });
  factory TopicsUpdate.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['code', 'priority', 'description']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final code,
        final priority,
        final description,
      ] =>
        TopicsUpdate(
          code: code == null ? null : code as String,
          priority: priority == null
              ? null
              : Option.fromJson(priority, (priority) => priority as int),
          description: description == null
              ? null
              : Option.fromJson(
                  description, (description) => description as String),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for TopicsUpdate.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'topics';
}

typedef TopicsInsert = Topics;

class Topics
    with BaseDataClass
    implements SqlInsertModel<Topics>, SqlReturnModel {
  final String code;
  final int? priority;
  final String? description;
  const Topics({
    required this.code,
    this.priority,
    this.description,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('topics', {
        'code': code,
        'priority': priority,
        'description': description,
      });
  factory Topics.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['code', 'priority', 'description']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final code,
        final priority,
        final description,
      ] =>
        Topics(
          code: code as String,
          priority: priority == null ? null : priority as int,
          description: description == null ? null : description as String,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for Topics.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'topics';
}

class TopicsKeyCode
    with BaseDataClass
    implements SqlUniqueKeyModel<Topics, TopicsUpdate> {
  final String code;
  const TopicsKeyCode({
    required this.code,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('TopicsKeyCode', {
        'code': code,
      });
  factory TopicsKeyCode.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['code'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final code,
      ] =>
        TopicsKeyCode(
          code: code as String,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for TopicsKeyCode.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'topics';
}

class PostsUpdate with BaseDataClass implements SqlUpdateModel<Posts> {
  final int? id;
  final int? userId;
  final String? title;
  final Option<String>? subtitle;
  final String? body;
  final DateTime? createdAt;
  const PostsUpdate({
    this.id,
    this.userId,
    this.title,
    this.subtitle,
    this.body,
    this.createdAt,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('PostsUpdate', {
        'id': id,
        'user_id': userId,
        'title': title,
        'subtitle': subtitle,
        'body': body,
        'created_at': createdAt,
      });
  factory PostsUpdate.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['id', 'user_id', 'title', 'subtitle', 'body', 'created_at']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
        final userId,
        final title,
        final subtitle,
        final body,
        final createdAt,
      ] =>
        PostsUpdate(
          id: id == null ? null : id as int,
          userId: userId == null ? null : userId as int,
          title: title == null ? null : title as String,
          subtitle: subtitle == null
              ? null
              : Option.fromJson(subtitle, (subtitle) => subtitle as String),
          body: body == null ? null : body as String,
          createdAt: createdAt == null
              ? null
              : createdAt is int
                  ? DateTime.fromMicrosecondsSinceEpoch(createdAt)
                  : DateTime.parse(createdAt as String),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for PostsUpdate.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'posts';
}

class PostsInsert with BaseDataClass implements SqlInsertModel<Posts> {
  final int id;
  final int userId;
  final String title;
  final String? subtitle;
  final String body;
  final DateTime? createdAt;
  const PostsInsert({
    required this.id,
    required this.userId,
    required this.title,
    this.subtitle,
    required this.body,
    this.createdAt,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('PostsInsert', {
        'id': id,
        'user_id': userId,
        'title': title,
        'subtitle': subtitle,
        'body': body,
        'created_at': createdAt,
      });
  factory PostsInsert.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['id', 'user_id', 'title', 'subtitle', 'body', 'created_at']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
        final userId,
        final title,
        final subtitle,
        final body,
        final createdAt,
      ] =>
        PostsInsert(
          id: id as int,
          userId: userId as int,
          title: title as String,
          subtitle: subtitle == null ? null : subtitle as String,
          body: body as String,
          createdAt: createdAt == null
              ? null
              : createdAt is int
                  ? DateTime.fromMicrosecondsSinceEpoch(createdAt)
                  : DateTime.parse(createdAt as String),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for PostsInsert.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'posts';
}

class Posts with BaseDataClass implements SqlReturnModel {
  final int id;
  final int userId;
  final String title;
  final String? subtitle;
  final String body;
  final DateTime createdAt;
  const Posts({
    required this.id,
    required this.userId,
    required this.title,
    this.subtitle,
    required this.body,
    required this.createdAt,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('posts', {
        'id': id,
        'user_id': userId,
        'title': title,
        'subtitle': subtitle,
        'body': body,
        'created_at': createdAt,
      });
  factory Posts.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['id', 'user_id', 'title', 'subtitle', 'body', 'created_at']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
        final userId,
        final title,
        final subtitle,
        final body,
        final createdAt,
      ] =>
        Posts(
          id: id as int,
          userId: userId as int,
          title: title as String,
          subtitle: subtitle == null ? null : subtitle as String,
          body: body as String,
          createdAt: createdAt is int
              ? DateTime.fromMicrosecondsSinceEpoch(createdAt)
              : DateTime.parse(createdAt as String),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for Posts.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'posts';
}

class PostsKeyId
    with BaseDataClass
    implements SqlUniqueKeyModel<Posts, PostsUpdate> {
  final int id;
  const PostsKeyId({
    required this.id,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('PostsKeyId', {
        'id': id,
      });
  factory PostsKeyId.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['id'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
      ] =>
        PostsKeyId(
          id: id as int,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for PostsKeyId.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'posts';
}

typedef PostsTopicsUpdate = PostsTopics;
typedef PostsTopicsInsert = PostsTopics;

class PostsTopics
    with BaseDataClass
    implements
        SqlInsertModel<PostsTopics>,
        SqlUpdateModel<PostsTopics>,
        SqlReturnModel {
  final String? topicCode;
  final int? postId;
  const PostsTopics({
    this.topicCode,
    this.postId,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('posts_topics', {
        'topic_code': topicCode,
        'post_id': postId,
      });
  factory PostsTopics.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['topic_code', 'post_id']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final topicCode,
        final postId,
      ] =>
        PostsTopics(
          topicCode: topicCode == null ? null : topicCode as String,
          postId: postId == null ? null : postId as int,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for PostsTopics.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'posts_topics';
}

class PostsTopicsKeyTopicCodePostId
    with BaseDataClass
    implements SqlUniqueKeyModel<PostsTopics, PostsTopics> {
  final String? topicCode;
  final int? postId;
  const PostsTopicsKeyTopicCodePostId({
    this.topicCode,
    this.postId,
  });
  @override
  DataClassProps get dataClassProps =>
      DataClassProps('PostsTopicsKeyTopicCodePostId', {
        'topic_code': topicCode,
        'post_id': postId,
      });
  factory PostsTopicsKeyTopicCodePostId.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['topic_code', 'post_id']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final topicCode,
        final postId,
      ] =>
        PostsTopicsKeyTopicCodePostId(
          topicCode: topicCode == null ? null : topicCode as String,
          postId: postId == null ? null : postId as int,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for PostsTopicsKeyTopicCodePostId.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'posts_topics';
}

class PostsWithTopicsJsonUpdate
    with BaseDataClass
    implements SqlUpdateModel<PostsWithTopicsJson> {
  final int? postsId;
  final int? postsUserId;
  final PostsWithTopicsJsonUpdateJsonValue? jsonValue;
  const PostsWithTopicsJsonUpdate({
    this.postsId,
    this.postsUserId,
    this.jsonValue,
  });
  @override
  DataClassProps get dataClassProps =>
      DataClassProps('PostsWithTopicsJsonUpdate', {
        'posts.id': postsId,
        'posts.user_id': postsUserId,
        'json_value': jsonValue,
      });
  factory PostsWithTopicsJsonUpdate.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['posts.id', 'posts.user_id', 'json_value']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final postsId,
        final postsUserId,
        final jsonValue,
      ] =>
        PostsWithTopicsJsonUpdate(
          postsId: postsId == null ? null : postsId as int,
          postsUserId: postsUserId == null ? null : postsUserId as int,
          jsonValue: jsonValue == null
              ? null
              : PostsWithTopicsJsonUpdateJsonValue.fromJson(jsonValue),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for PostsWithTopicsJsonUpdate.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'posts_with_topics_json';
}

class PostsWithTopicsJsonUpdateJsonValue with BaseDataClass {
  final int id;
  final int userId;
  final String title;
  final String? subtitle;
  final String body;
  final DateTime createdAt;
  final List<String?> topics;
  const PostsWithTopicsJsonUpdateJsonValue({
    required this.id,
    required this.userId,
    required this.title,
    this.subtitle,
    required this.body,
    required this.createdAt,
    required this.topics,
  });
  @override
  DataClassProps get dataClassProps =>
      DataClassProps('PostsWithTopicsJsonUpdateJsonValue', {
        'id': id,
        'user_id': userId,
        'title': title,
        'subtitle': subtitle,
        'body': body,
        'created_at': createdAt,
        'topics': topics,
      });
  factory PostsWithTopicsJsonUpdateJsonValue.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const [
            'id',
            'user_id',
            'title',
            'subtitle',
            'body',
            'created_at',
            'topics'
          ].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
        final userId,
        final title,
        final subtitle,
        final body,
        final createdAt,
        final topics,
      ] =>
        PostsWithTopicsJsonUpdateJsonValue(
          id: id as int,
          userId: userId as int,
          title: title as String,
          subtitle: subtitle == null ? null : subtitle as String,
          body: body as String,
          createdAt: createdAt is int
              ? DateTime.fromMicrosecondsSinceEpoch(createdAt)
              : DateTime.parse(createdAt as String),
          topics: (topics as Iterable)
              .map((item) => item == null ? null : item as String)
              .toList(),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for PostsWithTopicsJsonUpdateJsonValue.fromJson ${obj.runtimeType}'),
    };
  }
}

typedef PostsWithTopicsJsonInsert = PostsWithTopicsJson;

class PostsWithTopicsJson
    with BaseDataClass
    implements SqlInsertModel<PostsWithTopicsJson>, SqlReturnModel {
  final int postsId;
  final int postsUserId;
  final PostsWithTopicsJsonJsonValue jsonValue;
  const PostsWithTopicsJson({
    required this.postsId,
    required this.postsUserId,
    required this.jsonValue,
  });
  @override
  DataClassProps get dataClassProps =>
      DataClassProps('posts_with_topics_json', {
        'posts.id': postsId,
        'posts.user_id': postsUserId,
        'json_value': jsonValue,
      });
  factory PostsWithTopicsJson.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['posts.id', 'posts.user_id', 'json_value']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final postsId,
        final postsUserId,
        final jsonValue,
      ] =>
        PostsWithTopicsJson(
          postsId: postsId as int,
          postsUserId: postsUserId as int,
          jsonValue: PostsWithTopicsJsonJsonValue.fromJson(jsonValue),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for PostsWithTopicsJson.fromJson ${obj.runtimeType}'),
    };
  }
  @override
  String get table => 'posts_with_topics_json';
}

class PostsWithTopicsJsonJsonValue with BaseDataClass {
  final int id;
  final int userId;
  final String title;
  final String? subtitle;
  final String body;
  final DateTime createdAt;
  final List<String?> topics;
  const PostsWithTopicsJsonJsonValue({
    required this.id,
    required this.userId,
    required this.title,
    this.subtitle,
    required this.body,
    required this.createdAt,
    required this.topics,
  });
  @override
  DataClassProps get dataClassProps =>
      DataClassProps('PostsWithTopicsJsonJsonValue', {
        'id': id,
        'user_id': userId,
        'title': title,
        'subtitle': subtitle,
        'body': body,
        'created_at': createdAt,
        'topics': topics,
      });
  factory PostsWithTopicsJsonJsonValue.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const [
            'id',
            'user_id',
            'title',
            'subtitle',
            'body',
            'created_at',
            'topics'
          ].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
        final userId,
        final title,
        final subtitle,
        final body,
        final createdAt,
        final topics,
      ] =>
        PostsWithTopicsJsonJsonValue(
          id: id as int,
          userId: userId as int,
          title: title as String,
          subtitle: subtitle == null ? null : subtitle as String,
          body: body as String,
          createdAt: createdAt is int
              ? DateTime.fromMicrosecondsSinceEpoch(createdAt)
              : DateTime.parse(createdAt as String),
          topics: (topics as Iterable)
              .map((item) => item == null ? null : item as String)
              .toList(),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for PostsWithTopicsJsonJsonValue.fromJson ${obj.runtimeType}'),
    };
  }
}

class QuerySelectUsers1 with BaseDataClass {
  final int usersId;
  final String usersName;
  const QuerySelectUsers1({
    required this.usersId,
    required this.usersName,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('QuerySelectUsers1', {
        'users.id': usersId,
        'users.name': usersName,
      });
  factory QuerySelectUsers1.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['users.id', 'users.name']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final usersId,
        final usersName,
      ] =>
        QuerySelectUsers1(
          usersId: usersId as int,
          usersName: usersName as String,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for QuerySelectUsers1.fromJson ${obj.runtimeType}'),
    };
  }
}

class QuerySelectUsers2 with BaseDataClass {
  final int usersId;
  final String usersName;
  const QuerySelectUsers2({
    required this.usersId,
    required this.usersName,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('QuerySelectUsers2', {
        'users.id': usersId,
        'users.name': usersName,
      });
  factory QuerySelectUsers2.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['users.id', 'users.name']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final usersId,
        final usersName,
      ] =>
        QuerySelectUsers2(
          usersId: usersId as int,
          usersName: usersName as String,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for QuerySelectUsers2.fromJson ${obj.runtimeType}'),
    };
  }
}

class QuerySelectUsers2Args with BaseDataClass {
  final int minId;
  const QuerySelectUsers2Args({
    required this.minId,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('QuerySelectUsers2Args', {
        'minId': minId,
      });
  factory QuerySelectUsers2Args.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['minId'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final minId,
      ] =>
        QuerySelectUsers2Args(
          minId: minId as int,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for QuerySelectUsers2Args.fromJson ${obj.runtimeType}'),
    };
  }
}

class InsertUsers1Args with BaseDataClass {
  final String c;
  const InsertUsers1Args({
    required this.c,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('InsertUsers1Args', {
        'c': c,
      });
  factory InsertUsers1Args.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['c'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final c,
      ] =>
        InsertUsers1Args(
          c: c as String,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for InsertUsers1Args.fromJson ${obj.runtimeType}'),
    };
  }
}

class UpdateUserName with BaseDataClass {
  final int usersId;
  final String usersName;
  const UpdateUserName({
    required this.usersId,
    required this.usersName,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('UpdateUserName', {
        'users.id': usersId,
        'users.name': usersName,
      });
  factory UpdateUserName.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['users.id', 'users.name']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final usersId,
        final usersName,
      ] =>
        UpdateUserName(
          usersId: usersId as int,
          usersName: usersName as String,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for UpdateUserName.fromJson ${obj.runtimeType}'),
    };
  }
}

class UpdateUserNameArgs with BaseDataClass {
  final String name;
  final int id;
  const UpdateUserNameArgs({
    required this.name,
    required this.id,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('UpdateUserNameArgs', {
        'name': name,
        'id': id,
      });
  factory UpdateUserNameArgs.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['name', 'id'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final name,
        final id,
      ] =>
        UpdateUserNameArgs(
          name: name as String,
          id: id as int,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for UpdateUserNameArgs.fromJson ${obj.runtimeType}'),
    };
  }
}

class DeleteUsersByIdArgs with BaseDataClass {
  final List<dynamic> ids;
  const DeleteUsersByIdArgs({
    required this.ids,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('DeleteUsersByIdArgs', {
        'ids': ids,
      });
  factory DeleteUsersByIdArgs.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['ids'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final ids,
      ] =>
        DeleteUsersByIdArgs(
          ids: (ids as Iterable).map((item) => item).toList(),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for DeleteUsersByIdArgs.fromJson ${obj.runtimeType}'),
    };
  }
}

class QuerySelectUsers3 with BaseDataClass {
  final int usersId;
  final String userName;
  final String? ptTopicCode;
  final int postsId;
  final int postsUserId;
  final String postsTitle;
  final String? postsSubtitle;
  final String postsBody;
  final DateTime postsCreatedAt;
  const QuerySelectUsers3({
    required this.usersId,
    required this.userName,
    this.ptTopicCode,
    required this.postsId,
    required this.postsUserId,
    required this.postsTitle,
    this.postsSubtitle,
    required this.postsBody,
    required this.postsCreatedAt,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('QuerySelectUsers3', {
        'users.id': usersId,
        'user_name': userName,
        'pt.topic_code': ptTopicCode,
        'posts.id': postsId,
        'posts.user_id': postsUserId,
        'posts.title': postsTitle,
        'posts.subtitle': postsSubtitle,
        'posts.body': postsBody,
        'posts.created_at': postsCreatedAt,
      });
  factory QuerySelectUsers3.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const [
            'users.id',
            'user_name',
            'pt.topic_code',
            'posts.id',
            'posts.user_id',
            'posts.title',
            'posts.subtitle',
            'posts.body',
            'posts.created_at'
          ].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final usersId,
        final userName,
        final ptTopicCode,
        final postsId,
        final postsUserId,
        final postsTitle,
        final postsSubtitle,
        final postsBody,
        final postsCreatedAt,
      ] =>
        QuerySelectUsers3(
          usersId: usersId as int,
          userName: userName as String,
          ptTopicCode: ptTopicCode == null ? null : ptTopicCode as String,
          postsId: postsId as int,
          postsUserId: postsUserId as int,
          postsTitle: postsTitle as String,
          postsSubtitle: postsSubtitle == null ? null : postsSubtitle as String,
          postsBody: postsBody as String,
          postsCreatedAt: postsCreatedAt is int
              ? DateTime.fromMicrosecondsSinceEpoch(postsCreatedAt)
              : DateTime.parse(postsCreatedAt as String),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for QuerySelectUsers3.fromJson ${obj.runtimeType}'),
    };
  }
}

class UsersWithPosts with BaseDataClass {
  final int usersId;
  final String userName;
  final List<UsersWithPostsPostsItem> posts;
  const UsersWithPosts({
    required this.usersId,
    required this.userName,
    required this.posts,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('UsersWithPosts', {
        'users.id': usersId,
        'user_name': userName,
        'posts': posts,
      });
  factory UsersWithPosts.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['users.id', 'user_name', 'posts']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final usersId,
        final userName,
        final posts,
      ] =>
        UsersWithPosts(
          usersId: usersId as int,
          userName: userName as String,
          posts: (posts as Iterable)
              .map((item) => UsersWithPostsPostsItem.fromJson(item))
              .toList(),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for UsersWithPosts.fromJson ${obj.runtimeType}'),
    };
  }
}

class UsersWithPostsPostsItem with BaseDataClass {
  final int id;
  final int userId;
  final String title;
  final String? subtitle;
  final String body;
  final DateTime createdAt;
  final List<String?> topics;
  const UsersWithPostsPostsItem({
    required this.id,
    required this.userId,
    required this.title,
    this.subtitle,
    required this.body,
    required this.createdAt,
    required this.topics,
  });
  @override
  DataClassProps get dataClassProps =>
      DataClassProps('UsersWithPostsPostsItem', {
        'id': id,
        'user_id': userId,
        'title': title,
        'subtitle': subtitle,
        'body': body,
        'created_at': createdAt,
        'topics': topics,
      });
  factory UsersWithPostsPostsItem.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const [
            'id',
            'user_id',
            'title',
            'subtitle',
            'body',
            'created_at',
            'topics'
          ].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
        final userId,
        final title,
        final subtitle,
        final body,
        final createdAt,
        final topics,
      ] =>
        UsersWithPostsPostsItem(
          id: id as int,
          userId: userId as int,
          title: title as String,
          subtitle: subtitle == null ? null : subtitle as String,
          body: body as String,
          createdAt: createdAt is int
              ? DateTime.fromMicrosecondsSinceEpoch(createdAt)
              : DateTime.parse(createdAt as String),
          topics: (topics as Iterable)
              .map((item) => item == null ? null : item as String)
              .toList(),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for UsersWithPostsPostsItem.fromJson ${obj.runtimeType}'),
    };
  }
}

class UsersWithPostsJSON with BaseDataClass {
  final int usersId;
  final String userName;
  final List<UsersWithPostsJSONPostsItem> posts;
  const UsersWithPostsJSON({
    required this.usersId,
    required this.userName,
    required this.posts,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('UsersWithPostsJSON', {
        'users.id': usersId,
        'user_name': userName,
        'posts': posts,
      });
  factory UsersWithPostsJSON.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['users.id', 'user_name', 'posts']
            .map((f) => obj[f])
            .toList(growable: false)
        : obj;
    return switch (list) {
      [
        final usersId,
        final userName,
        final posts,
      ] =>
        UsersWithPostsJSON(
          usersId: usersId as int,
          userName: userName as String,
          posts: (posts as Iterable)
              .map((item) => UsersWithPostsJSONPostsItem.fromJson(item))
              .toList(),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for UsersWithPostsJSON.fromJson ${obj.runtimeType}'),
    };
  }
}

class UsersWithPostsJSONPostsItem with BaseDataClass {
  final int id;
  final int userId;
  final String title;
  final String? subtitle;
  final String body;
  final DateTime createdAt;
  final List<String?> topics;
  const UsersWithPostsJSONPostsItem({
    required this.id,
    required this.userId,
    required this.title,
    this.subtitle,
    required this.body,
    required this.createdAt,
    required this.topics,
  });
  @override
  DataClassProps get dataClassProps =>
      DataClassProps('UsersWithPostsJSONPostsItem', {
        'id': id,
        'user_id': userId,
        'title': title,
        'subtitle': subtitle,
        'body': body,
        'created_at': createdAt,
        'topics': topics,
      });
  factory UsersWithPostsJSONPostsItem.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const [
            'id',
            'user_id',
            'title',
            'subtitle',
            'body',
            'created_at',
            'topics'
          ].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
        final userId,
        final title,
        final subtitle,
        final body,
        final createdAt,
        final topics,
      ] =>
        UsersWithPostsJSONPostsItem(
          id: id as int,
          userId: userId as int,
          title: title as String,
          subtitle: subtitle == null ? null : subtitle as String,
          body: body as String,
          createdAt: createdAt is int
              ? DateTime.fromMicrosecondsSinceEpoch(createdAt)
              : DateTime.parse(createdAt as String),
          topics: (topics as Iterable)
              .map((item) => item == null ? null : item as String)
              .toList(),
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for UsersWithPostsJSONPostsItem.fromJson ${obj.runtimeType}'),
    };
  }
}

class DeleteUsers1 with BaseDataClass {
  final int id;
  final String name;
  const DeleteUsers1({
    required this.id,
    required this.name,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('DeleteUsers1', {
        'id': id,
        'name': name,
      });
  factory DeleteUsers1.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['id', 'name'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final id,
        final name,
      ] =>
        DeleteUsers1(
          id: id as int,
          name: name as String,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for DeleteUsers1.fromJson ${obj.runtimeType}'),
    };
  }
}

class DeleteUsers1Args with BaseDataClass {
  final int arg0;
  const DeleteUsers1Args({
    required this.arg0,
  });
  @override
  DataClassProps get dataClassProps => DataClassProps('DeleteUsers1Args', {
        'arg0': arg0,
      });
  factory DeleteUsers1Args.fromJson(Object? obj_) {
    final obj = obj_ is String ? jsonDecode(obj_) : obj_;
    final list = obj is Map
        ? const ['arg0'].map((f) => obj[f]).toList(growable: false)
        : obj;
    return switch (list) {
      [
        final arg0,
      ] =>
        DeleteUsers1Args(
          arg0: arg0 as int,
        ),
      _ => throw Exception(
          'Invalid JSON or SQL Row for DeleteUsers1Args.fromJson ${obj.runtimeType}'),
    };
  }
}

class ExampleQueries {
  final SqlExecutor executor;
  final SqlTypedExecutor typedExecutor;

  ExampleQueries(this.executor)
      : typedExecutor = SqlTypedExecutor(executor, types: tableSpecs);

  static const Map<Type, SqlTypeData> tableSpecs = {
    Users: SqlTypeData<Users, UsersUpdate>.value(
        'users',
        [
          (name: 'id', type: BTypeInteger(), hasDefault: false),
          (name: 'name', type: BTypeString(), hasDefault: false)
        ],
        Users.fromJson),
    Topics: SqlTypeData<Topics, TopicsUpdate>.value(
        'topics',
        [
          (name: 'code', type: BTypeString(), hasDefault: false),
          (name: 'priority', type: BTypeInteger(), hasDefault: true),
          (name: 'description', type: BTypeString(), hasDefault: false)
        ],
        Topics.fromJson),
    Posts: SqlTypeData<Posts, PostsUpdate>.value(
        'posts',
        [
          (name: 'id', type: BTypeInteger(), hasDefault: false),
          (name: 'user_id', type: BTypeInteger(), hasDefault: false),
          (name: 'title', type: BTypeString(), hasDefault: false),
          (name: 'subtitle', type: BTypeString(), hasDefault: false),
          (name: 'body', type: BTypeString(), hasDefault: false),
          (name: 'created_at', type: BTypeDateTime(), hasDefault: true)
        ],
        Posts.fromJson),
    PostsTopics: SqlTypeData<PostsTopics, PostsTopics>.value(
        'posts_topics',
        [
          (name: 'topic_code', type: BTypeString(), hasDefault: false),
          (name: 'post_id', type: BTypeInteger(), hasDefault: false)
        ],
        PostsTopics.fromJson),
    PostsWithTopicsJson:
        SqlTypeData<PostsWithTopicsJson, PostsWithTopicsJsonUpdate>.value(
            'posts_with_topics_json',
            [
              (name: 'posts.id', type: BTypeInteger(), hasDefault: false),
              (name: 'posts.user_id', type: BTypeInteger(), hasDefault: false),
              (
                name: 'json_value',
                type: BTypeJsonObject({
                  'id': BTypeInteger(),
                  'user_id': BTypeInteger(),
                  'title': BTypeString(),
                  'subtitle': BTypeNullable(BTypeString()),
                  'body': BTypeString(),
                  'created_at': BTypeDateTime(),
                  'topics': BTypeJsonArray(BTypeNullable(BTypeString()))
                }),
                hasDefault: false
              )
            ],
            PostsWithTopicsJson.fromJson),
  };
  late final SqlTypedController<Users, UsersUpdate> usersController =
      SqlTypedController(typedExecutor);
  late final SqlTypedController<Topics, TopicsUpdate> topicsController =
      SqlTypedController(typedExecutor);
  late final SqlTypedController<Posts, PostsUpdate> postsController =
      SqlTypedController(typedExecutor);
  late final SqlTypedController<PostsTopics, PostsTopics>
      postsTopicsController = SqlTypedController(typedExecutor);
  late final SqlTypedController<PostsWithTopicsJson, PostsWithTopicsJsonUpdate>
      postsWithTopicsJsonController = SqlTypedController(typedExecutor);
  Future<SqlExecution> createTableUsers() async {
    final result = await executor.execute('''-- 
CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT NOT NULL)''');
    return result;
  }

  Future<List<QuerySelectUsers1>> querySelectUsers1() async {
    final result = await executor.query('''
-- 
SELECT *
FROM users''');
    return result.map(QuerySelectUsers1.fromJson).toList();
  }

  Future<List<QuerySelectUsers2>> querySelectUsers2(
      QuerySelectUsers2Args args) async {
    final result = await executor.query('''
-- 
SELECT *
FROM users
WHERE users.id >= :minId''', [args.minId]);
    return result.map(QuerySelectUsers2.fromJson).toList();
  }

  Future<SqlExecution> insertUsers1(InsertUsers1Args args) async {
    final result = await executor.execute('''
-- 
INSERT INTO users(id, name)
VALUES (1, 'name1'),
    (2, :c)''', [args.c]);
    return result;
  }

  Future<List<UpdateUserName>> updateUserName(UpdateUserNameArgs args) async {
    final result = await executor.query('''
-- {"name":"updateUserName"}
UPDATE users
SET name = :name
WHERE :id = id
RETURNING *''', [args.name, args.id]);
    return result.map(UpdateUserName.fromJson).toList();
  }

  Future<SqlExecution> deleteUsersById(DeleteUsersByIdArgs args) async {
    final result = await executor.execute('''
-- {"name":"deleteUsersById"}
DELETE FROM users
WHERE id IN (:ids)''', [args.ids]);
    return result;
  }

  Future<SqlExecution> createTablePosts() async {
    final result = await executor.execute('''
-- 
CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    title TEXT NOT NULL,
    subtitle TEXT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)''');
    return result;
  }

  Future<SqlExecution> createTableTopics() async {
    final result = await executor.execute('''
-- 
CREATE TABLE topics (
    code VARCHAR(512) PRIMARY KEY,
    priority INT default 0,
    description TEXT
)''');
    return result;
  }

  Future<SqlExecution> createTablePostsTopics() async {
    final result = await executor.execute('''
-- 
CREATE TABLE posts_topics (
    topic_code VARCHAR(512) REFERENCES topics(code),
    post_id INTEGER REFERENCES posts(id),
    PRIMARY KEY(topic_code, post_id)
)''');
    return result;
  }

  Future<List<QuerySelectUsers3>> querySelectUsers3() async {
    final result = await executor.query('''
-- 
SELECT users.id,
    users.name user_name,
    pt.topic_code,
    posts.*
FROM users
    INNER JOIN posts ON posts.user_id = users.id
    LEFT JOIN posts_topics pt ON pt.post_id = posts.id
WHERE users.id = 1
    and posts.subtitle is not null''');
    return result.map(QuerySelectUsers3.fromJson).toList();
  }

  Future<List<UsersWithPosts>> usersWithPosts() async {
    final result = await executor.query('''
-- {"name":"usersWithPosts"}
SELECT users.id,
    users.name user_name,
    json_group_array(
        json_object(
            'id',
            posts.id,
            'user_id',
            posts.user_id,
            'title',
            posts.title,
            'subtitle',
            posts.subtitle,
            'body',
            posts.body,
            'created_at',
            posts.created_at,
            'topics',
            json_array(pt.topic_code)
        )
    ) posts
FROM users
    INNER JOIN posts ON posts.user_id = users.id
    LEFT JOIN posts_topics pt ON pt.post_id = posts.id
WHERE posts.subtitle is not null
GROUP BY users.id''');
    return result.map(UsersWithPosts.fromJson).toList();
  }

  Future<List<UsersWithPostsJSON>> usersWithPostsJSON() async {
    final result = await executor.query('''
-- {"name":"usersWithPostsJSON"}
SELECT users.id,
    users.name user_name,
    json_group_array(p.json_value) posts
FROM users
    INNER JOIN posts_with_topics_json p ON p.user_id = users.id
GROUP BY users.id''');
    return result.map(UsersWithPostsJSON.fromJson).toList();
  }

  Future<SqlExecution> createViewPostsWithTopicsJson() async {
    final result = await executor.execute('''
-- 
CREATE VIEW posts_with_topics_json AS
SELECT posts.id,
    posts.user_id,
    json_object(
        'id',
        posts.id,
        'user_id',
        posts.user_id,
        'title',
        posts.title,
        'subtitle',
        posts.subtitle,
        'body',
        posts.body,
        'created_at',
        posts.created_at,
        'topics',
        json_group_array(pt.topic_code)
    ) json_value
FROM posts
    LEFT JOIN posts_topics pt ON pt.post_id = posts.id
GROUP BY posts.id''');
    return result;
  }

  Future<List<DeleteUsers1>> deleteUsers1(DeleteUsers1Args args) async {
    final result = await executor.query('''
--
DELETE FROM users WHERE (id = ?) RETURNING id,name''', [args.arg0]);
    return result.map(DeleteUsers1.fromJson).toList();
  }

  Future<void> defineDatabaseObjects() async {
    await createTableUsers();
    await createTableTopics();
    await createTablePosts();
    await createTablePostsTopics();
    await createViewPostsWithTopicsJson();
  }
}
