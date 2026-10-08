class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.61.1.tar.gz"
  sha256 "31147adad81f48b29a4a729e16ea980807028c528f6fe36261f62fd0d917c306"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "12804f8aa149568a3e7dab7c3dc5879e4077e9cd9de00a5a7d6492209f0c64eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb8648525a9f815262d65f8bb0ce035f17fac0698b3178b7a6baca8fd837a649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8a456de10deed2d36910b4cc47cac902c580765a977bce600e4d9ebb1666d9c"
    sha256 cellar: :any,                 arm64_linux:       "876750cb217235eec6ff542e6e786ed858a2db2de79b24ab935b1b45ff285043"
    sha256 cellar: :any,                 x86_64_linux:      "3e4252d210848b29db53fe4a30ae7c459253447d9ff73c5e381328958ce29db6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  # Test downloads dprint formatter plugins
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
