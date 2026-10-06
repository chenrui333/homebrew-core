class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "155301eeeebf21aad344ce993daa27c6f9da2a9af828e68eb4e1a83c3834e0e3"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d63c82b55e4a33dad5114f149e737b35f3fa2dfcce754283197d9b36f2c44109"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d63c82b55e4a33dad5114f149e737b35f3fa2dfcce754283197d9b36f2c44109"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d63c82b55e4a33dad5114f149e737b35f3fa2dfcce754283197d9b36f2c44109"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8c67f66488a4157705a98a589900dabf3b2e95f3d7f2cfac4ed4895b3ac7c08e"
    sha256 cellar: :any,                 x86_64_linux:      "d827356a6bec5ff808d6a059d67651cda5774320d7fd1954a8c99f7b2d2ab0d0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
