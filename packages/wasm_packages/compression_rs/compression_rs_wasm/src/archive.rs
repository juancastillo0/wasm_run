use crate::{map_err, WitImplementation};

use crate::compression_rs::archive::*;
use crate::exports::compression_rs_namespace::compression_rs;

use std::fs::File;
use std::io::{prelude::*, Cursor};

impl compression_rs::archive::Archive for WitImplementation {
    fn write_archive(input: ArchiveInput, path: String) -> Result<(), String> {
        match input {
            ArchiveInput::Zip(values) => zip_write(values, path),
            ArchiveInput::Tar(values) => tar_write(values, path),
        }
    }

    fn create_archive(input: ArchiveInput) -> Result<Vec<u8>, String> {
        match input {
            ArchiveInput::Zip(values) => zip_create(values),
            ArchiveInput::Tar(values) => tar_create(values),
        }
    }

    fn read_tar(path: String) -> Result<Vec<TarFile>, String> {
        let tar = File::open(&path).map_err(map_err)?;
        let mut a = tar::Archive::new(tar);
        tar_open(&mut a)
    }

    fn view_tar(bytes: Vec<u8>) -> Result<Vec<TarFile>, String> {
        let mut a = tar::Archive::new(bytes.as_slice());
        tar_open(&mut a)
    }

    fn read_zip(path: String) -> Result<Vec<ZipFile>, String> {
        let file = File::open(&path).map_err(map_err)?;
        let mut a = zip::ZipArchive::new(file).map_err(map_err)?;
        zip_open(&mut a)
    }

    fn view_zip(bytes: Vec<u8>) -> Result<Vec<ZipFile>, String> {
        // let zip = File::open("a.zip.gz").map_err(map_err)?;
        // let dec = flate2::read::GzDecoder::new(zip);
        let mut a = zip::ZipArchive::new(Cursor::new(bytes.as_slice())).map_err(map_err)?;
        zip_open(&mut a)
    }

    fn extract_zip(input: Input, path: String) -> Result<(), String> {
        match input {
            Input::Bytes(bytes) => {
                let mut a = zip::ZipArchive::new(Cursor::new(bytes.as_slice())).map_err(map_err)?;
                a.extract(path).map_err(map_err)
            }
            Input::File(file_path) => {
                let file = File::open(file_path).map_err(map_err)?;
                let mut a = zip::ZipArchive::new(file).map_err(map_err)?;
                a.extract(path).map_err(map_err)
            }
        }
    }

    fn extract_tar(input: Input, path: String) -> Result<(), String> {
        match input {
            Input::Bytes(bytes) => {
                let mut a = zip::ZipArchive::new(Cursor::new(bytes.as_slice())).map_err(map_err)?;
                a.extract(path).map_err(map_err)
            }
            Input::File(file_path) => {
                let file = File::open(file_path).map_err(map_err)?;
                let mut a = zip::ZipArchive::new(file).map_err(map_err)?;
                a.extract(path).map_err(map_err)
            }
        }
    }

    // TODO: extract
}

fn zip_write(data: Vec<ZipArchiveInput>, path: String) -> Result<(), String> {
    let file = File::create(path).map_err(map_err)?;
    let mut ar = zip::ZipWriter::new(file);
    update_zip(&mut ar, data).map_err(map_err)?;
    ar.finish().map_err(map_err)?;
    Ok(())
}

fn zip_create(files: Vec<ZipArchiveInput>) -> Result<Vec<u8>, String> {
    let mut ar = zip::ZipWriter::new(Cursor::new(Vec::new()));
    update_zip(&mut ar, files).map_err(map_err)?;
    Ok(ar.finish().map_err(map_err)?.into_inner())
}

// fn zip_open_bytes(data: Vec<u8>) -> Result<Vec<ZipFile>, String> {
//     // let zip = File::open("a.zip.gz").map_err(map_err)?;
//     // let dec = flate2::read::GzDecoder::new(zip);

//     // let tar = File::create("a.tar.gz").map_err(map_err)?;
//     // let enc = GzEncoder::new(tar, Compression::default());
//     // let mut a = tar::Builder::new(enc);
//     // a.append_dir_all("", "in").map_err(map_err)?;
// }

fn map_zip_method(method: ZipCompressionMethod) -> zip::CompressionMethod {
    match method {
        ZipCompressionMethod::Stored => zip::CompressionMethod::Stored,
        ZipCompressionMethod::Deflated => zip::CompressionMethod::Deflated,
    }
}

