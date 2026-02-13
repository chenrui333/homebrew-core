class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "8fc785dd0814735f73ab4999ca023b5ee81a63ad2a988b142b5599826d1c6b94"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a68d4e04e1c663198a73cb5ad61d3e196d55d2e44d5c76d16c6b66e2a5bb364c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfe18badf3f2eca4932cdc7507b3f2b3cd405c7e7962821d6f6cd91570d5e363"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17d02a030a30bf3e2594acf27df7b72065c5125007502f5bf429d87a27a70875"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af0c41e9bc5c4382e575d86782bb0617f1b076407b406c1c241aa0905d299b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec5b97f9a687fbcf73a88fa8524349bf5c4b2ca18a62eb3c2bd32416b6ff3954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d48c136c4e4780f436040f328df7331883aa241c071e60a56abe22cf6ee4f35"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
