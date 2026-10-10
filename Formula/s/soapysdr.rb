class Soapysdr < Formula
  desc "Vendor and platform neutral SDR support library"
  homepage "https://github.com/pothosware/SoapySDR/wiki"
  url "https://github.com/pothosware/SoapySDR/archive/refs/tags/soapy-sdr-0.9.0.tar.gz"
  sha256 "64f97c1ad241156fe299acb8902169019eab34517cd580b563968a43d7533509"
  license "BSL-1.0"
  compatibility_version 1
  head "https://github.com/pothosware/SoapySDR.git", branch: "master"

  bottle do
    rebuild 5
    sha256                               arm64_golden_gate: "f6c7550e5c1454908c669a1d1858c6a43efaea2cea6398b962a2a18af79bb5c9"
    sha256                               arm64_tahoe:       "d10703185cc1b8b3312bdbc0621131238980f07481bab599dcc498a06e1c1106"
    sha256                               arm64_sequoia:     "a57f1047d84abdf6272e01276e21ca325a0ca8b5aa716fba5fd91f9b4bedcf44"
    sha256                               arm64_sonoma:      "635b13fc20043aaee3de8be3c111caef4eb8213643ea04257b6ca7834ccddd49"
    sha256 cellar: :any,                 sonoma:            "c2b21d678a8d0d0f785d8257a32c7d48a7992adef5b6a7c14e6cd4e34d79cf3b"
    sha256                               arm64_linux:       "b92128272614278c0799f954abebd5cb9404ded017babda7f8a5767ffb60e8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c37220d056fd15397e731350bf2078625e70b50baf9033db994aa2a18e5f9f62"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.14"

  deny_network_access!

  def install
    args = %W[
      -DPython3_EXECUTABLE=#{python3}
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
    ]
    args << "-DSOAPY_SDR_EXTVER=release" if build.stable?

    site_packages = prefix/Language::Python.site_packages(python3)
    args << "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages)}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Loading modules... done", shell_output("#{bin}/SoapySDRUtil --check=null")
    system python3, "-c", "import SoapySDR"
  end
end
