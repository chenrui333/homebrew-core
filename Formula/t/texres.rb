class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://github.com/leoliu0/texres/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "6b09fb150fe16231135853b8c0bbedef406b9b654dbdfdc62dd108eb96efd87a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e2a18f7ecdd398f579aa85a06e6e634571c3ad04950cdf3c21e638cd67dbc2d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e444164eb7ab5af143bc9f162b160ac5843461d9f0e895bdc23fb160935335fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3dd7bcd9f0fea0536da4ee1fa87313ce3f8a25aff0e3f8941782e13f3edfd51c"
    sha256 cellar: :any,                 arm64_linux:       "17b367a67b1b115be98503260b970163b3d3c3fd50fa1d189c90f471945ce345"
    sha256 cellar: :any,                 x86_64_linux:      "ddf8ef9465402876d5f82f18fb3195a1d44b6daa7611c483ed5c07fcb48d58f3"
  end

  depends_on "rust" => :build

  conflicts_with "texlive", because: "both install `lualatex`, `pdflatex`, `xelatex` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "texres", *std_cargo_args(path: "crates/tex-cli")
    %w[latexdiff lualatex pdflatex ratex tex-bibtex texmk xelatex].each { |cmd| bin.install_symlink "texres" => cmd }
  end

  test do
    (testpath/"sample.tex").write <<~'LATEX'
      \documentclass{article}

      \title{Test}
      \author{Homebrew}
      \date{\today}

      \begin{document}
        \maketitle

        \section{Example!}

        This is simple \LaTeX file.

      \end{document}
    LATEX

    system bin/"texres", testpath/"sample.tex"

    assert_path_exists testpath/"sample.pdf"
  end
end
