// coverage:ignore-file
// ignore_for_file: inference_failure_on_untyped_parameter, require_trailing_commas

import 'dart:js_interop';

/// Creates a function that calls [inner] with the given number of arguments.
JSFunction makeFunctionNumArgsJS(
  int numArgs,
  dynamic Function(List<Object?>) inner,
) {
  switch (numArgs) {
    case 0:
      return (() => inner([]) as JSAny?).toJS;
    case 1:
      return ((JSAny? a0) => inner([a0]) as JSAny?).toJS;
    case 2:
      return ((JSAny? a0, JSAny? a1) => inner([a0, a1]) as JSAny?).toJS;
    case 3:
      return ((JSAny? a0, JSAny? a1, JSAny? a2) =>
              inner([a0, a1, a2]) as JSAny?)
          .toJS;
    case 4:
      return ((JSAny? a0, JSAny? a1, JSAny? a2, JSAny? a3) =>
              inner([a0, a1, a2, a3]) as JSAny?)
          .toJS;
    case 5:
      return ((JSAny? a0, JSAny? a1, JSAny? a2, JSAny? a3, JSAny? a4) =>
              inner([a0, a1, a2, a3, a4]) as JSAny?)
          .toJS;
    case 6:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
          ) => inner([a0, a1, a2, a3, a4, a5]) as JSAny?)
          .toJS;
    case 7:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
          ) => inner([a0, a1, a2, a3, a4, a5, a6]) as JSAny?)
          .toJS;
    case 8:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
          ) => inner([a0, a1, a2, a3, a4, a5, a6, a7]) as JSAny?)
          .toJS;
    case 9:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
          ) => inner([a0, a1, a2, a3, a4, a5, a6, a7, a8]) as JSAny?)
          .toJS;
    case 10:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
          ) => inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9]) as JSAny?)
          .toJS;
    case 11:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
          ) => inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10]) as JSAny?)
          .toJS;
    case 12:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
          ) =>
              inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11])
                  as JSAny?)
          .toJS;
    case 13:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
          ) =>
              inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12])
                  as JSAny?)
          .toJS;
    case 14:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                  ])
                  as JSAny?)
          .toJS;
    case 15:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
            JSAny? a14,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                    a14,
                  ])
                  as JSAny?)
          .toJS;
    case 16:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
            JSAny? a14,
            JSAny? a15,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                    a14,
                    a15,
                  ])
                  as JSAny?)
          .toJS;
    case 17:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
            JSAny? a14,
            JSAny? a15,
            JSAny? a16,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                    a14,
                    a15,
                    a16,
                  ])
                  as JSAny?)
          .toJS;
    case 18:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
            JSAny? a14,
            JSAny? a15,
            JSAny? a16,
            JSAny? a17,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                    a14,
                    a15,
                    a16,
                    a17,
                  ])
                  as JSAny?)
          .toJS;
    case 19:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
            JSAny? a14,
            JSAny? a15,
            JSAny? a16,
            JSAny? a17,
            JSAny? a18,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                    a14,
                    a15,
                    a16,
                    a17,
                    a18,
                  ])
                  as JSAny?)
          .toJS;
    case 20:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
            JSAny? a14,
            JSAny? a15,
            JSAny? a16,
            JSAny? a17,
            JSAny? a18,
            JSAny? a19,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                    a14,
                    a15,
                    a16,
                    a17,
                    a18,
                    a19,
                  ])
                  as JSAny?)
          .toJS;
    case 21:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
            JSAny? a14,
            JSAny? a15,
            JSAny? a16,
            JSAny? a17,
            JSAny? a18,
            JSAny? a19,
            JSAny? a20,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                    a14,
                    a15,
                    a16,
                    a17,
                    a18,
                    a19,
                    a20,
                  ])
                  as JSAny?)
          .toJS;
    case 22:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
            JSAny? a14,
            JSAny? a15,
            JSAny? a16,
            JSAny? a17,
            JSAny? a18,
            JSAny? a19,
            JSAny? a20,
            JSAny? a21,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                    a14,
                    a15,
                    a16,
                    a17,
                    a18,
                    a19,
                    a20,
                    a21,
                  ])
                  as JSAny?)
          .toJS;
    case 23:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
            JSAny? a14,
            JSAny? a15,
            JSAny? a16,
            JSAny? a17,
            JSAny? a18,
            JSAny? a19,
            JSAny? a20,
            JSAny? a21,
            JSAny? a22,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                    a14,
                    a15,
                    a16,
                    a17,
                    a18,
                    a19,
                    a20,
                    a21,
                    a22,
                  ])
                  as JSAny?)
          .toJS;
    case 24:
      return ((
            JSAny? a0,
            JSAny? a1,
            JSAny? a2,
            JSAny? a3,
            JSAny? a4,
            JSAny? a5,
            JSAny? a6,
            JSAny? a7,
            JSAny? a8,
            JSAny? a9,
            JSAny? a10,
            JSAny? a11,
            JSAny? a12,
            JSAny? a13,
            JSAny? a14,
            JSAny? a15,
            JSAny? a16,
            JSAny? a17,
            JSAny? a18,
            JSAny? a19,
            JSAny? a20,
            JSAny? a21,
            JSAny? a22,
            JSAny? a23,
          ) =>
              inner([
                    a0,
                    a1,
                    a2,
                    a3,
                    a4,
                    a5,
                    a6,
                    a7,
                    a8,
                    a9,
                    a10,
                    a11,
                    a12,
                    a13,
                    a14,
                    a15,
                    a16,
                    a17,
                    a18,
                    a19,
                    a20,
                    a21,
                    a22,
                    a23,
                  ])
                  as JSAny?)
          .toJS;

    default:
      throw StateError('Unsupported number of arguments: $numArgs');
  }
}
