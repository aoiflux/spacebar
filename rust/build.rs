fn main() {
    // Re-run build script if Rust files change
    println!("cargo:rerun-if-changed=src/");
}
