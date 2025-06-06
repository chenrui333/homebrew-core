class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://apps.kde.org/kcachegrind/"
  url "https://download.kde.org/stable/release-service/25.04.2/src/kcachegrind-25.04.2.tar.xz"
  sha256 "cf4f8d9471ffe24fc42537eed00a0bf9feea0e9d705334bf8c5c3176d8b7cc6b"
  license "GPL-2.0-or-later"
  head "https://invent.kde.org/sdk/kcachegrind.git", branch: "master"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "2200056604108fee6b32bf8006ca58a68a1f81449c0c610ec6deeb253ae9af1e"
    sha256 cellar: :any,                 arm64_ventura: "1ea1fe4335c81b3e27d07af79fa97f41375f4b4166847533beb4a39ba11a00bf"
    sha256 cellar: :any,                 sonoma:        "b35ff5662eba866ee5e9d012496a4381c54ddbc3a66f6f74926255616b178f77"
    sha256 cellar: :any,                 ventura:       "714ffbe8f467597bd50532d38f2ef6be67ab99936f0ffce45ca1b62f0916988d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "874655d3d8bff49f3953b927a835c14864b03ccb14b526c77ecbcec98e3eb2b8"
  end

  depends_on "graphviz"
  depends_on "qt"

  def install
    args = %w[-config release]
    if OS.mac?
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args += %W[-spec #{spec}]
    end

    qt = Formula["qt"]
    system qt.opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
