class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.7.2.tar.gz"
  sha256 "5a03b69973f0ec9e83cff3091355339309a679be46d525e196a20955df10bec3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b9f39d33edd663114d2fed24cd5ad3d4d0f93fe1719bcbc301dc5030b9a0c6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd2738a6112c81e014257b86f866d2f36503586882e2f0d8fa2929a03f38ee7b"
    sha256 cellar: :any,                 arm64_sequoia:     "38718f16780e8408fe7e3819e88580cd19fd67609526ffb0edf31e3f426ad4d9"
    sha256 cellar: :any,                 arm64_linux:       "2a9901437bbbc60944e6ccaadfd473e93cf9d420ea7bd2c9d85291a334ea14f7"
    sha256 cellar: :any,                 x86_64_linux:      "bbc054921d0eea9ce8aa0fd31c2535684bb5614039d3ce65e62e087dbab005d2"
  end

  depends_on "python@3.14" => :build

  on_sequoia :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "floating-point `std::from_chars` requires macOS 26 libc++"
    end
  end

  deny_network_access!

  def install
    if OS.mac? && MacOS.version <= :sequoia
      # Link LLVM's libc++ as the system one lacks floating-point `std::from_chars` before macOS 26
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
      inreplace "Makefile", /^CXXFLAGS \?= /, "\\0-D_LIBCPP_DISABLE_AVAILABILITY "
    end

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end
