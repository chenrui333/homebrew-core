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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc82783dd58c1cdb1c374417a9a6050553b76f05c35a105b7c942c2299375c59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc82783dd58c1cdb1c374417a9a6050553b76f05c35a105b7c942c2299375c59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc82783dd58c1cdb1c374417a9a6050553b76f05c35a105b7c942c2299375c59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "866cfb7ffe37f1583987406159ba008c68188ee65aa0ced229fa725acc9696c1"
    sha256 cellar: :any,                 x86_64_linux:      "9cde1bd31e19d1a63305cda5527206868520e873ba94649dba054258e2d76aaf"
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
