class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.736.tar.gz"
  sha256 "00c401d133c3461a5ca11dd2cf32d5c9e3fadbd64a90f01d4c495a4c21f37a28"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8352652019d53cae7bf363d306b46fb29d456f9d80536b78c20b4e2edaf66019"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fedc02cf8429acb1c7fe504d04cec6896bf2a619a3f6125a2c09e61786b0c119"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4114cc6f5fa57d9a192c6764422ebf698c393a634852094bb9b8bea3d3be574a"
    sha256 cellar: :any,                 arm64_linux:       "47308e52b055cf0e9c2217bafa97d0be23c8e64b602479c7fe279fc9c6128dbe"
    sha256 cellar: :any,                 x86_64_linux:      "5453d606d346b82ccf12d298656ccfee15df2645402ac4a17a4c0a77b926699e"
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
