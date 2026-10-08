class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.89.1.tar.gz"
  sha256 "c55e2b69dd6e12520faff0c39f914162983178ff67b07a59922289bd6675e78a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f81e5fb545c273c9f8f24800c2bc9c2cb64170881807509d56a258fd7f40e724"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07f4f2ddac32268388adda614d3fd6892727e602e85a5c629932d3cddcc1fbbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c4ccbca10dfbe1e39696c9b1050cbd9578b335d9413e3a65688b065c7b169ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cea8cfeea354fc4f66a23b5ab7be8f8916f4c0a96146ea2c09591d26c787e26f"
    sha256 cellar: :any,                 x86_64_linux:      "0b7f376cd79c19c6a1b7ab360d8d78559966da197e701d3ca58f71e9485e155a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      groups:
      - name: example
        rules:
        - alert: HighRequestLatency
          expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
          for: 10m
          labels:
            severity: page
          annotations:
            summary: High request latency
    YAML

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=7", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
