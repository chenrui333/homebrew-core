class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "c2593204609e56bf14af458c5d84306f6963ecad44b25f3b0db4a296bd6d43fb"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83cd82c4fb0d473becd6197943dec7a2fd3f739dabec53ae040fd2c524fced2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "87a642bd4ebfff1ffc84bcb4dab668b172b29f8d2e0d27654bc593606c4f3349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "650631c7172fc954f8131c87d459a0eaa01f37f53673a573434ba7d09525b202"
    sha256 cellar: :any,                 arm64_linux:       "a7a0a5b893b838fedfca746a0c49256319f845b95bc8539a740434f8be334963"
    sha256 cellar: :any,                 x86_64_linux:      "fce8a993c921724ab3ab0695067a447b279f908f7b4905eb88d9c127a3d92aac"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
