class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.9-1.tar.gz"
  sha256 "501721d12108004f24e2a9d53d0019499f946e39d374900fb2de34ba2bbecdab"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d34951037acd5f348f8be1d8b47fd0f21f5964cae87eee3891a7cbb4f0215b36"
    sha256 cellar: :any, arm64_tahoe:       "68a68149bdb2f8dd91da35fbe9a93dd38856a5224f8f5bef6572167b5f4f4abb"
    sha256 cellar: :any, arm64_sequoia:     "ac903848c5f5a2559d824bf3d81af8666bf404b5c66b6bb9b9a90a70803f110f"
    sha256 cellar: :any, arm64_linux:       "fd60d7d271e917ad7588f27218dbb7d6f37442e56bd648de9f307d9c0a256a05"
    sha256 cellar: :any, x86_64_linux:      "b0aef62a64bce0a9cc293699e99f0f26178242c0f05aa59d8a3f469308336b0d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mariadb-connector-c"
  depends_on "pcre2"

  # Use portable close-on-exec pipes, upstream PR ref, https://github.com/mydumper/mydumper/pull/2363
  patch do
    url "https://github.com/mydumper/mydumper/commit/585fc5ab687e6a57694490177d52bc9dda47bed9.patch?full_index=1"
    sha256 "e46de97c4ae0eb34a4ca6234a8f4fa7f762266d9ada0ea635787242eb0c17921"
    type :unofficial
    resolves "https://github.com/mydumper/mydumper/pull/2363"
  end

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # avoid openssl linkage

    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{formula_opt_bin("mariadb-connector-c")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "metadata file was not found",
                 shell_output("#{bin}/myloader --directory=#{testpath} 2>&1", 1)
  end
end
