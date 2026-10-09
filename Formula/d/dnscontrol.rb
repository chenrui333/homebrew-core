class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "9fe049d0846a0bc56efc9b9ffcbfd271f0bcbda1af736762267d8103313d5fc3"
  license "MIT"
  version_scheme 1
  head "https://github.com/DNSControl/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f96834557fbe98b0dc7fa135f402e014bd3602c78ff1aedaf428b862bfc72fd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48c5ed468058c1f1fd35b33cb0003ab5ec6f7c81752937c1e99af8ffccb69f2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c172192491599c08621932fa0ce2a238d33faeba1fc4c141ba1e052a3ec5be5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "532847e805b8f4ab2da9e0fb065a89078f539bd9096776fc8871f58782d1deaf"
    sha256 cellar: :any,                 x86_64_linux:      "7b016c0591fe3fcf171432eeadd39b4fd1aef177bf747b5495a511897651847c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/DNSControl/dnscontrol/v#{version.major}/pkg/version.version=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output

    (testpath/"dnsconfig.js").write <<~JS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    JS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
