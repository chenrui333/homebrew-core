class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.3.1.1.tar.gz"
  sha256 "93bf863b757d7b7e29096b99cfb46fae8d354476b3c8ccb855e314ef792ba081"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eab950e03cf807d0a4b4c48c95b9415b849a44473d090f8d3c2ad02548d86855"
    sha256 cellar: :any, arm64_tahoe:       "88c7c470ac5f9bf2f2bfe134d3aab7ccd76b29ac2f73bb7dae4a917024a78867"
    sha256 cellar: :any, arm64_sequoia:     "3e0e835afc52eedc6ab19c1a9ff2281aae8504e0a14ff2ddc5ffc3cc5195f6d7"
    sha256 cellar: :any, arm64_linux:       "3c8becc66f6fb46b53421f5f9d5732c6bbea0d2f28f02270692c3d7dc8135566"
    sha256 cellar: :any, x86_64_linux:      "257b4b203ec6591017ea165d9e688907b03ff4163e4b50e7d8024417fdc1df48"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  def install
    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
