class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "0b76b4a7afbdcd0385b3a18c78218fa8afb9e99d68d2d16618c09593e0819855"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "75dc9b65e145b32fb119ccbf0412713a7902aeab0f880b84ac34fe22d8cae4f5"
    sha256 arm64_tahoe:       "9067d7acad1eea2b37ed10851c1d6ad47a918f527d5dc0024deaff92b147b423"
    sha256 arm64_sequoia:     "4473d14dcee17b63bfe67029d9ff6f3ea277427ea920b7dcaf5b2b20c85a326d"
    sha256 arm64_linux:       "d6ec26b7380ee2ea2f46addee29181fb138114fadfadaafdf0fa73bb1d30478b"
    sha256 x86_64_linux:      "97f57347ba839b00c67b6390ea827eddd0984e9e26340fe4c3c57ad323f09aab"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized #{project}", shell_output("#{bin}/helix init 2>&1")

    assert_path_exists testpath/"helix.toml"

    assert_match "Added test", shell_output("#{bin}/helix add local --name test 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local --name test 2>&1", 1)

    assert_match "helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end
