class Soapyremote < Formula
  desc "Use any Soapy SDR remotely"
  homepage "https://github.com/pothosware/SoapyRemote/wiki"
  url "https://github.com/pothosware/SoapyRemote/archive/refs/tags/soapy-remote-0.5.3.tar.gz"
  sha256 "de5bdf209dc93bf7c341077e1e21353037fc387e7c6a9ee41eace3390669dcc1"
  license "BSL-1.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1e81605f29ac8beb96c1792a94ff8b699f7877fd8e5cfe5915487e4308471b99"
    sha256 cellar: :any, arm64_tahoe:       "f8491c93d515099d719dfa0634ed2bda81dba4025f702537f0d0b2519bdcc83c"
    sha256 cellar: :any, arm64_sequoia:     "e8e3c3c4a8c806d410eb6fbd044f801d289fb192106aa5c3d7b7452afb79e184"
    sha256 cellar: :any, arm64_linux:       "2d37d79ce06179e400defacf5c71e0d4bf89674036cadec068e5907cd6e406dd"
    sha256 cellar: :any, x86_64_linux:      "8826b60bef79250f443be41b6c54c1e238373269bd81cd1a214df1c0e6fecc5d"
  end

  depends_on "cmake" => :build
  depends_on "soapysdr"

  deny_network_access!

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{formula_opt_bin("soapysdr")}/SoapySDRUtil --check=remote")
    assert_match "Checking driver 'remote'... PRESENT", output
  end
end
