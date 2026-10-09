class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-6.2.5.tgz"
  sha256 "1cf4d8f03a5600e171fad6147e603ddd5672f3763abacdc8f2412dea40ab435e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0516644877de59367f7c12861dfa4a555e7c5c5c222f1b0086290e48cb87630"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    test_config = testpath/".solhint.json"
    test_config.write <<~JSON
      {
        "rules": {
          "no-empty-blocks": "error"
        }
      }
    JSON

    (testpath/"test.sol").write <<~SOLIDITY
      pragma solidity ^0.4.0;
      contract Test {
        function test() {
        }
      }
    SOLIDITY
    assert_match "error  Code contains empty blocks  no-empty-blocks",
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1", 1)
  end
end
