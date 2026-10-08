class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "78f0fbda91559ac45814bf88001609c39293be2886a9881d3b5d51c16e6b8ca7"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21661b3e03b415dbfefd6e142d1a762c32301e9c14e99618bfc84e399896c624"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21661b3e03b415dbfefd6e142d1a762c32301e9c14e99618bfc84e399896c624"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21661b3e03b415dbfefd6e142d1a762c32301e9c14e99618bfc84e399896c624"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "424053abb751c32f1cc66e0f34eed3ea0a92477cd279dc4f6c57ed953be809bd"
    sha256 cellar: :any,                 x86_64_linux:      "4c174691da4c07211f88dd231ae03bdd7070bced36bff5b889a4274331cb9d28"
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
