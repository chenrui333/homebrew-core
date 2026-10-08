class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.99.2.tar.gz"
  sha256 "acce1a028575040a7ff95456111fd5ea4c7c4282ac55705de10b7fa52c7a37b3"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be32b9251e14546a4f17719dec8a34858f52e7ee4d4f599e6b245e14cb6b7ede"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "356922c13be2ba7a5023d095d3c82e36c5f0341f92829d5dcb65f9729dfbb787"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90bf825be0bd8c59995ecdd7d60c74d34d9e964920736081c814ac94534148c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f0a430e3b3a6fe68b1448c7ef06840404b6bc4e534f70eecb7c5044f7434652c"
    sha256 cellar: :any,                 x86_64_linux:      "7f4c83d58a71beeefa27261fc93eb066827c93238ed8b758887a427f4b7f4917"
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
