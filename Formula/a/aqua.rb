class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.64.0.tar.gz"
  sha256 "77e7628db9caf7b1adc49f6c21c3e6a55f45697b712e53403fe4f7114132f32e"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "585d83426a39f1d2fe238d8f2f70c1a289aa8a3c713e6219b05c1cbcf864619c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "585d83426a39f1d2fe238d8f2f70c1a289aa8a3c713e6219b05c1cbcf864619c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "585d83426a39f1d2fe238d8f2f70c1a289aa8a3c713e6219b05c1cbcf864619c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c50a7755042e201e4927830e6cfc8f5d44050e29bbeedbcb85db0f7cd1af34a8"
    sha256 cellar: :any,                 x86_64_linux:      "10422fca598aa0a6f7632f966fd3ed60ad97f62d3dc8252397cabaed28a0f4df"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
