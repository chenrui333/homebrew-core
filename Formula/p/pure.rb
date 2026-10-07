class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/refs/tags/v1.28.4.tar.gz"
  sha256 "76cdc22defa2c1f5f4b257b8944be8ee5795ff34feaa0e8a2dc8ea8278c7d63b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec101dc81a2e4d597a592c434efa427835739771f39c1b83f67e66b9b39993bf"
  end

  depends_on "zsh" => :test
  depends_on "zsh-async"

  def install
    zsh_function.install "pure.zsh" => "prompt_pure_setup"
  end

  test do
    zsh_command = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p pure"
    assert_match "❯", shell_output("zsh -c '#{zsh_command}'")
  end
end
