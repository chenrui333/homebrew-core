class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.180.0.tar.gz"
  sha256 "dbedc50f55f480e97292640cfb0fa99b52fbf6e16d4d0fa26a2893398a71c2fa"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "905e1e21ff37d34fba5a63ac0b6697e4ff60ee78a9adef206169c54894c72cf6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "905e1e21ff37d34fba5a63ac0b6697e4ff60ee78a9adef206169c54894c72cf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "905e1e21ff37d34fba5a63ac0b6697e4ff60ee78a9adef206169c54894c72cf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b147d27cc42c7f07a3a0ace51cbe608d92124d72b8a292f4dc6d92a2f09ac27"
    sha256 cellar: :any,                 x86_64_linux:      "65681fb879fad169804214fc2e0dc8fbd78df8d6f360ee45550d5b32cd7378c2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
