class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.10.7.tar.gz"
  sha256 "a6bf17d3d023461ef8892c57b8942cdf92dcc204817e9e39c6af01bb1c8ada49"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e1140625556755f6fafe7af7d9286ca278ca7e09f46ccbbf8cdf9b586502e18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "209ce7cd25301244c3a0ccf153d4dfd1a2b6857093b32588e088e508b400e260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53fb68676f152473e952b2f8667fc8ba18d44517c39d36dfcf1a78a3eaf1d4e6"
    sha256 cellar: :any,                 arm64_linux:       "d06ac576e9acad774f3928c659e5efbff5be0c6ec771b4ca6767f570d4f4eb5d"
    sha256 cellar: :any,                 x86_64_linux:      "163a76741d31d32bed90d6a54d6ac3a286c284b8ba03c9dd46622d3e70cc4257"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
