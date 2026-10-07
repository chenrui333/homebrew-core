class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.5-1.tar.gz"
  sha256 "2c2307f1655728b59a6874cf6ccbe85ffea26977fb698eaf62a56976bcf5991f"
  license "GPL-3.0-or-later"
  revision 1
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
    system bin/"mydumper", "--help"
  end
end
