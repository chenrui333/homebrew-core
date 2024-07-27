class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.3.0.tar.gz"
  sha256 "b1f979f48f4c52f71821f4b2983ef26cf08fc58337effe5651155cfaa96ce95d"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c33a3c53872c2cf138d6d36a30697feb3c772df7c3af38b18d06011b5c3dd1b3"
    sha256 cellar: :any,                 arm64_ventura:  "9ced34617c452cd53fbb22fac4a25b00a7f747efe87bde70d8fac53478c94c19"
    sha256 cellar: :any,                 arm64_monterey: "60a30c4782d5683eb45f4e516eddc2e826eae8e0be59496ab7b82d2775417244"
    sha256 cellar: :any,                 sonoma:         "077224340fa1ac1f8cb9842ae4aa0db9cf306f0540189ecd1c16c298f2aa5e86"
    sha256 cellar: :any,                 ventura:        "129e3bf0325c241fb4f8ae144c90e8e53845ada18ca753019d5705a22eca4148"
    sha256 cellar: :any,                 monterey:       "645af9d42c7d9fb7b012f42bb2181d876f9b36e678cfd9441d8b74379c8eec8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "787ffbba1df2908f13390d16ce3ffac1976f2f2acd937e3b2b33bc3f5af16fe4"
  end

  depends_on "libpq"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "sqlite"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    system "./configure", *std_configure_args
    system "make", "install"
    (pkgshare/"test").install Dir["test/*.{c,cpp}"]
  end

  test do
    cp_r pkgshare/"test", testpath

    cd "test" do
      system ENV.cc, "select.c", "-L#{lib}", "-lpthread", "-lzdb", "-I#{include}/zdb", "-o", "select"
      system "./select"
    end
  end
end
