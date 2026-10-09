class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.733.tar.gz"
  sha256 "70f7d051626d1305c93c5a2bf56ea037e5ddc0e9e0b0ae437ab794d4dba32a84"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "751cd879f778f0063c1f8b307f094b53e1b42375efce23f77b6503159894c2db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be84147fe799a68642c0e32a5c1d088348acf654d2d0b790d1a296fa88d22a94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1548d65267df36c5e804013e85f83ba9ebb6d598f31e1f3923914e788235f067"
    sha256 cellar: :any,                 arm64_linux:       "cfe353aec1a2ecf60ea5cbe69cb3e2592bea4d0a48db1d5f175af63ea73185e2"
    sha256 cellar: :any,                 x86_64_linux:      "351abce0caf78f8d878e7a26f36455fc9893285acf41afe1e2fb8e2d9b2eb7e4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
