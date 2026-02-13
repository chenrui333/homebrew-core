class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "bc04eeb47b1907d062cf74f96b5366bdae5bed00291fdd920b2186284d02504a"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53c7a978cdffcac203e5519629477f83ea249c043f92648fae9150b8c9e92dce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53c7a978cdffcac203e5519629477f83ea249c043f92648fae9150b8c9e92dce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53c7a978cdffcac203e5519629477f83ea249c043f92648fae9150b8c9e92dce"
    sha256 cellar: :any_skip_relocation, sonoma:        "c85acd75afc0dd4703636fcd7f3b04d8bacd1a79cad1cf42cd9c1c1a0fa1dc8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d89c17dcf64d3ab5cf3588d4d3841dabb768eb30debd0bde778eb9d82c8e17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "322feffb51a0318c607a4129b8f7128cb63e238300ff343a67f4cdea83dc135d"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
