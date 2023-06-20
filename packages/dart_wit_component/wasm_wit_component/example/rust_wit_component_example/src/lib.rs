// Use a procedural macro to generate bindings for the world we specified in
// `host.wit`
wit_bindgen::generate!("types-example");

use exports::types_example_namespace::types_example_pkg::*;
use types_example_namespace::types_example_pkg::{
    api_imports as imports, round_trip_numbers as round_trip_numbers_host, types_interface,
};

// Define a custom type and implement the generated `Host` trait for it which
// represents implementing all the necessary exported interfaces for this
// component.
struct MyHost;

impl TypesExample for MyHost {
    fn f_f1(mut typedef: T10) -> T10 {
        if let Some(s) = typedef.last() {
            print(s, LogLevel::Info);
        }
        typedef.push("last_value".to_string());
        typedef
    }

    fn f1(f: f32, f_list: Vec<(char, f64)>) -> (i64, String) {
        (
            f.to_bits().into(),
            f_list.iter().map(|(c, f)| format!("{c}:{f}")).collect(),
        )
    }

    fn re_named(perm: Option<Permissions>, e: Option<Empty>) -> T2Renamed {
        (
            if let Some(perm) = perm {
                perm.bits().into()
            } else {
                0
            },
            if e.is_some() { 0 } else { 1 },
        )
    }

    fn re_named2(tup: (Vec<u16>,), _e: Empty) -> (Option<u8>, i8) {
        (
            if tup.0.len() < 256 {
                Some(tup.0.len().try_into().unwrap())
            } else {
                None
            },
            if tup.0.is_empty() { -1 } else { 1 },
        )
    }
}

impl api::Api for MyHost {
    fn f12() -> ((i32,), String) {
        ((1,), "hello".to_string())
    }

    fn class(break_: Option<Option<api::T5>>) -> () {
        if let Some(v) = break_ {
            if let Some(v) = v {
                let charr = v.err().flatten().map(|e| e.c).flatten();
                let r = inline::inline_imp(&[charr]);
                if let Err(e) = r {
                    print(&e.to_string(), LogLevel::Warn);
                    inline::inline_imp(&[Some(e)]).unwrap();
                } else {
                    inline::inline_imp(&[None, None]).unwrap();
                }
            } else {
                inline::inline_imp(&[]).unwrap();
            }
        }
        ()
    }

    fn continue_(abstract_: Option<Result<(), api::Errno>>, _extends_: ()) -> Option<()> {
        if let Some(r) = abstract_ {
            if let Err(r) = r {
                _ = match (r.str, r.a_u1, r.c, r.list_s1.first()) {
                    (Some(s), _, None, Some(i)) => {
                        imports::api_a1_b2(&[&imports::Human::Adult((s, None, (*i,)))])
                    }
                    (None, _, Some(ch), Some(i)) => imports::api_a1_b2(&[&imports::Human::Adult(
                        (ch.to_lowercase().to_string(), Some(None), (*i,)),
                    )]),
                    (Some(s), _, Some(ch), Some(i)) => {
                        imports::api_a1_b2(&[&imports::Human::Adult((
                            s.clone(),
                            Some(Some(format!("{s}{ch}"))),
                            (*i,),
                        ))])
                    }
                    (None, v, _, _) => imports::api_a1_b2(&[&imports::Human::Child(v)]),
                    _ => imports::api_a1_b2(&[&imports::Human::Baby]),
                };
            } else {
                _ = imports::api_a1_b2(&[]);
            }
            Some(())
        } else {
            None
        }
    }

    fn record_func(
        r: types_interface::R,
        e: types_interface::Errno,
        p: types_interface::Permissions,
        i: types_interface::Input,
    ) -> (
        types_interface::R,
        types_interface::Errno,
        types_interface::Permissions,
        types_interface::Input,
    ) {
        imports::record_func(&r, e, p, &i)
    }
}

impl round_trip_numbers::RoundTripNumbers for MyHost {
    fn round_trip_numbers(
        data: round_trip_numbers::RoundTripNumbersData,
    ) -> round_trip_numbers::RoundTripNumbersData {
        let result = round_trip_numbers_host::round_trip_numbers(
            round_trip_numbers_host::RoundTripNumbersData {
                f32: data.f32,
                f64: data.f64,
                si8: data.si8,
                un8: data.un8,
                si16: data.si16,
                un16: data.un16,
                si32: data.si32,
                un32: data.un32,
                si64: data.si64,
                un64: data.un64,
            },
        );
        assert_eq!(result.si8, data.si8);
        assert_eq!(result.un8, data.un8);
        assert_eq!(result.si16, data.si16);
        assert_eq!(result.un16, data.un16);
        assert_eq!(result.si32, data.si32);
        assert_eq!(result.un32, data.un32);
        assert_eq!(result.si64, data.si64);
        assert_eq!(result.un64, data.un64);
        data
    }

    fn round_trip_numbers_list(
        data: round_trip_numbers::RoundTripNumbersListData,
    ) -> round_trip_numbers::RoundTripNumbersListData {
        let arg = round_trip_numbers_host::RoundTripNumbersListData {
            f32: data.f32.clone(),
            f64: data.f64.clone(),
            si8: data.si8.clone(),
            un8: data.un8.clone(),
            si16: data.si16.clone(),
            un16: data.un16.clone(),
            si32: data.si32.clone(),
            un32: data.un32.clone(),
            si64: data.si64.clone(),
            un64: data.un64.clone(),
            si64_list: data.si64_list.clone(),
            un64_list: data.un64_list.clone(),
            un8_list: data.un8_list.clone(),
        };
        let result = round_trip_numbers_host::round_trip_numbers_list(&arg);
        assert_eq!(result.si8, data.si8);
        assert_eq!(result.un8, data.un8);
        assert_eq!(result.si16, data.si16);
        assert_eq!(result.un16, data.un16);
        assert_eq!(result.si32, data.si32);
        assert_eq!(result.un32, data.un32);
        assert_eq!(result.si64, data.si64);
        assert_eq!(result.un64, data.un64);
        assert_eq!(result.si64_list, data.si64_list);
        assert_eq!(result.un64_list, data.un64_list);
        assert_eq!(result.un8_list, data.un8_list);
        data
    }
}

export_types_example!(MyHost);
