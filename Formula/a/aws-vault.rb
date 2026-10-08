class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.16.1.tar.gz"
  sha256 "a7267afa4e10eb83b0b2d01b076d800c592a5d1a656b09806849265dceb5dcc9"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be2706033c2c1188e31fcb5872714d8b26f862b106547791668797ad85749983"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b696760fe0787ace8c90639c68654684b7a90495e1b85fa80743f436ad464e46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4daa3cf890b3d6e5e9d1799b8ade452685a6d1a19567018009e59fa5a25415fd"
    sha256 cellar: :any,                 arm64_linux:       "0fdf114c6b94953034f93531b1813e17983ea33d761fd06f04c567e9597cd185"
    sha256 cellar: :any,                 x86_64_linux:      "aa2a72ea5758c4c0bae951d7e26b617e11de3575752810f592db75b2b71da6c8"
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
