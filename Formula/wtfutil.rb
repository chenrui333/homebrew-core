class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.18.0",
    :revision => "ab94bd34acb01c10e19e0c0128075e5c0d91a019"

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    ENV["GOPROXY"] = "https://gocenter.io"

    dir = buildpath/"src/github.com/wtfutil/wtf"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"wtfutil"
      prefix.install_metafiles
    end
  end

  test do
    testconfig = testpath/"config.yml"
    testconfig.write <<~EOS
      wtf:
      colors:
        background: "red"
        border:
          focusable: "darkslateblue"
          focused: "orange"
          normal: "gray"
        checked: "gray"
        highlight:
          fore: "black"
          back: "green"
        text: "white"
        title: "white"
      grid:
        # How _wide_ the columns are, in terminal characters. In this case we have
        # six columns, each of which are 35 characters wide
        columns: [35, 35, 35, 35, 35, 35]

        # How _high_ the rows are, in terminal lines. In this case we have five rows
        # that support ten line of text, one of three lines, and one of four
        rows: [10, 10, 10, 10, 10, 3, 4]
      navigation:
        shortcuts: true
      openFileUtil: "open"
      sigils:
        checkbox:
          checked: "x"
          unchecked: " "
        paging:
          normal: "*"
          selected: "_"
      term: "xterm-256color"
    EOS

    system "#{bin}/wtfutil", "--config=#{testconfig}"
  end
end
