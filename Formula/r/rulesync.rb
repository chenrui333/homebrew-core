class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-28.0.0.tgz"
  sha256 "653f5cb49f4d4be335e0af1bd118124c5cef2cdcb9edcddad2d3a12098b94df8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0864d72d82bd746c3629942cadcbd81334d3798dd699da6fcc2d2f977bdca39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0864d72d82bd746c3629942cadcbd81334d3798dd699da6fcc2d2f977bdca39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0864d72d82bd746c3629942cadcbd81334d3798dd699da6fcc2d2f977bdca39"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a61479d46315bc7dd66fe6a73e5ec96f575162d2d79086c1abf69433ed7569a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a61479d46315bc7dd66fe6a73e5ec96f575162d2d79086c1abf69433ed7569a3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
