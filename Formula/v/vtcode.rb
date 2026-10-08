class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.174.0.crate"
  sha256 "ce165878bed6d9760a1f9c3f2270baa1e4ce59ccb4f0e39169034d28ed982d69"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7079a0d1202e4a1a344519e423cb6fe0a889d95e992a6f8dac7bc19a4ef160e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9cf521be67f76ceb5752528b96d55419516cc05481108ed7f2b59095d674472"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab3f5bfd4e5a599a7e4f90785d4aa325b5f69d5831a2fca92f186318f1272e61"
    sha256 cellar: :any,                 arm64_linux:       "c3f09e2af9a5842583d57199edee75faaffb73720f4e8b96d49969476ae46375"
    sha256 cellar: :any,                 x86_64_linux:      "9c4b649db02106d3d5b1065905b298e42574f10a54c133a67b43817ab6727c05"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
