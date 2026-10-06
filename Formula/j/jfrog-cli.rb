class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.125.0.tar.gz"
  sha256 "6fb86a6bbad37b8ed0078810b494397ac3b7c5cf5ebabf949ee91671716c7c25"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09163148139c26cc541c61f711a43010f02a4a9e11d6892487315b5b01113ef1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09163148139c26cc541c61f711a43010f02a4a9e11d6892487315b5b01113ef1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09163148139c26cc541c61f711a43010f02a4a9e11d6892487315b5b01113ef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "702b6831e2162b2c2d14c1d5cbef0ef3c97f4c3911929e7a7f41964328ec3427"
    sha256 cellar: :any,                 x86_64_linux:      "e624dbcf41c38fe3e9476364e0eadeb19e7c1dd497a5951157e3bebb49cea166"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
