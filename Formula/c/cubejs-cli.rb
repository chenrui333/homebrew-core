class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.2.tgz"
  sha256 "d34699282627acf2cdedc104a208854a065df64855e9772f52cb6b026bbf870c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "488cd10cc888b1451c806a952f66bf641bf915543bf52791828a96d270eac150"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "488cd10cc888b1451c806a952f66bf641bf915543bf52791828a96d270eac150"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "488cd10cc888b1451c806a952f66bf641bf915543bf52791828a96d270eac150"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a3e25353dfee6abf38d4b4a3bfccd6187be4a9effd3dcbd5a2bd1aec12926c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a3e25353dfee6abf38d4b4a3bfccd6187be4a9effd3dcbd5a2bd1aec12926c37"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    ENV["CI"] = "1" # Disable telemetry.
    token = "eyJhbGciOiJub25lIn0.eyJ1cmwiOiJodHRwczovL2V4YW1wbGUuY29tIn0."
    assert_match "Token successfully added!", shell_output("#{bin}/cubejs auth #{token}")
    config = JSON.parse((testpath/".cubecloud/config.json").read)
    assert_equal token, config.dig("auth", "https://example.com", "auth")
  end
end
