class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.15.tgz"
  sha256 "8195087288f5bbd60088026897b16558b77b84e9410ca33682ddeb898694251a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a14b9fe4ac23379e0694d0bcc969b071ef8419c75792868dc153671f9622f40f"
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
