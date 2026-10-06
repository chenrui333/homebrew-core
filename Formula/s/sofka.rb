class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.29.10.tar.gz"
  sha256 "8ce45aaeec8a89708deb85f07ef9c7e43091248c6acd166845b1377e51ee4d68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78edc8501d27959d131fb5c6df27c3e217c23a0b353297ab95e798b9366841c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fcbf65fc6a1809b43b52f9de607410a3a2de13e647ac948242a63122d16d0e4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33820833b4155bc5566762432e13844c54951718a53aaffb75c4396197b2d15f"
    sha256 cellar: :any,                 arm64_linux:       "52d9204f7c19755915d69db2a01e3676ebeba820f752f2ac41b32984db4e91cb"
    sha256 cellar: :any,                 x86_64_linux:      "07e0e8ef6931835d47a541a862e8767bfd6386d8155b0fd36bb876bbce5b0393"
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