fn map_zip_method_to(method: zip::CompressionMethod) -> ZipCompressionMethod {
    match method {
        zip::CompressionMethod::Stored => ZipCompressionMethod::Stored,
        zip::CompressionMethod::Deflated => ZipCompressionMethod::Deflated,
        // TODO: unkown
        _ => ZipCompressionMethod::Stored,
    }
}

fn zip_option(input: &ZipOptions) -> zip::write::FileOptions {
    let mut opts = zip::write::FileOptions::default();

    opts = opts.compression_method(map_zip_method(input.compression_method));
    if let Some(v) = input.permissions {
        opts = opts.unix_permissions(v);
    }
    opts = opts.compression_level(input.compression_level);
    if let Some(v) = input.last_modified_time {
        let v = time::OffsetDateTime::from_unix_timestamp(v);
        if let Ok(Ok(v)) = v.map(|v| zip::DateTime::try_from(v)) {
            opts = opts.last_modified_time(v);
        }
    }
    opts
}

fn set_zip_comment<W: Write + Seek>(ar: &mut zip::ZipWriter<W>, input: Option<BytesOrUnicode>) {
    if let Some(comment) = input {
        match comment {
            BytesOrUnicode::U8List(v) => ar.set_raw_comment(v),
            BytesOrUnicode::String(v) => ar.set_comment(v),
        }
    }
}

fn update_zip<W: Write + Seek>(
    ar: &mut zip::ZipWriter<W>,
    files: Vec<ZipArchiveInput>,
) -> Result<(), String> {
    for file in files {
        let (mut options, comment) = if let Some(mut options) = file.options {
            (zip_option(&options), options.comment.take())
        } else {
            (zip::write::FileOptions::default(), None)
        };
        match file.item {
            ItemInput::DirPath(DirPath {
                path,
                name,
                all_recursive,
            }) => {
                // TODO: symlink
                ar.add_directory(name.as_ref().unwrap_or(&path), options)
                    .map_err(map_err)?;
                set_zip_comment(ar, comment);
                if all_recursive {
                    let mut entries = std::fs::read_dir(path).map_err(map_err)?;
                    let mut files = Vec::new();
                    while let Some(entry) = entries.next() {
                        let entry = entry.map_err(map_err)?;
                        let path = entry.path();
                        if path.is_dir() {
                            files.push(ZipArchiveInput {
                                options: None,
                                item: ItemInput::DirPath(DirPath {
                                    // TODO: don't unwrap
                                    path: path.to_str().unwrap().to_string(),
                                    name: None,
                                    all_recursive: true,
                                }),
                            });
                        } else {
                            files.push(ZipArchiveInput {
                                options: None,
                                item: ItemInput::FilePath(FilePath {
                                    // TODO: don't unwrap
                                    path: path.to_str().unwrap().to_string(),
                                    name: None,
                                }),
                            });
                        }
                    }
                    update_zip(ar, files).map_err(map_err)?;
                }
            }
            ItemInput::FilePath(FilePath { path, name }) => {
                ar.start_file(name.as_ref().unwrap_or(&path), options)
                    .map_err(map_err)?;
                set_zip_comment(ar, comment);
                let buf = std::fs::read(path).map_err(map_err)?;
                ar.write_all(buf.as_ref()).map_err(map_err)?;
            }
            ItemInput::FileBytes(FileBytes { path, bytes }) => {
                options = options.large_file(bytes.len() > 4294967295);
                ar.start_file(&path, options).map_err(map_err)?;
                set_zip_comment(ar, comment);
                ar.write_all(bytes.as_ref()).map_err(map_err)?;
            }
        }
    }
    Ok(())
}

fn zip_open<R: Read + Seek>(a: &mut zip::ZipArchive<R>) -> Result<Vec<ZipFile>, String> {
    // TODO: a.set_unpack_xattrs(unpack_xattrs)
    (0..a.len())
        .map(|i| {
            let mut e = a.by_index(i).map_err(map_err)?;

            let mut bytes = Vec::new();
            e.read_to_end(&mut bytes).map_err(map_err)?;
            Ok(ZipFile {
                compression_method: map_zip_method_to(e.compression()),
                comment: e.comment().to_string(),
                last_modified_time: e.last_modified().to_time().unwrap().unix_timestamp(),
                permissions: e.unix_mode(),
                crc32: e.crc32(),
                enclosed_name: e
                    .enclosed_name()
                    .map(|n| n.to_str())
                    .flatten()
                    .map(|n| n.to_string()),
                compressed_size: e.compressed_size(),
                extra_data: e.extra_data().to_vec(),
                is_dir: e.is_dir(),
                file: FileBytes {
                    path: e.name().to_string(),
                    bytes,
                },
            })
        })
        .collect::<Result<Vec<_>, String>>()
}

// TAR

