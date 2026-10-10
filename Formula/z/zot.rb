class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.25.tar.gz"
  sha256 "2563cf18a0394df79fd9eca5734c7bacf55993c2544237020c5a3bf48676c216"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36ddb88dd5e1a938da59ab81a5c6be4209c3f9e9cf3b6e5e917c44a22e5c2326"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36ddb88dd5e1a938da59ab81a5c6be4209c3f9e9cf3b6e5e917c44a22e5c2326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36ddb88dd5e1a938da59ab81a5c6be4209c3f9e9cf3b6e5e917c44a22e5c2326"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "997b265d098b58d7634a12399a4609ede006b228c4aec825487543c23fa2bf79"
    sha256 cellar: :any,                 x86_64_linux:      "c651a920e9f6c1b24397c73404b1e18583dd385694e25381121c3aa013e7ce88"
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
