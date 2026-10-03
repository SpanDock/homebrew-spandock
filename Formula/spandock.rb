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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.11.0/SpanDock-macos-arm64.zip"
      sha256 "682bee87f351e41de7f2f4b3065feb065e1964c2bcd153ac9b329901ad1518ed"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.11.0/SpanDock-macos-amd64.zip"
      sha256 "85b8242a471d4f78979672e4d8ff36027a1ba0490d7d3f89a5849ef533c53961"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.11.0/spandock-linux-arm64.tar.gz"
      sha256 "cbe11e66d124a2b9bfd3b11a66ccd62eb766cfd5dbd706c1f8640685cf219af5"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.11.0/spandock-linux-amd64.tar.gz"
      sha256 "06ec4661269844565fa8f6016ec2f1cb0fbcb64fa90e20159321d070aeb880b1"
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
