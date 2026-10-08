class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.20.tar.gz"
  sha256 "8b016f77a195e7c7b48c049423004a6daa6f10b96b592f242b4aac834146d0a1"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "24b0f6615fd9f13a296c0dad2c35491727eb392e08c504d1d68781b722a477b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24b0f6615fd9f13a296c0dad2c35491727eb392e08c504d1d68781b722a477b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "24b0f6615fd9f13a296c0dad2c35491727eb392e08c504d1d68781b722a477b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dc455a8983d39e438c0542cf7fcb3e6e45380e246ad838037ee150fa0a289151"
    sha256 cellar: :any,                 x86_64_linux:      "5f8ffc3f8a6b8ba247ab01318d2e61300d44e5323abc2bb423730da6217fd61f"
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
