class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "ebe98f6ac9fe1efac298a879e9d122edde826b45ffde7d626975f1dd5b020585"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efcc43901849f010da09275e79938c88c1ee7a7357db591f5d2ae353c3f2e5b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda390a156abd90c560da841c26a419db9979b34d22d98fe1eb5909350563eee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02d98f882fbc9bc9fd4f317b51e79e99b83041ee6cea7ca5155c52cddba898fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "d21e7ac2bda851cc3c2ef28030c7366ec0a591837fafbdc6336d9db2a5c20ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97f105afbe672080c71a13d405d5afecbdbb97ce5c6072ee2d1a28e48a230f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0da9ea238c74f28e1b50d12c7ed3140c5ce635684de8a0264b3fa861735582f"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", "--features", "cli", *std_cargo_args

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
