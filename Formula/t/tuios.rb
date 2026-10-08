class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "7b48062f4e5e3548ba363a12d8cf3366f29fc6ded2b99306c722be32078a2124"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e388d7034772f1b6965fd088debd2a24d7231554a5702fdae573dc1df998baa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5f281898abe381c23ff8fc83ff95a821c4f4bf34a17538e386b321ab2ec3d54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a3db3d5ac49125cdee038ef8850fb5b711ce74da192deef034e8a2120c20f14"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3cb99c874b0b82a32296b59d6eef509bf5eda8b25a71c25919baa3fa0793143"
    sha256 cellar: :any,                 x86_64_linux:      "33898aaa4e754fd86dbb7c51bf7b446592518b180cd20334c7bb7c8deb72a292"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
