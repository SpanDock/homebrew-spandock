# Generated from packaging/homebrew/spandock.formula.rb in SpanDock/spandock by
# the release workflow; edits in the tap are overwritten.
class Spandock < Formula
  desc "Local OpenTelemetry gateway and dashboards for AI coding tools"
  homepage "https://github.com/SpanDock/spandock-releases"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.10.0/SpanDock-macos-arm64.zip"
      sha256 "7f879a652d47d6067c281a8efafd5188d1d794c89eee1c7f8b7739e4a121bcf1"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.10.0/SpanDock-macos-amd64.zip"
      sha256 "1b80822e0f2ca3b9bba0a89be70907b5337e60d919e9616027dff257559259c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.10.0/spandock-linux-arm64.tar.gz"
      sha256 "cb386cc8dc334bfecad2c5401cca6700ae20448e140b9795dc58bd0611d0fa0e"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.10.0/spandock-linux-amd64.tar.gz"
      sha256 "d65c96d62b9db42418638fd9d422380ef7254105f35a9840cf248531094adaa6"
    end
  end

  def install
    if OS.mac?
      # The command-line binary is the app's executable. Homebrew quarantines
      # downloads, and macOS kills a quarantined ad-hoc-signed tool at launch.
      executable = Dir["**/Contents/MacOS/SpanDock"].fetch(0)
      quiet_system "/usr/bin/xattr", "-d", "com.apple.quarantine", executable
      bin.install executable => "spandock"
    else
      bin.install "spandock"
    end
  end

  # A Homebrew install updates with `brew upgrade spandock`; SpanDock sees
  # it runs from the Cellar and doesn't replace itself.
  service do
    run [opt_bin/"spandock", "-open=false", "-menubar=false"]
    keep_alive true
    log_path var/"log/spandock.log"
    error_log_path var/"log/spandock.log"
  end

  def caveats
    <<~EOS
      Choose this machine's mode once, then run it as a service:
        spandock -role=server -accept-eula -open=false -menubar=false   # Ctrl-C after it starts
        brew services start spandock

      For a client, use -role=client -accept-eula and paste the pairing code in its dashboard.
      Updates: brew upgrade spandock
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spandock -version")
  end
end
