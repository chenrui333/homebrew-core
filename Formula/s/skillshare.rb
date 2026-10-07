class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "21f751f000b0f9a094bce06bae933dcdfda3f8cd5752093e75a17d09e00f86c1"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1170ccb3ce41e0ed12c074d610f8c23b5b8093276aa0e4c906eb4613dd88d85d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1170ccb3ce41e0ed12c074d610f8c23b5b8093276aa0e4c906eb4613dd88d85d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1170ccb3ce41e0ed12c074d610f8c23b5b8093276aa0e4c906eb4613dd88d85d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e92506ebc981a71cf9c4870b5040f8c4eb79d43fa16488dc8af92ae617a83c4f"
    sha256 cellar: :any,                 x86_64_linux:      "a110b4d3eef9b14ec74550eef21e7b07e08022c9a11c84341af1147a9c0a955a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
