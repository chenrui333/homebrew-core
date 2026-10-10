class Soapyhackrf < Formula
  desc "SoapySDR HackRF module"
  homepage "https://github.com/pothosware/SoapyHackRF/wiki"
  url "https://github.com/pothosware/SoapyHackRF/archive/refs/tags/soapy-hackrf-0.3.5.tar.gz"
  sha256 "0ef13ac8cf1ec0c0728bdfe8a775e38fd06574418948e3a30ea6794de5d5a06c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "28f7e61840ac2710bcc31a1f31df38c61eec9f92e715b0f489fc64daed6dd1cd"
    sha256 cellar: :any, arm64_tahoe:       "0fabe82eb80d27a728a541cdd1608fb4a7f74dffab13386c532bfa9128376552"
    sha256 cellar: :any, arm64_sequoia:     "a8e66cb597300c5f0ce0cc51d4692a449acd819a1ea6d1259dd7c8ff69280f5c"
    sha256 cellar: :any, arm64_linux:       "7433cd304fe9480be0178456d8344d5f0d685bdaa84c020a61236cc68a554e5e"
    sha256 cellar: :any, x86_64_linux:      "0ffed3d9c9f52df2556ac68044f580553a5021610fb5dd0b3d313773195a33ad"
  end

  depends_on "cmake" => :build
  depends_on "hackrf"
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
    output = shell_output("#{formula_opt_bin("soapysdr")}/SoapySDRUtil --check=hackrf")
    assert_match "Checking driver 'hackrf'... PRESENT", output
  end
end
