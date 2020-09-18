class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v2.3.0.tar.gz"
  sha256 "6933f9cb826449a456198581eeeff37ec257a33098748b514937106ff74f885d"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cffac1e821ee18c292c20260f2d1d51993e862c079adef2ba686a0d1a7953d3" => :catalina
    sha256 "7c684bf9dac84965a2c3f94b6ad231c1f9e9e3ac36bf804676d310a12321bfbd" => :mojave
    sha256 "fa7eb54d598d8a955230bf996b8454c98872042840c0977a995117bdad608a83" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
