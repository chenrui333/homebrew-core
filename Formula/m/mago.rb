class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.52.0/source-code.tar.gz"
  sha256 "e7e647d2d4e778c3b0d0c4f1636e37235572421440e30c9e60644fb509798a9b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cbb812f3ceabb0453b7d0e05a5ac21d925e754736909615bf161154818082254"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5b1d6634a770fabffa8f02d5ac36b5e55cedf823981af4ae61bb847712c4a12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41227ab24dfc3635b811fbc6e36797c1776e6657a5a5ab5d65553fac5a685680"
    sha256 cellar: :any,                 arm64_linux:       "95d5d6910c7431d9de511c8b79bfb9ef9185905d60b98cba2d796e1939f4816b"
    sha256 cellar: :any,                 x86_64_linux:      "292804724500a58f0b12c8e97bef88393d0a94251345331cb1222707d33d6216"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
