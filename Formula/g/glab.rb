class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.85.0",
    revision: "e1ca262b84d023678dff220d67dc63484058723e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d54297ffb46bc3a3df67ba0ff3c68f691803a8f5ec70f39ba835cfa27e20795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d54297ffb46bc3a3df67ba0ff3c68f691803a8f5ec70f39ba835cfa27e20795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d54297ffb46bc3a3df67ba0ff3c68f691803a8f5ec70f39ba835cfa27e20795"
    sha256 cellar: :any_skip_relocation, sonoma:        "a65c1874e40cb32dc4f8ac1b6d3e234593969d4f63ff9c8a1e77802f320cfaa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c638406c014878feac34077682d5cf40079f7de9d870cea16d5be18938decbfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9a956ffbe2a2148e4d8ea33a50b7ce15d555a69d3715823ccef0e08edddfac7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
