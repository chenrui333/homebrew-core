class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.0.4.tgz"
  sha256 "04910bdae661a6529e9d6869b04006f6aad01186398b04a16c6d9793667b96c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6caebf92e221c582a01400298808da3c9740fb79332249668c9704568ac4c013"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6caebf92e221c582a01400298808da3c9740fb79332249668c9704568ac4c013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6caebf92e221c582a01400298808da3c9740fb79332249668c9704568ac4c013"
    sha256 cellar: :any,                 arm64_linux:       "f857724121f414b06c9882b0333fdeae5d5fc1e82d197fac0715d29bf1fc4c29"
    sha256 cellar: :any,                 x86_64_linux:      "e4e2cfe54f149e0f01023959693b5fa63bb291b33237854c47114ab78c2f991a"
  end

  depends_on "node"

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "npm", "install", *std_npm_args
    (bin/"pi").write_env_script libexec/"bin/pi", PI_SKIP_VERSION_CHECK: "1"

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end

    # Rebuild the X11 clipboard helper against our `libxcb`
    system "bash", node_modules/"@earendil-works/pi-tui/native/linux/build.sh" if OS.linux?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
