class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "5d37e2e67b65514e16eed1df39395320ecead6795b925df16a9dccf4172f37e5"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6474aecd525c0df5bbd8cb7dc42f0056d28c6b1a31132cfbaf0cefc9c48afe6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2be17e3b157bebc22f9b2af96cf2252a1c3e686692e25edcc7799302b66d0cb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89ca37fccce8c984bb1e927dcca4290ff7f9075f8073db0a7cf095966fe3bb72"
    sha256 cellar: :any,                 arm64_linux:       "89d63ab9a5056390195b2fc1c26696ea2f3d21f2fce91837586af9cb1f2bc76c"
    sha256 cellar: :any,                 x86_64_linux:      "474d8f237369a6488a83705bfd2a0be87bdcf7bd9dffd9eff018c93f0e2487e2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  # Remove when goose's `llama-cpp-sys-2` pin ships cpp-httplib >= 0.43.1
  resource "llama-cpp-sys-2" do
    url "https://static.crates.io/crates/llama-cpp-sys-2/llama-cpp-sys-2-0.1.146.crate"
    sha256 "9b291e4bc2d10c43cd8dec16d49b6104cb3cb125f596ec380a753a5db1d965dd"
  end

  def install
    # Backport https://github.com/yhirose/cpp-httplib/commit/02d38251495ed7795305ad5bf34b3e20b9b52156 for OpenSSL 4
    resource("llama-cpp-sys-2").stage(buildpath/"llama-cpp-sys-2")
    inreplace "llama-cpp-sys-2/llama.cpp/vendor/cpp-httplib/httplib.cpp",
              "X509_NAME *name = X509_get_subject_name(cert);",
              "auto *name = const_cast<X509_NAME *>(X509_get_subject_name(cert));"

    system "cargo", "install", "--config", "patch.crates-io.llama-cpp-sys-2.path=\"#{buildpath}/llama-cpp-sys-2\"",
                    *std_cargo_args(path: "crates/goose-cli")

    generate_completions_from_executable(bin/"goose", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
