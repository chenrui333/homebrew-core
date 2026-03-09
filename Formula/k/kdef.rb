class Kdef < Formula
  desc "Declarative resource management for Kafka"
  homepage "https://github.com/peter-evans/kdef"
  url "https://github.com/peter-evans/kdef/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "0a54ecb3b8bb4ed88a678c3e6ed48439c79bff81c6b70cb0285c701ca8511206"
  license "MIT"
  head "https://github.com/peter-evans/kdef.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdef --version")

    input = testpath/"configure_input.rb"
    input.write <<~RUBY
      STDOUT.sync = true
      ["", "", "", "#{testpath}/config.yml"].each do |line|
        puts line
        sleep 0.1
      end
    RUBY

    output = shell_output("ruby #{input} | #{bin}/kdef configure 2>&1")
    assert_match "Created configuration file", output
    assert_path_exists testpath/"config.yml"
    assert_match "localhost:9092", (testpath/"config.yml").read
  end
end
