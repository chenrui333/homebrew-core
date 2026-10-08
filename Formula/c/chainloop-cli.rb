class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.119.0.tar.gz"
  sha256 "dedab3d91e934aa397491fe6e89b6f0dcab187af670957484707958be5e65b21"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1331b80e5c09b3c0bc4a1cb1a8ec6255a40356d1e51111ee54b663a06760881"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1331b80e5c09b3c0bc4a1cb1a8ec6255a40356d1e51111ee54b663a06760881"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1331b80e5c09b3c0bc4a1cb1a8ec6255a40356d1e51111ee54b663a06760881"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "11be122e93e27d5f9d49e9df691b2a984ea1af7591ea56069cf19f38e095d9c7"
    sha256 cellar: :any,                 x86_64_linux:      "fbe1dc8fbd2b318cdb0d2a6456d3bfb2639f43b0ab8a51f6c0ecc454e3f8d5aa"
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
