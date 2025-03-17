class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.265.3.tar.gz"
  sha256 "ea856467e06ebb3c9bef010a99907ef9c48ee262234f8ac92afa2ecf87c26c35"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6750be54d42b479c37e307adbc9caa677114346cc49c49210cba2ad1f8488ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "121a4f23948a9f06473d90cdbd62e638ffb309d4c321debcf927d87d7304cb58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4ced6f5b772db66ccee8df63d389799937f503643d6c9ad10153322a71ddeee"
    sha256 cellar: :any_skip_relocation, sonoma:        "65fe3e604aff00f397c882b07e4d706b2d94d5788221200ce0eee0f64937ab24"
    sha256 cellar: :any_skip_relocation, ventura:       "49e1974cfc446ad4895440965ccc02d64e99242e14c2ef79bb675d075aee3db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7274e1496e5a7d36f6954be57a16819b58f10bc2cd5ea369fa9d21b745dc66e"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
