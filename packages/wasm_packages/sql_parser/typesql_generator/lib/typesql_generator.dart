/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'package:build/build.dart';
import 'package:typesql_generator/typesql_generator.dart';

export 'src/typesql_generator_base.dart';

/// Returns a Builder that generates the file that centralizes all
/// validators in the project
Builder sqlGenerator(BuilderOptions options) => SqlGeneratorBuilder(options);
