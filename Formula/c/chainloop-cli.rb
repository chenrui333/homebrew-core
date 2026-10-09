class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.122.0.tar.gz"
  sha256 "d56d5efa3e7aaae92399940ddcb7c8ce911d115b2d62fe78761a47fefb10e129"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d58cfa65c2c9188b1b68165bae7084456ba2176b9bd6352c38c87de161876f6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d58cfa65c2c9188b1b68165bae7084456ba2176b9bd6352c38c87de161876f6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d58cfa65c2c9188b1b68165bae7084456ba2176b9bd6352c38c87de161876f6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d31c09122c1e7b108a856553a4171ac336aabbf8f232fdead017f7d61cf49d6"
    sha256 cellar: :any,                 x86_64_linux:      "b7186efe87812466195eb674b6747d04daa090c1af594fe0a48f6acb8d1f064e"
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
