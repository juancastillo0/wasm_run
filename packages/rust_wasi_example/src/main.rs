fn main() {
    std::fs::metadata("foo.txt").unwrap();
    println!("Hello, world!");
}