fn tar_write(data: Vec<TarArchiveInput>, path: String) -> Result<(), String> {
    let file = File::create(path).map_err(map_err)?;
    let mut ar = tar::Builder::new(file);
    update_tar(&mut ar, data).map_err(map_err)?;
    ar.into_inner().map_err(map_err)?;
    Ok(())
}

fn tar_create(files: Vec<TarArchiveInput>) -> Result<Vec<u8>, String> {
    let mut ar = tar::Builder::new(Vec::new());
    update_tar(&mut ar, files).map_err(map_err)?;
    ar.into_inner().map_err(map_err)
}

fn tar_map_header(input: TarHeaderInput) -> Result<tar::Header, String> {
    match input {
        TarHeaderInput::Bytes(bytes) => {
            if bytes.len() != 512 {
                Err("Header bytes should be a 512 bytes buffer".to_string())
            } else {
                Ok(tar::Header::from_byte_slice(bytes.as_slice()).clone())
            }
        }
        TarHeaderInput::Model(data) => {
            let mut header = tar::Header::new_gnu();
            data.mode.map(|v| header.set_mode(v));
            data.uid.map(|v| header.set_uid(v));
            data.gid.map(|v| header.set_gid(v));
            data.mtime.map(|v| header.set_mtime(v));
            if let Some(v) = data.username {
                header.set_username(&v).map_err(map_err)?;
            }
            if let Some(v) = data.groupname {
                header.set_groupname(&v).map_err(map_err)?;
            }
            if let Some(v) = data.device_major {
                header.set_device_major(v).map_err(map_err)?;
            }
            if let Some(v) = data.device_minor {
                header.set_device_minor(v).map_err(map_err)?;
            }
            Ok(header)
        }
    }
}

fn tar_map_header_to(header: &tar::Header) -> TarHeader {
    let mut format_errors = Vec::new();
    TarHeader {
        mode: header
            .mode()
            // TODO: always returns error when empty .map_err(|e| format_errors.push(map_err(e)))
            .ok(),
        uid: header
            .uid()
            // TODO: always returns error when empty .map_err(|e| format_errors.push(map_err(e)))
            .ok(),
        gid: header
            .gid()
            // TODO: always returns error when empty .map_err(|e| format_errors.push(map_err(e)))
            .ok(),
        mtime: header
            .mtime()
            .map_err(|e| format_errors.push(map_err(e)))
            .ok(),
        username: header
            .username()
            .map_err(|e| format_errors.push(map_err(e)))
            .ok()
            .flatten()
            .map(|v| v.to_string()),
        groupname: header
            .groupname()
            .map_err(|e| format_errors.push(map_err(e)))
            .ok()
            .flatten()
            .map(|v| v.to_string()),
        device_major: header
            .device_major()
            // TODO: always returns error when empty .map_err(|e| format_errors.push(map_err(e)))
            .ok()
            .flatten(),
        device_minor: header
            .device_minor()
            // TODO: always returns error when empty .map_err(|e| format_errors.push(map_err(e)))
            .ok()
            .flatten(),
        bytes: header.as_bytes().to_vec(),
        cksum: header
            .cksum()
            .map_err(|e| format_errors.push(map_err(e)))
            .ok(),
        entry_type: map_entry_type(header.entry_type()),
        groupname_bytes: header.groupname_bytes().map(|f| f.to_vec()),
        username_bytes: header.username_bytes().map(|f| f.to_vec()),
        link_name: header
            .link_name()
            .map_err(|e| format_errors.push(map_err(e)))
            .ok()
            .flatten()
            .map(|v| v.to_str().unwrap().to_string()),
        link_name_bytes: header.link_name_bytes().map(|f| f.to_vec()),
        path: header
            .path()
            .map_err(|e| format_errors.push(map_err(e)))
            .ok()
            .map(|v| v.to_str().unwrap().to_string()),
        path_bytes: header.path_bytes().to_vec(),
        format_errors,
    }
}

fn map_entry_type(entry_type: tar::EntryType) -> TarEntryType {
    match entry_type {
        tar::EntryType::Regular => TarEntryType::Regular,
        tar::EntryType::Link => TarEntryType::Link,
        tar::EntryType::Symlink => TarEntryType::Symlink,
        tar::EntryType::Char => TarEntryType::Char,
        tar::EntryType::Block => TarEntryType::Block,
        tar::EntryType::Directory => TarEntryType::Directory,
        tar::EntryType::Fifo => TarEntryType::Fifo,
        tar::EntryType::Continuous => TarEntryType::Continuous,
        tar::EntryType::GNULongName => TarEntryType::GnuLongName,
        tar::EntryType::GNULongLink => TarEntryType::GnuLongLink,
        tar::EntryType::GNUSparse => TarEntryType::GnuSparse,
        tar::EntryType::XGlobalHeader => TarEntryType::XGlobalHeader,
        tar::EntryType::XHeader => TarEntryType::XHeader,
        _ => TarEntryType::Unknown,
    }
}

