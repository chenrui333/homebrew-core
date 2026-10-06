class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "540a6b1a583f83d9c0108a4383443269c21a77d4b5af7c002e81617a57d26f6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "329d274074ff3c02df4ec59a79f6b1d6a81c6690fd86d3d36a6c3e4ba35a9ada"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ad0a76c6c697754269e70aac54e5d27d59069d40fb0784b021f6bc92c1d27c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30c62a869985ba2ffd148b5c8bded21f66aa75b36ff12641362e15217e926854"
    sha256 cellar: :any,                 arm64_linux:       "ac9de61e45ae079e3c58a3b3f80c5b7e7dacf9b014844031394fe57807f78a84"
    sha256 cellar: :any,                 x86_64_linux:      "25cad73f7f978827f515ecfb7af5fdba580602e5f1bd23cee317f335b0e0c179"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"sofka", "completion")
  end

  test do
    assert_equal "sofka #{version}\n", shell_output("#{bin}/sofka --version")
    assert_match "failed to read kubeconfig", shell_output("#{bin}/sofka --check 2>&1", 1)
  end
end
