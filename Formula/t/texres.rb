class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://github.com/leoliu0/texres/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "87ce746932371e1cfd233214d37e9d94fb489ebbb774372c1427162aa12cd91c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb87ca0c84453ed601d02d6eb336b5d630a2ce872763cf9199ee07c9bb439f83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "995a83d77ac8e236e96c9473d16edc1a3bb32a3c43430d363450a9b140202e0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05b6ec100edc08d04cd1622caff3f61d0e79e531210bb6d3cffc1a0f549db232"
    sha256 cellar: :any,                 arm64_linux:       "6592f7b4892afbb0e6fa564c5fda0da6ed52e60ae98b18e5ca39bb67a1a9795d"
    sha256 cellar: :any,                 x86_64_linux:      "e80776e92f34d1f4f76aa0c781bfa7883b9503c0034a344f554aa019bef6cedf"
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
