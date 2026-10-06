class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.21.1.tgz"
  sha256 "7df50c8b9d789b2014ce6d08332a07823e7e9f309a02c3b8f965cd1953c9c870"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1260e10e7f4fbf7ccfc5777f0d13178ce794157ae48ada25c38d91d6991ece9"
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
