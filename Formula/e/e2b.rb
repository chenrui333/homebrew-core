class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.21.2.tgz"
  sha256 "7e5031ce254e327b9904031938b0a3885603edc6f6b06bf612a1207dea0bd0a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cb09e9129c8c9c694bbd0f5de85e02b8f7d8b59e5e5e049e18e30ced2d5b0be"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
