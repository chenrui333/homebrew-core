class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.12.1.tar.gz"
  sha256 "167c1781062d2621f2d07059e71f5b1e1aa0560798d7799971681808a6d42ed0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3636ee09127ffb3746ab27d5f00a73910322ec4ad3aa17e31f323fb7cad5380" => :catalina
    sha256 "c21b0eb4bb7e9060ae39cb80d2b02c780d0bb26ac573bf5024aac9c12d57650e" => :mojave
    sha256 "986f19287953b58c8a9e29bb026c558bfc30b32dfb8c2b64d92b6adc3a36c011" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar", shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats best foo")
  end
end
