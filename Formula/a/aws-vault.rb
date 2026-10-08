class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.16.0.tar.gz"
  sha256 "3d3e616ee986084fe3448e5b20ec0ca18ff99e7e1e8d22c955d56a4238228f15"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5d7a4747665f1ce6d966ba836c9b53f63888fa34e6b331bb2172542cbf15842"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f47d9022211e171018cc5c508a58b1c1e30d368cf307c48c0ec0d54a2f57dd5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6373344f3359b1a6f5112ae0bfaab7e524fc172fa133e6a5024be43578aef142"
    sha256 cellar: :any,                 arm64_linux:       "46b36ed4438d6429811e596c56041b527f9ed3d1b1feb412280361a006437b32"
    sha256 cellar: :any,                 x86_64_linux:      "37062d71650c01fe6dac5048d993af3ea297430c23fc62800ea5e33b90b859ea"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}-#{tap.user}")

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh" => "_aws-vault"
    bash_completion.install "contrib/completions/bash/aws-vault.bash" => "aws-vault"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: unable to select a 'profile', nor any AWS env vars found.",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end
