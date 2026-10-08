class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "b3887c5eb169049c405c87c1414cdb2d84056ef2defeec7a90e78bc97bd684f7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72e8067f08fac65372e97d39311cf919173b82b5a8362d7cc45a775132c49ed1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f9802cdf82be5cdc6c3ff529d764f61957a1a295ee033e178adee8061dab8845"
    sha256 cellar: :any,                 arm64_sequoia:     "46bab7ef17c2ea3d58f05d3aba8482c11a7f8576f21ce603b426b18ec4eafb81"
    sha256 cellar: :any,                 arm64_linux:       "ab7df26b794557681dc5879b73d08c8310a6aba75504b3a7076211bbc5206aa9"
    sha256 cellar: :any,                 x86_64_linux:      "32a4815ec7a40c682f463b0078801b801afb75f5d8f35ddb324240f70a506e5f"
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
