class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.26.0/pup_1.26.0_source.tar.gz"
  sha256 "58b35930b07faf6cc93b13b852883a37ef9f5f507b01b591649cd20fb4e0ca1b"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d418d5a0d0c358cf1013af1082d5616c2e53ce58122372e265cb8d1fd7d8e96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3182c4cf352b7e0f57024a3cb512d017ca77fe4abf7de381ffd596ba589c0739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c4b3c2b72ec67be9af3e30b647964d7f9d676763e543970ff777ddbed2b37271"
    sha256 cellar: :any,                 arm64_linux:       "ad1292a49c361cc3b1fd54b333e22b2da60ee46673bb977c27da8caaa6e63338"
    sha256 cellar: :any,                 x86_64_linux:      "3b89159183736f222a5170435ca310bbbcd39c8bbc0ea5bd50cdada6f5ac6a49"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
