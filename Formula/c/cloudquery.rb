class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.46.1.tar.gz"
  sha256 "ff52757eed10f192d655759529de23f11875d27b46cc9658468c685213a7274f"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0f17f450aab141f5994125a7725a44066060a5e70465e3a1e4590fdaa3549cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0f17f450aab141f5994125a7725a44066060a5e70465e3a1e4590fdaa3549cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0f17f450aab141f5994125a7725a44066060a5e70465e3a1e4590fdaa3549cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2c34181dd6c42f9ead8fe6199610b552a42c3e1fb70623bfa9ae95d68f7ee80"
    sha256 cellar: :any,                 x86_64_linux:      "24ec735066aea6df378ee187dac1b53da773084b770bbf97ed5ca18b676e24f4"
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
