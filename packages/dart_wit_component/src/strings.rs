pub trait Normalize {
    fn as_str(&self) -> &str;

    fn as_type(&self) -> String {
        heck::AsPascalCase(self.as_str()).to_string()
    }

    fn as_fn(&self) -> String {
        escape_reserved_word(&heck::AsLowerCamelCase(self.as_str()).to_string())
    }

    fn as_fn_suffix(&self) -> String {
        heck::AsPascalCase(&self.as_str()).to_string()
    }

    fn as_var(&self) -> String {
        escape_reserved_word(&heck::AsLowerCamelCase(self.as_str()).to_string())
    }

    fn as_const(&self) -> String {
        heck::AsShoutySnakeCase(self.as_str()).to_string()
    }

    fn as_namespace(&self) -> String {
        heck::AsShoutySnakeCase(self.as_str()).to_string()
    }
}

impl<T: AsRef<str>> Normalize for T {
    fn as_str(&self) -> &str {
        self.as_ref()
    }
}

/// Checks the given word against a list of reserved keywords.
/// If the given word conflicts with a keyword, a trailing underscore will be
/// appended.
///
/// Adapted from [wiggle](https://docs.rs/wiggle/latest/wiggle/index.html)
pub fn escape_reserved_word(word: &str) -> String {
    if RESERVED.contains(&word) {
        // If the camel-cased string matched any strict or reserved keywords, then
        // append a trailing underscore to the identifier we generate.
        format!("{word}_")
    } else {
        word.to_string() // Otherwise, use the string as is.
    }
}

// pub fn write_padding<W: Write>(
//     w: &mut PrettyWriter<W>,
//     pad_len: usize,
// ) -> std::result::Result<(), Error> {
//     for i in 0..(pad_len & 1) {
//         w.write_line(format!("@u8() external int __pad8_{};", i))?;
//     }
//     for i in 0..(pad_len & 3) / 2 {
//         w.write_line(format!("@u16() external int __pad16_{};", i))?;
//     }
//     for i in 0..(pad_len & 7) / 4 {
//         w.write_line(format!("@u32() external int __pad32_{};", i))?;
//     }
//     for i in 0..pad_len / 8 {
//         w.write_line(format!("@u64() external int __pad64_{};", i))?;
//     }
//     Ok(())
// }

const RESERVED: &[&str] = &[
    // Reserved words.
    "assert",
    "break",
    "case",
    "catch",
    "class",
    "const",
    "continue",
    "default",
    "do",
    "else",
    "enum",
    "extends",
    "false",
    "final",
    "finally",
    "for",
    "if",
    "in",
    "is",
    "new",
    "null",
    "rethrow",
    "return",
    "super",
    "switch",
    "this",
    "throw",
    "true",
    "try",
    "var",
    "void",
    "while",
    "with",
    // Built-in identifiers.
    "abstract",
    "as",
    "covariant",
    "deferred",
    "dynamic",
    "export",
    "extension",
    "external",
    "factory",
    "Function",
    "get",
    "implements",
    "import",
    "interface",
    "late",
    "library",
    "operator",
    "mixin",
    "part",
    "required",
    "set",
    "static",
    "typedef",
    // "Contextual keywords".
    "await",
    "yield",
    // Other words used in the grammar.
    "async",
    "base",
    "hide",
    "of",
    "on",
    "sealed",
    "show",
    "sync",
    "when",
    // Other words used by the generator
    "toJson",
    "toMap",
    "fromJson",
    "fromMap",
    "toWasm",
    "fromWasm",
    "wasmSpec",
    "wasmType",
    "toString",
    "hashCode",
    "runtimeType",
    "props",
    "copyWith",
    "builder",
    "compareTo",
    "flagBits",
    "none",
    "all",
    "bool",
    "int",
    "double",
    "num",
    "i64",
];
