class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.64.0.tar.gz"
  sha256 "ca8340d2a14c0cea31a0dc95d4515dcd0a340c439533701235fe0ef45aa058ea"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd60508b27656352fdf2221b27ce842791ad1e510af7b252c725f4bd1cbbb446"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6ec752f4464ab47d062f72e5384f4e38c62a9f76aa32c87e5ebaae57c2d060f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62c3553873218682086193e2b25fdb62381ec70bec35bbf5122eb72223b952b9"
    sha256 cellar: :any,                 arm64_linux:       "4f51311ca92d75b966697a8632f0193d55cb5851b63cc94d80582d34d450b720"
    sha256 cellar: :any,                 x86_64_linux:      "7b35fca1d7ae01f91bb9ffd105808dd142d881ba2184ca581d83e24ea04d5b87"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
