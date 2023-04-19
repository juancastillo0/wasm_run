// ignore_for_file: inference_failure_on_untyped_parameter

Function makeFunctionNumArgs(
  int numArgs,
  dynamic Function(List<Object?>) inner,
) {
  switch (numArgs) {
    case 0:
      return () => inner([]);
    case 1:
      return (a0) => inner([a0]);
    case 2:
      return (a0, a1) => inner([a0, a1]);
    case 3:
      return (a0, a1, a2) => inner([a0, a1, a2]);
    case 4:
      return (a0, a1, a2, a3) => inner([a0, a1, a2, a3]);
    case 5:
      return (a0, a1, a2, a3, a4) => inner([a0, a1, a2, a3, a4]);
    case 6:
      return (a0, a1, a2, a3, a4, a5) => inner([a0, a1, a2, a3, a4, a5]);
    case 7:
      return (a0, a1, a2, a3, a4, a5, a6) =>
          inner([a0, a1, a2, a3, a4, a5, a6]);
    case 8:
      return (a0, a1, a2, a3, a4, a5, a6, a7) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7]);
    case 9:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8]);
    case 10:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9]);
    case 11:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10]);
    case 12:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11]);
    case 13:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12]);
    case 14:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13]);
    case 15:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13,
              a14) =>
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
            a14
          ]);
    case 16:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14,
              a15) =>
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
            a15
          ]);
    case 17:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14,
              a15, a16) =>
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
            a16
          ]);
    case 18:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14,
              a15, a16, a17) =>
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
            a17
          ]);
    case 19:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14,
              a15, a16, a17, a18) =>
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
            a18
          ]);

    default:
      throw StateError('Unsupported number of arguments: $numArgs');
  }
}
