class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.118.0.tar.gz"
  sha256 "0548e7d053004af5e0dbba0b4a4b7c796cc777aed5e44e4264abc74ea6b5995b"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79f029da96b78273a2e2d466f76ce378eb2ffa01329c6777d6d84b901349c188"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79f029da96b78273a2e2d466f76ce378eb2ffa01329c6777d6d84b901349c188"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79f029da96b78273a2e2d466f76ce378eb2ffa01329c6777d6d84b901349c188"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d85910421955d8f53322f2b2a719a56a849ce43cde53b10c1b1e13e86d35d2a"
    sha256 cellar: :any,                 x86_64_linux:      "cdd8b0ebcc73a2b66cff470e58fdf5a8176413b0ec42499432874f2efe6391e3"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
