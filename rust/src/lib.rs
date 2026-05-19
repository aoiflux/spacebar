mod frb_generated; /* AUTO INJECTED BY flutter_rust_bridge. This line may not be accurate, and you can change it according to your needs. */
use sha3::{Digest, Sha3_256};
use std::fs::File;
use std::io::Read;

const BUFFER_SIZE: usize = 1024 * 1024;

/// Computes SHA3-256 hash of the file at `file_path` and returns it as a hex-encoded string.
pub fn sha3_hash(file_path: String) -> Result<String, String> {
    let mut file = File::open(&file_path)
        .map_err(|e| format!("failed to open file '{}': {}", file_path, e))?;
    let mut hasher = Sha3_256::new();
    let mut buffer = [0u8; BUFFER_SIZE];

    loop {
        let bytes_read = file
            .read(&mut buffer)
            .map_err(|e| format!("failed to read file '{}': {}", file_path, e))?;
        if bytes_read == 0 {
            break;
        }
        hasher.update(&buffer[..bytes_read]);
    }

    let result = hasher.finalize();
    Ok(format!("{:x}", result))
}

/// Computes SHA3-256 hash of in-memory bytes and returns it as a hex-encoded string.
pub fn sha3_hash_bytes(data: Vec<u8>) -> Result<String, String> {
    let mut hasher = Sha3_256::new();
    hasher.update(&data);
    let result = hasher.finalize();
    Ok(format!("{:x}", result))
}

/// Computes BLAKE3 hash of the file at `file_path` and returns it as a hex-encoded string.
pub fn blake3_hash(file_path: String) -> Result<String, String> {
    let mut hasher = blake3::Hasher::new();
    hasher
        .update_mmap_rayon(&file_path)
        .map_err(|e| format!("failed to read file '{}': {}", file_path, e))?;

    Ok(hasher.finalize().to_hex().to_string())
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs::{remove_file, File};
    use std::io::Write;
    use std::path::PathBuf;
    use std::time::{SystemTime, UNIX_EPOCH};

    fn create_temp_file(contents: &[u8]) -> PathBuf {
        let mut path = std::env::temp_dir();
        let nanos = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("system clock before UNIX_EPOCH")
            .as_nanos();
        path.push(format!("spacebar_crypto_test_{}.bin", nanos));

        let mut file = File::create(&path).expect("failed to create temp file");
        file.write_all(contents)
            .expect("failed to write temp file content");

        path
    }

    #[test]
    fn test_sha3_hash() {
        let temp_path = create_temp_file(b"hello");
        let result = sha3_hash(temp_path.to_string_lossy().into_owned())
            .expect("sha3 hash should be computed");

        // SHA3-256("hello") = 3338be694f50c5f338814986cdf0686453a888b84f424d792af4b9202398f392
        assert_eq!(
            result,
            "3338be694f50c5f338814986cdf0686453a888b84f424d792af4b9202398f392"
        );

        remove_file(temp_path).expect("failed to remove temp file");
    }

    #[test]
    fn test_blake3_hash() {
        let temp_path = create_temp_file(b"hello");
        let result = blake3_hash(temp_path.to_string_lossy().into_owned())
            .expect("blake3 hash should be computed");

        // BLAKE3("hello") = ea8f163db38682925e4491c5e58d4bb3506ef8c14eb78a86e908c5624a67200f
        assert_eq!(
            result,
            "ea8f163db38682925e4491c5e58d4bb3506ef8c14eb78a86e908c5624a67200f"
        );

        remove_file(temp_path).expect("failed to remove temp file");
    }

    #[test]
    fn test_sha3_hash_bytes() {
        let result = sha3_hash_bytes(b"hello".to_vec()).expect("sha3 hash should be computed");

        assert_eq!(
            result,
            "3338be694f50c5f338814986cdf0686453a888b84f424d792af4b9202398f392"
        );
    }
}
