class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.31/ktexttemplate-6.31.0.tar.xz"
  sha256 "461c0d1672430f646d98d89ec226912f7ace031fda020a209b9ce270fd146c0c"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "bf471cc5e0eb1cda3f7db8c813aaebd823d80640b5d3758a9b6fd78561afa608"
    sha256 arm64_tahoe:       "010a562bc13b5a87de5ca434c23e16ae6648aead8ea9f97352fd5e8116cf8c15"
    sha256 arm64_sequoia:     "bbfc8509dc80a14d06cf882f0e27724c6faa4bc191fb54e242c5a9f3ec98998f"
    sha256 arm64_sonoma:      "0095d6a8cbe5302ed41fd260c04929565412554d600c67727edfba5c193d5115"
    sha256 arm64_linux:       "58fe7cdd381e546ea61f1b63a825e1185dae92e90dd11eceee96bce9556f533d"
    sha256 x86_64_linux:      "92d74f2d662bddee2e5bedd6b6a82bce38c5ad931893e8edb9e42d554c50c6f6"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qttools" => :build
  depends_on "qtbase"
  depends_on "qtdeclarative"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system "cmake", pkgshare/"examples/codegen", *std_cmake_args
    system "cmake", "--build", "."
  end
end
