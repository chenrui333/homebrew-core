class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.3.tar.gz"
  sha256 "009279c9ed367ce7d933dfa4dcfcfb42bc37d5020a691b77f4a2f68597e403b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5617e3700bf486565e15136dbb31a820f27a9f2658b0a61f8aa0789b10125fc0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ebe0a3e0b061a276384e4c29bbce73f2aab5ee0fb248c0d299af67eaba87380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98e221cd19f4a9e7dbf72ef3f10d38b308513f2792dc733af1840a3818702821"
    sha256 cellar: :any,                 arm64_linux:       "d64d309e3a3ba0eefab1b4db91c47ca061e42e43c5d25d68ef50df3151f075de"
    sha256 cellar: :any,                 x86_64_linux:      "0b415412d5b1e2f7ea0ab8e6300d518581f5496d8a0a2bd25ad54ed355bb9a2b"
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
