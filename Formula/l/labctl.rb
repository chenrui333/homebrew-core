class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.114.tar.gz"
  sha256 "956fa49203c75fc255909473a2a7f9fdd4cd272e64a15628a692264e544bea04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f27f83bb58787f178b1f0234c678281712647810d1f5db425d08fad649c83d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f27f83bb58787f178b1f0234c678281712647810d1f5db425d08fad649c83d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f27f83bb58787f178b1f0234c678281712647810d1f5db425d08fad649c83d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2448bad3508ab8b5fd7191b156588db375e5e58d9a91660bba1d645dd1de2a2c"
    sha256 cellar: :any,                 x86_64_linux:      "df53cb3b392a3f4cdd9d45b5bed18cb13a6f8d5f83ea1d2f1da93d22a52f39f0"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
