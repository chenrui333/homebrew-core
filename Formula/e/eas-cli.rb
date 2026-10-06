class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.11.0.tgz"
  sha256 "2549813f6aee3b65d352d763ac7623e4c8480de492b38d8b5e068e6e6e1733f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb0076edc9b250c6692e3fb5a333ce028a8b33231373c7205430f2dd951f6c18"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
