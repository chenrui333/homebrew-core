class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.6.tar.gz"
  sha256 "14c0282e748478375d0fc8d50c0b4bb98198861da6576490c0098e314778de39"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97753ba6d0158d9747de4e92fa15ad1e6b9e234f5d6626370f0f00f393ec6f34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97753ba6d0158d9747de4e92fa15ad1e6b9e234f5d6626370f0f00f393ec6f34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97753ba6d0158d9747de4e92fa15ad1e6b9e234f5d6626370f0f00f393ec6f34"
    sha256 cellar: :any_skip_relocation, sonoma:        "19a775dae7c603d420cca4f8beef73dba6c34a2f474c98794211f4a2aa8dc9dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8c7e849ea9aaa91f1284b95a37085bd471c88a575f4379f4abb11869f9603bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cb1cd3eb14f61abb41c7a8bbcdf02339f5ae0ef2d63ca5c35fc9b409bb197d0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end
