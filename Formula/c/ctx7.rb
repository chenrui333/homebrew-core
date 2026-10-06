class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.13.tgz"
  sha256 "46e4a139d59bea5fb380da6c1a521d0ec959c0e51dad7dc881ed9e2f1f381157"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d41eb22bdf67dbe76e67b084a37bec19bf241c0e5bb72dd108459030527a3b7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx7 --version")
    assert_match "Not logged in", shell_output("#{bin}/ctx7 whoami")
    assert_match "No skills installed", shell_output("#{bin}/ctx7 skills list")
    system bin/"ctx7", "library", "react", "hooks"
  end
end
