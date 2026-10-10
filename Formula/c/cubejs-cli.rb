class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.2.tgz"
  sha256 "d34699282627acf2cdedc104a208854a065df64855e9772f52cb6b026bbf870c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf0b8ea2838ef36b8bbb31245fb988690283e389d346eebe914613f64ee094f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf0b8ea2838ef36b8bbb31245fb988690283e389d346eebe914613f64ee094f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf0b8ea2838ef36b8bbb31245fb988690283e389d346eebe914613f64ee094f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dabcd2a0457624bb97d9bb3ac815f38cdc3d1e162f3d9fbc4b08bc9bce524700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dabcd2a0457624bb97d9bb3ac815f38cdc3d1e162f3d9fbc4b08bc9bce524700"
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
