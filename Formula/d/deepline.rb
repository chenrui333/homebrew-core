class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.320.tgz"
  sha256 "f682ab8737397a27080f3593ee9a063abf311c2460b186c139b529877007dc74"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbe9647a294589e20141932a2ce4ab8f2806703dc858bb979cf2ce4d63a7f7a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbe9647a294589e20141932a2ce4ab8f2806703dc858bb979cf2ce4d63a7f7a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bbe9647a294589e20141932a2ce4ab8f2806703dc858bb979cf2ce4d63a7f7a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b12ac5a39a253b4f5cfaf1be4abc32f5c7f34da5661a83a4e9e0e061b160fca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "088f4b0a49814679191393db63893a9cc898e849bbd27447bf40a30d0dc18d9b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
