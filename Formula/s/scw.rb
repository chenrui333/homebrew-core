class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.65.0.tar.gz"
  sha256 "60b1da3b4040be8ace2baaaea8dae1f2fa2614424cca0963bc814a6b60471352"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57df515dbbee6ac178c64c2c448d6f03bd0190561e15a13847f9bcd53bd4b7ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dad8a2672f5764afe27aeaadcb0c0235539df51ffb6e9c3ccfb9afa46978ff64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f36281b71fabc39104a14042fbb08ff4c3a88b943e26b18e3c8c8dacbb16203"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27b16d1a334bbec5410eb4dfe0a3cf40d00631cbed7a5aa746cea7f5a4b7f987"
    sha256 cellar: :any,                 x86_64_linux:      "e89384ead1389ff538ab3ae3ee9b380bf6d5637f5ea8abac96b8352a0131328d"
  end

  depends_on "go" => :build

  # Avoid looking for the module root at CLI startup, upstream PR ref, https://github.com/scaleway/scaleway-cli/pull/6379
  patch do
    url "https://github.com/scaleway/scaleway-cli/commit/39dc3996fbd9ae8ceef04af41bda8261d11a12b5.patch?full_index=1"
    sha256 "bf3b72864cb2e93bd8fbb3fef100a6bad2241c91b46f6a2d6179e831bd55e9e9"
    type :backport
    resolves "https://github.com/scaleway/scaleway-cli/pull/6379"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
