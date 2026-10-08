class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.45.1.tar.gz"
  sha256 "dbe0e0f7d32b1032bf129411db473d67bc68375ad87f4bbdb917899acd1005a9"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "361ded134a3dabe447c5f5a5d9e4063f18e2325270c147008a7248af21bb4760"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "361ded134a3dabe447c5f5a5d9e4063f18e2325270c147008a7248af21bb4760"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "361ded134a3dabe447c5f5a5d9e4063f18e2325270c147008a7248af21bb4760"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aaaaeebe48dbf64671ec8244a2bfeab4a8934632bb7bbed5040dc89e75e10cd9"
    sha256 cellar: :any,                 x86_64_linux:      "6723f488f230640dfcc631be79fccecee59e61ef6061f23b7bed220e1157e61c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "cli"
  end

  def install
    cd "cli" do
      ldflags = "-X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"cloudquery", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end
