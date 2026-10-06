class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.99.0.tar.gz"
  sha256 "e93ec9c97417bae984e5c751480904ddd928ed78fe5f1b18e74a11fc265ae474"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e306f911539ce178008e21152c99384c697fc8e0e01f58f8d1f2f48e1ab41eec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d617195a584ec3c93a2317222710cd519ab33f07763d8d5c06413b1ea4346294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f74f19157a91103fc8836f01a8fbf9df1e1808ed7dca003e6317dede7356801c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "67ee511f7cbb2f9efa8ce25750989f1453837e29c72b296c3cd8a301021482c6"
    sha256 cellar: :any,                 x86_64_linux:      "debb6ec30da8394ffd65535f9ddbb66c39654446138d15f0822234234f531da1"
  end

  depends_on "go" => :build

  # `test do` block scans a GitHub repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
