class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.1.0.tgz"
  sha256 "39a404686c55fc2d862216e0cbb70f6bedc456adaeb5fe57b642036455f9ffc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "812ed56ff994d96c571d0fde3fe0a0e5a5776cda1d779d9569808e1687c55f34"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", shell_output("#{bin}/marked -s 'hello *world*'").strip
  end
end
