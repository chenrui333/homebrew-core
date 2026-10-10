class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.518.tar.gz"
  sha256 "2cef4d13f3dc884ccd7474b4b66e66248bffb7ccd23e3f05d5ee27aa19b743ae"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1feb0a226c398f1a8d09d81fa15bc4304718d1610acc935453701b8cffaca6c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1feb0a226c398f1a8d09d81fa15bc4304718d1610acc935453701b8cffaca6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1feb0a226c398f1a8d09d81fa15bc4304718d1610acc935453701b8cffaca6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a443fbba5cf14cca99bc2529fe242a0268976abdf510b9b57bc23b95592f3cb"
    sha256 cellar: :any,                 x86_64_linux:      "fadd03b4d576df1f8aa91c4c9bfc000b2197736d65a44ef790208def7e5201f2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
