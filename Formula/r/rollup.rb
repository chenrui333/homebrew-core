class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.1.tgz"
  sha256 "9da5e56082b223ba46de1c1afea155274e7e0a057ccfa6a5434b23ba956bfd88"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "533a3ff46fdb6b4365357da8e46f2b7a1a5e41510c2b206c1032ee8e73ad59c1"
    sha256 cellar: :any,                 arm64_tahoe:       "533a3ff46fdb6b4365357da8e46f2b7a1a5e41510c2b206c1032ee8e73ad59c1"
    sha256 cellar: :any,                 arm64_sequoia:     "533a3ff46fdb6b4365357da8e46f2b7a1a5e41510c2b206c1032ee8e73ad59c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f51f0a1f2378b2bbf00c05a544c5070eca75eb96d156c164b1aad28b29aa0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9033fa648f84bd0549a5f1e1391769268cc3e591332db15b1633527cbe46f669"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
