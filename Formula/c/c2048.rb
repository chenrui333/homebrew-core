class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "83b9008dc77d7ab2ad721d7316551fb015dce97c40337a354040fe45d8296fd4"
  license "MIT"
  head "https://github.com/mevdschee/2048.c.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e15db46cb7c6a79cdd0ddcfe195c608b28b7ef7f6b9d46dd9430ed9c9510544d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3685248f1cfb5312c90b66e180ddcffddd8965acd8b5aafcc8dd29f868897a72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1df902e0acf5acbd7148a8c56d09ef2784f2a216f0abe876ff1cf9fe2bb5e098"
    sha256 cellar: :any,                 arm64_linux:       "f53666028a378dcb930f2057f358dc909f205aa7c83b6f2a85805aa7abd72cd9"
    sha256 cellar: :any,                 x86_64_linux:      "3b342c9775cf791768ea469f3a959eaeb070778ffbc9e6b5096231da18a177e7"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/2048 test")
    assert_match "All 13 tests executed successfully", output
  end
end
