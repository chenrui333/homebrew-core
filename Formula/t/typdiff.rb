class Typdiff < Formula
  desc "Diff tool that generates Typst documents highlighting differences between inputs"
  homepage "https://github.com/sou1118/typdiff"
  url "https://github.com/sou1118/typdiff/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "ed9b0415a318df8d824cc01e145e22b16b3ce5f4ffa7435947fd37e8273603da"
  license "Apache-2.0"
  head "https://github.com/sou1118/typdiff.git", branch: "main"

  depends_on "rust" => :build

  allow_network_access! :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"old.typ").write("Hello World!\n")
    (testpath/"new.typ").write("Hello Typst!\n")
    system bin/"typdiff", "old.typ", "new.typ", "-o", "diff.typ"
    expected = <<~TYPST
      #let diff-added(body) = {
        set text(fill: rgb("#0000ff"))
        underline(body)
      }
      #let diff-deleted(body) = {
        set text(fill: rgb("#cc0000"))
        strike(body)
      }

      Hello #diff-deleted[World]#diff-added[Typst]!

    TYPST
    assert_equal expected, (testpath/"diff.typ").read
  end
end
