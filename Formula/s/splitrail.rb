class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "58c4afd633b57055f0cdc2a4f81788a8245558c2127e5f58194d841f2dbbe1dd"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ad6669d40daad87d750f3ad3572ccc8da7dd100107c6f26ad8c74ec98bfc093"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "835e8c116e3a627908537799e83f2beb0d65e3d2fae3000d736538391301b5d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca22249870c76fb000741b1486608f2e762a0dff175af32c6cd2fc0a2e19a69d"
    sha256 cellar: :any,                 arm64_linux:       "da3e7cd1d3277e8d66b253b5b4679278f8083f9b807921274ea1a18b00155e8d"
    sha256 cellar: :any,                 x86_64_linux:      "d2d321b7c7f2f16dc64df7b0c19fdb8c66c103085b97e8b8170f0700f0dbbdee"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
