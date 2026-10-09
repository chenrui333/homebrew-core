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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0c3b76d40b746debcd40c17c37dc019671161fa24daf2c038e5e4162a288283"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0c3b76d40b746debcd40c17c37dc019671161fa24daf2c038e5e4162a288283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0c3b76d40b746debcd40c17c37dc019671161fa24daf2c038e5e4162a288283"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f330f72de7de66ca26eee9f49f6c11960503b07e11720f851791c342819fed6"
    sha256 cellar: :any,                 x86_64_linux:      "718d2b245c819d1084c2b69ccbd54a224fb2d94496b9c83f3ebf7c3e57b22e2d"
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
