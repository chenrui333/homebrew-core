class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.12.1.tar.gz"
  sha256 "4fa06897fdf38e7ba24c7686cb153c91aeed308586b73e0833097d9d24e75a5d"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c36ced3c5a2207739a050eb408f457db665ae30f2b5468d8ea2d56b8c791a64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a70fbbeb24e80945e7b8a7ee9b18fd63cce75ea2b31a8cd9455f9626686e548f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f32d349a9a076f98d8bb051d613af1de7f8f1cb6d908928292e0199988e3e57d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac485213f764dad179aa7fdbe5d7de3bc956f7c013504931735520fe32cabfcd"
    sha256 cellar: :any,                 x86_64_linux:      "b1ac8d450416618c514aa589eb9a808e8f8f8405739da7753dfad4d9d8695347"
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
