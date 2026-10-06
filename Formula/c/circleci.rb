class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.1.0",
      revision: "5e3283b5ec03b0502a7ef2c49eb4e606d3060e38"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e28bbbb3cdfb0f55d76a6c1c825740bf177c4248afa620b13408420da59a252f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cfd57323c87a29e5adef884406a0249c759bfa5b94fd282fafccc65d5451bcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9514e9301d049264f0b1649c03c07abdabe5b78566da3b70b5cb4bf7d07bd4c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d9a465091f34d469feab74bce7a8210e9f16c6f01e72d655b042937eeabeb69"
    sha256 cellar: :any,                 x86_64_linux:      "dd2f5435e94b316f73e3bd650fc98a3205eb511bada838e4756797bd72730446"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end
