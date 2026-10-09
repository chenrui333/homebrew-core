class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "1e21e9b6316e49ad23f78e4816427df572e1e98ab6bd1bac39c32dac5c324768"
  license "Apache-2.0"
  compatibility_version 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "54c16161490d10f727a916d9e6354eba7a543d86bc13baabfb185907273b712a"
    sha256 cellar: :any, arm64_tahoe:       "140552324fd007216b66255a7a0fbe0125bc56ccb670fd2605a2fb60da589d9a"
    sha256 cellar: :any, arm64_sequoia:     "fb65f8877af12b9b7d023040e7ee2b8c7a689c5b1d32095b8a60452b499618f4"
    sha256 cellar: :any, arm64_linux:       "9608a8a918d61fdeebc035a539585d05640bfb08a592ca4f1a7816c22421d7ab"
    sha256 cellar: :any, x86_64_linux:      "a0ce76b4745a5ced0c8aaa00b421520994075b90d17c1ec6384bb57d5844f476"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"

  deny_network_access!

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-cal` and `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/allocator.h>
      #include <aws/mqtt/mqtt.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_mqtt_library_init(allocator);
        aws_mqtt_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-mqtt",
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
