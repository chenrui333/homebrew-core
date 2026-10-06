class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.280.tgz"
  sha256 "0f60de931abda9e6a54862fc755b0cd8422cd4feb81c1c832151eeb0800b9140"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc23b11421b6f6afb8899ce3e2e682ccab3bf60ff1d90eb30b411082439e8504"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc23b11421b6f6afb8899ce3e2e682ccab3bf60ff1d90eb30b411082439e8504"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc23b11421b6f6afb8899ce3e2e682ccab3bf60ff1d90eb30b411082439e8504"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ee4eb385cb594fc239cd4961bd7e6f8a476e5f80a7d3719b40c5178be1e9ad4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b97124f7d60152d4aa5f3e3e3b117618d4552d8cade618fbff0ad58fb0f669eb"
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
