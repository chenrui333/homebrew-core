class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-6.1.0.tgz"
  sha256 "ccdc61dfe4866538c5620d511a74b44bedc447924af9e53e3686e1d655c25231"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bcb10ae3028a2512973c3f375988b51798be9331c015d33c11638e0d3026f282"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
