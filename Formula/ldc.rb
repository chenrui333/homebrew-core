class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.21.0/ldc-1.21.0-src.tar.gz"
  sha256 "50b7f929bf6b285c5b6618dd32162838daa2788298f25e669570df3fdc0716d8"
  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "122d9a37cccbd671d223a2ce683ad141489633d2f11fa8f662635f6ba4a49027" => :catalina
    sha256 "67f9bdd412e9ee9e6864f52ae5b52358a01b93de359fe8aad4b9d7bed73a572a" => :mojave
    sha256 "7945dba30bfac0ced442b69a46a477593ee04e3b3f28cc6fdb56b94f58e94706" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "llvm"

  resource "ldc-bootstrap" do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.21.0/ldc2-1.21.0-osx-x86_64.tar.xz"
    version "1.21.0"
    sha256 "a63939fe484b955cd0dfc6439a8743ad0f96e473335caa0fe1151853c70d98a9"
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      ]

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=thin", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=full", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