fn update_tar<W: Write>(
    ar: &mut tar::Builder<W>,
    files: Vec<TarArchiveInput>,
) -> Result<(), String> {
    for file in files {
        let mut header = if let Some(header) = file.header {
            tar_map_header(header)?
        } else {
            tar::Header::new_gnu()
        };
        match file.item {
            ItemInput::DirPath(DirPath {
                path,
                name,
                all_recursive,
            }) => {
                // TODO: symlink
                if all_recursive {
                    ar.append_dir_all(name.as_ref().unwrap_or(&path), &path)
                        .map_err(map_err)?;
                } else {
                    ar.append_dir(name.as_ref().unwrap_or(&path), &path)
                        .map_err(map_err)?;
                }
            }
            ItemInput::FilePath(FilePath { path, name }) => {
                // TODO: use header
                ar.append_path_with_name(&path, name.as_ref().unwrap_or(&path))
                    .map_err(map_err)?;
            }
            ItemInput::FileBytes(FileBytes { path, bytes }) => {
                header.set_size(bytes.len() as u64);
                ar.append_data(&mut header, path, bytes.as_slice())
                    .map_err(map_err)?;
            }
        }

        // if let Some(bytes) = file.bytes {
        //     let mut header = tar::Header::new_gnu();
        //     header.set_size(bytes.len() as u64);
        //     ar.append_data(&mut header, file.path, bytes.as_slice())
        //         .map_err(map_err)?;
        // } else {
        //     // let mut file_open = File::open(file.path).map_err(map_err)?;
        //     // TODO: with name
        //     ar.append_path(file.path).map_err(map_err)?;
        //     // ar.append_file("bar.txt", &mut File::open("bar.txt").map_err(map_err)?)
        //     //     .map_err(map_err)?;
        // }
    }
    Ok(())
}

// fn tar_unpack(data: Vec<TarArchiveInput>, path: String) -> u32 {
//     update_(ar, files);
//     a.unpack("out").map_err(map_err)?;
// }

// fn tar_open_path(path: String) -> Result<Vec<TarFile>, String> {}
// fn tar_open_bytes(data: Vec<u8>) -> Result<Vec<TarFile>, String> {
//     // let tar = File::open("a.tar.gz").map_err(map_err)?;
//     // let dec = flate2::read::GzDecoder::new(tar);

//     // let tar = File::create("a.tar.gz").map_err(map_err)?;
//     // let enc = GzEncoder::new(tar, Compression::default());
//     // let mut a = tar::Builder::new(enc);
//     // a.append_dir_all("", "in").map_err(map_err)?;
// }

fn tar_open<R: Read>(a: &mut tar::Archive<R>) -> Result<Vec<TarFile>, String> {
    // TODO: a.set_unpack_xattrs(unpack_xattrs)
    a.entries()
        .map_err(map_err)?
        .map(|e| {
            let mut e = e.map_err(map_err)?;

            let mut bytes = Vec::new();
            // TODO: e.header()
            // TODO: e.path_bytes()
            e.read_to_end(&mut bytes).map_err(map_err)?;
            Ok(TarFile {
                header: tar_map_header_to(e.header()),
                file: FileBytes {
                    path: e.path().map_err(map_err)?.to_str().unwrap().to_string(),
                    bytes,
                },
            })
        })
        .collect::<Result<Vec<_>, String>>()
}

// int mode = 420; // octal 644 (-rw-r--r--)
// int ownerId = 0;
// int groupId = 0;
// int lastModTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
// String nameOfLinkedFile = '';
// String? comment;
// bool compress = true;

// enum TarInput {
//     FilePath(String),
//     Values(Vec<TarArchiveInput>),
// }

// enum TarFile {
//     File(String, Vec<u8>),
//     Directory(String, Vec<TarFile>),
// }

// struct TarFile {
//     path: String,
//     bytes: Vec<u8>,
// }

// struct TarFileInput {
//     path: String,
//     is_dir: bool,
//     name: Option<String>,
//     bytes: Option<Vec<u8>>,
// }

// enum TarFileInput {
//     FilePath {
//         path: String,
//         name: Option<String>,
//     },
//     DirPath {
//         path: String,
//         name: Option<String>,
//         all: bool,
//     },
//     FileBytes {
//         path: String,
//         bytes: Vec<u8>,
//     },
// }
