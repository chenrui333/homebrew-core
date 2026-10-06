class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.12.1.tar.gz"
  sha256 "4fa06897fdf38e7ba24c7686cb153c91aeed308586b73e0833097d9d24e75a5d"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f61c53e12dbc2fcc9e9d67b2f3d9ae3c9bca9528d36fd5dc6452c89577bb83c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64b3939f627f426364606d65792af5ba342ce261f6c44aa8c312a4bd971d55f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d55ed86e9e99aa545371efeeadfe1aa12b17af1942d62e35c40227d20e7a343d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f72a89c51a988d5ab3d2502493934c43a9c1c201bde2a36dc5cde1afa87b6659"
    sha256 cellar: :any,                 x86_64_linux:      "c618198c21de78faff89c92fe3cd839fa495d5d91a7a7aeb5d62c46d3769ba83"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
