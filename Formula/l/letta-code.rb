class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.34.7.tgz"
  sha256 "77ede76faf3b6099ed42945cd24c92ad72cec9dfc0414f654a8e8db59c209cc0"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "268a7b688b26fae0850f144e8214e9892bd5f90a49af61fa89a625c489b8e50e"
    sha256               arm64_tahoe:       "e6b5f6723c4f5d1a8052e687142f3695a6090517976da764fd2c346974513177"
    sha256               arm64_sequoia:     "e28b0f22aa54b6f8d5028ffe5a4e53766aa9e52f60061773d030de7a3303263b"
    sha256 cellar: :any, arm64_linux:       "f547a730900d794ad3cb9405264e583cdbda333c5650538a3a9c8bac33f6529e"
    sha256 cellar: :any, x86_64_linux:      "1129c41bfd57892f1b6e5ecbd01e48764a5318d1cd652d0ba7db61716f0cf669"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "ripgrep"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.1.0.tgz"
    sha256 "15663ca4944844139023390f057e86f1897d855959ea7e96f151d4873be8c71f"

    livecheck do
      url :url
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove ripgrep pre-built binaries
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    rm_r(node_modules.glob("@vscode/ripgrep-*"))
    rm_r(node_modules/"@vscode/ripgrep") # keeping separate from previous rm_r to fail if missing

    # Remove Electron-only sharp fork with x86_64-only pre-built binaries
    rm_r(node_modules/"@janhapke")

    # Replace node-pty pre-built binaries
    cd node_modules/"node-pty" do
      rm_r(["prebuilds", "third_party"])
      system "npm", "run", "install"
    end

    # Replace sharp pre-built binaries
    rm_r(node_modules.glob("@img/sharp-*"))
    resource("node-gyp").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"node-gyp")
      ENV.append_path "NODE_PATH", buildpath/"node-gyp/lib/node_modules"
    end
    cd node_modules/"sharp" do
      ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")

      # help letta.js find source-built sharp
      sharp = Pathname.pwd.glob("src/build/Release/sharp-*.node").first
      (node_modules/"@img"/sharp.basename(".node")).install_symlink sharp => "sharp.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Pinned agents: (none)", output
  end
end
