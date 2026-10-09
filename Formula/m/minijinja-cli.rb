class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/3.0.0.tar.gz"
  sha256 "cc883891ce62391fa1dc86fe0e17ecda86f5cbda88d904db91497e316f445ac0"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b577354f9d9541b705057ea099fe6fc3745989517b59937b303fc898d1cd470d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61468c194eda369a29e775bdc2a817f9fbad9375ad0456b40acb608892076fb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de48a151b831b3c978710792955178575149dc64906ecf4c46dbe4ee53388587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ceeb4f08a666e5deba4f7dbf1b48c180ac568d141b2ce2c1b9f6bf5e633b59a5"
    sha256 cellar: :any_skip_relocation, sonoma:            "7c0ae1e251e099869c00cefc9072fb4b58b7c9275fec5e2ceb1d259c6a592b53"
    sha256 cellar: :any,                 arm64_linux:       "a2b476a3e3db9193c580aad08085c5bb421a2da7e03c7e9f14d3d53d851e2517"
    sha256 cellar: :any,                 x86_64_linux:      "0feb3c0e64b8262930c228608a1185c9c2bccfb1583e4b9e544522b4ded46daf"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin/"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath/"test.jinja").write <<~JINJA
      Hello {{ name }}
    JINJA

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end
