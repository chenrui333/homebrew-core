class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.11-1.tar.gz"
  sha256 "7de75355e0320506ebc353e110001fb30e61d44c4524ee5f9ca620dcb3474109"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bd04bf66fabc1d209cd5e3010a52e5e9cf4dfbec1d090c26ec78a32417d1c0bd"
    sha256 cellar: :any, arm64_tahoe:       "87fe9ab914c6a01fa54c1601fb7d06a13ca72f19665c8ddd7087100543a05f9c"
    sha256 cellar: :any, arm64_sequoia:     "45671f9c0d08c96a1e5c3235c5f3c406c6a8688267e7d87fda515acc5ed6e923"
    sha256 cellar: :any, arm64_linux:       "8197d11ea5baef0004cda0e805ca9f609751bb6204a4d74ba4e81f8b0de079ed"
    sha256 cellar: :any, x86_64_linux:      "b3e3a1b32959d502c41164e8544adf4f64d8c7fe39a3fc7a16bdcfddb1b719f8"
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
    assert_match "metadata file was not found",
                 shell_output("#{bin}/myloader --directory=#{testpath} 2>&1", 1)
  end
end
