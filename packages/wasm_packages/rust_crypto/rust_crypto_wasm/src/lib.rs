// Use a procedural macro to generate bindings for the world we specified in
// `with/dart-wit-generator.wit`
wit_bindgen::generate!("rust-crypto");

use aes_gcm_siv::aead::Aead;
use argon2::password_hash::{rand_core::OsRng, PasswordHasher, PasswordVerifier};
use hmac::Mac;
use sha2::Digest;

use exports::wasm_run_dart::rust_crypto;

// Define a custom type and implement the generated `Host` trait for it which
// represents implementing all the necessary exported interfaces for this
// component.
struct RustCryptoImpl;

impl rust_crypto::hmac::Hmac for RustCryptoImpl {
    fn hmac_sha256(key: Vec<u8>, input: Vec<u8>) -> Vec<u8> {
        let mut mac = hmac::Hmac::<sha2::Sha256>::new_from_slice(&key).unwrap();
        mac.update(&input);
        mac.finalize().into_bytes().to_vec()
    }

    fn hmac_sha512(key: Vec<u8>, input: Vec<u8>) -> Vec<u8> {
        let mut mac = hmac::Hmac::<sha2::Sha512>::new_from_slice(&key).unwrap();
        mac.update(&input);
        mac.finalize().into_bytes().to_vec()
    }

    fn hmac_sha384(key: Vec<u8>, input: Vec<u8>) -> Vec<u8> {
        let mut mac = hmac::Hmac::<sha2::Sha384>::new_from_slice(&key).unwrap();
        mac.update(&input);
        mac.finalize().into_bytes().to_vec()
    }

    fn hmac_sha224(key: Vec<u8>, input: Vec<u8>) -> Vec<u8> {
        let mut mac = hmac::Hmac::<sha2::Sha224>::new_from_slice(&key).unwrap();
        mac.update(&input);
        mac.finalize().into_bytes().to_vec()
    }

    fn hmac_blake3(key: Vec<u8>, input: Vec<u8>) -> Vec<u8> {
        use crate::exports::wasm_run_dart::rust_crypto::blake3::Blake3;
        RustCryptoImpl::mac_keyed_hash(key, input)
        // let mut mac = hmac::SimpleHmac::<blake3::Hasher>::new_from_slice(&key).unwrap();
        // mac.update(&input);
        // mac.finalize().into_bytes().to_vec()
    }
}

impl rust_crypto::sha2::Sha2 for RustCryptoImpl {
    fn sha256(input: Vec<u8>) -> Vec<u8> {
        let mut hasher = sha2::Sha256::new();
        hasher.update(input);
        hasher.finalize().to_vec()
    }

    fn sha512(input: Vec<u8>) -> Vec<u8> {
        let mut hasher = sha2::Sha512::new();
        hasher.update(input);
        hasher.finalize().to_vec()
    }

    fn sha384(input: Vec<u8>) -> Vec<u8> {
        let mut hasher = sha2::Sha384::new();
        hasher.update(input);
        hasher.finalize().to_vec()
    }

    fn sha224(input: Vec<u8>) -> Vec<u8> {
        let mut hasher = sha2::Sha224::new();
        hasher.update(input);
        hasher.finalize().to_vec()
    }
}

impl rust_crypto::blake3::Blake3 for RustCryptoImpl {
    fn hash(bytes: Vec<u8>) -> Vec<u8> {
        blake3::hash(&bytes).as_bytes().to_vec()
    }

    fn mac_keyed_hash(key: Vec<u8>, bytes: Vec<u8>) -> Vec<u8> {
        blake3::keyed_hash(&key.try_into().unwrap(), &bytes)
            .as_bytes()
            .to_vec()
    }

    fn derive_key(context: Vec<u8>, key_material: Vec<u8>) -> Vec<u8> {
        let context = std::str::from_utf8(&context).unwrap();
        blake3::derive_key(context, &key_material).to_vec()
    }
}

fn to_argon2<'a>(config: &'a rust_crypto::argon2::Argon2Config) -> argon2::Argon2<'a> {
    let algorithm = match config.algorithm {
        rust_crypto::argon2::Argon2Algorithm::Argon2d => argon2::Algorithm::Argon2d,
        rust_crypto::argon2::Argon2Algorithm::Argon2i => argon2::Algorithm::Argon2i,
        rust_crypto::argon2::Argon2Algorithm::Argon2id => argon2::Algorithm::Argon2id,
    };

    let version = match config.version {
        rust_crypto::argon2::Argon2Version::V0x10 => argon2::Version::V0x10,
        rust_crypto::argon2::Argon2Version::V0x13 => argon2::Version::V0x13,
    };

    let params = argon2::Params::new(
        config.memory_cost,
        config.time_cost,
        config.parallelism_cost,
        config.output_length.map(|i| i.try_into().unwrap()),
    )
    .unwrap();

    if let Some(secret) = &config.secret {
        argon2::Argon2::new_with_secret(secret, algorithm, version, params).unwrap()
    } else {
        argon2::Argon2::new(algorithm, version, params)
    }
}

