class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.19.4.tar.gz"
  sha256 "1c77fcdfd8899b691b41513379ec7573dec14595cf1833626b7f9c82decf2168"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3d335f213e51e69e65156e595832ad4c49bd63a6b851806abf47e27d285af0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3d335f213e51e69e65156e595832ad4c49bd63a6b851806abf47e27d285af0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3d335f213e51e69e65156e595832ad4c49bd63a6b851806abf47e27d285af0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4519dc7dfa59f25dcc55ba777189b7a183691f34adff6a30ab8560fcee4d2c49"
    sha256 cellar: :any,                 x86_64_linux:      "48cc24f406b5f45fd5e46493f7ebbca5e7a3b5510f31d69159410378c0b7f4f5"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end
