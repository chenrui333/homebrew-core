class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.24.1/pup_1.24.1_source.tar.gz"
  sha256 "b9ff2e188a3eee431dad3a8033c46ad7513178b0396b49615fd311fe3b62ed0f"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c29006cfabe15da632e5c213491c2590433bd7a18d204f1170bd3338237ad1ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2be29c7c0c66152ea4dc7a883cd76e0468b0f6c323e4191b2530e6a979bcd54a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa3ef3830c9fe5aca30ed79ff99717d162ddb1b30b8ff87cacab52b4154a10f7"
    sha256 cellar: :any,                 arm64_linux:       "a3dcacb2fa18ff41c8ee15fc75b84724c767e7be364533a8359d002edd290e32"
    sha256 cellar: :any,                 x86_64_linux:      "bef42364375e003efe9e0760e0c725ea0f9b378b671264ba0e8ef34e3293df1c"
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