impl rust_crypto::argon2::Argon2 for RustCryptoImpl {
    fn default_config() -> rust_crypto::argon2::Argon2Config {
        let algorithm = match argon2::Algorithm::default() {
            argon2::Algorithm::Argon2d => rust_crypto::argon2::Argon2Algorithm::Argon2d,
            argon2::Algorithm::Argon2i => rust_crypto::argon2::Argon2Algorithm::Argon2i,
            argon2::Algorithm::Argon2id => rust_crypto::argon2::Argon2Algorithm::Argon2id,
        };

        let version = match argon2::Version::default() {
            argon2::Version::V0x10 => rust_crypto::argon2::Argon2Version::V0x10,
            argon2::Version::V0x13 => rust_crypto::argon2::Argon2Version::V0x13,
        };
        let params = argon2::Params::default();

        rust_crypto::argon2::Argon2Config {
            algorithm,
            memory_cost: params.m_cost(),
            time_cost: params.t_cost(),
            parallelism_cost: params.p_cost(),
            output_length: Some(
                params
                    .output_len()
                    .unwrap_or(argon2::Params::DEFAULT_OUTPUT_LEN)
                    .try_into()
                    .unwrap(),
            ),
            version,
            secret: None,
        }
    }

    fn generate_salt() -> Vec<u8> {
        let salt = argon2::password_hash::SaltString::generate(&mut OsRng);
        salt.as_str().as_bytes().to_vec()
    }

    fn hash_password(
        config: rust_crypto::argon2::Argon2Config,
        bytes: Vec<u8>,
        salt: Vec<u8>,
    ) -> Vec<u8> {
        let salt = std::str::from_utf8(&salt).unwrap();
        let salt = argon2::password_hash::Salt::from_b64(&salt).unwrap();
        let hash = to_argon2(&config).hash_password(&bytes, salt).unwrap();
        hash.to_string().as_bytes().to_vec()
    }

    fn verify_password(password: Vec<u8>, hash: Vec<u8>) -> bool {
        let hash = std::str::from_utf8(&hash).unwrap();
        let hash = argon2::password_hash::PasswordHash::new(hash).unwrap();
        // TODO: parse PasswordHash
        argon2::Argon2::default()
            .verify_password(&password, &hash)
            // TODO: handle error
            .is_ok()
    }

    fn raw_hash(
        config: rust_crypto::argon2::Argon2Config,
        bytes: Vec<u8>,
        salt: Vec<u8>,
        byte_length: u32,
    ) -> Vec<u8> {
        let mut out = Vec::with_capacity(byte_length as usize);
        unsafe { out.set_len(byte_length as usize) }
        to_argon2(&config)
            .hash_password_into(&bytes, &salt, &mut out)
            .unwrap();
        out
    }
}

impl rust_crypto::aes_gcm_siv::AesGcmSiv for RustCryptoImpl {
    fn generate_key(kind: rust_crypto::aes_gcm_siv::AesKind) -> Vec<u8> {
        use aes_gcm_siv::KeyInit;
        match kind {
            rust_crypto::aes_gcm_siv::AesKind::Bits128 => {
                aes_gcm_siv::Aes128GcmSiv::generate_key(&mut OsRng).to_vec()
            }
            rust_crypto::aes_gcm_siv::AesKind::Bits256 => {
                aes_gcm_siv::Aes256GcmSiv::generate_key(&mut OsRng).to_vec()
            }
        }
    }

    fn encrypt(
        kind: rust_crypto::aes_gcm_siv::AesKind,
        key: Vec<u8>,
        nonce: Vec<u8>,
        plain_text: Vec<u8>,
        associated_data: Option<Vec<u8>>,
    ) -> Vec<u8> {
        use aes_gcm_siv::KeyInit;
        let nonce = aes_gcm_siv::Nonce::from_slice(&nonce); // 96-bits; unique per message
        let payload = aes_gcm_siv::aead::Payload {
            msg: plain_text.as_ref(),
            aad: associated_data.as_deref().unwrap_or(b""),
        };
        match kind {
            rust_crypto::aes_gcm_siv::AesKind::Bits128 => {
                let cipher = aes_gcm_siv::Aes128GcmSiv::new_from_slice(&key).unwrap();
                cipher.encrypt(nonce, payload).unwrap()
            }
            rust_crypto::aes_gcm_siv::AesKind::Bits256 => {
                let cipher = aes_gcm_siv::Aes256GcmSiv::new_from_slice(&key).unwrap();
                cipher.encrypt(nonce, payload).unwrap()
            }
        }
    }

    fn decrypt(
        kind: rust_crypto::aes_gcm_siv::AesKind,
        key: Vec<u8>,
        nonce: Vec<u8>,
        cipher_text: Vec<u8>,
        associated_data: Option<Vec<u8>>,
    ) -> Vec<u8> {
        use aes_gcm_siv::KeyInit;
        let nonce = aes_gcm_siv::Nonce::from_slice(&nonce); // 96-bits; unique per message
        let payload = aes_gcm_siv::aead::Payload {
            msg: cipher_text.as_ref(),
            aad: associated_data.as_deref().unwrap_or(b""),
        };
        match kind {
            rust_crypto::aes_gcm_siv::AesKind::Bits128 => {
                let cipher = aes_gcm_siv::Aes128GcmSiv::new_from_slice(&key).unwrap();
                cipher.decrypt(nonce, payload).unwrap()
            }
            rust_crypto::aes_gcm_siv::AesKind::Bits256 => {
                let cipher = aes_gcm_siv::Aes256GcmSiv::new_from_slice(&key).unwrap();
                cipher.decrypt(nonce, payload).unwrap()
            }
        }
    }
}

export_rust_crypto!(RustCryptoImpl);
