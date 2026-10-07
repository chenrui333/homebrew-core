class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "12f8ff23fb86dfc5b83515f6d1ca99a10cb6d4b4d1bb9aa6e5e0190781619bd3"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa97d1b5fc5429e7dcdd7a8efe71b18fa0f774702c6d06b684afd3fa67bd7726"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa97d1b5fc5429e7dcdd7a8efe71b18fa0f774702c6d06b684afd3fa67bd7726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa97d1b5fc5429e7dcdd7a8efe71b18fa0f774702c6d06b684afd3fa67bd7726"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "119e6051e56d343088836ab0439298447c4aa78c8df19388703cc35320f1a157"
    sha256 cellar: :any,                 x86_64_linux:      "3b91067c0e3792807b6c1525f5257e01ee973fb7cd6ac335567176295b338699"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  # Test downloads the envman and stepman tools and the step library
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bitrise --version")

    (testpath/"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
