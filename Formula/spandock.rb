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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.73.4/SpanDock-macos-arm64.zip"
      sha256 "b3b613b481c9b74b4bd7a149dfc862e82a9f4055dbee37f86609daf6c9f8f272"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.73.4/SpanDock-macos-amd64.zip"
      sha256 "c8e4fa48f4a5e0a9c856d8e4f8705bbd74663dbdfbcc1514ab2c7db78b34639b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.73.4/spandock-linux-arm64.tar.gz"
      sha256 "055ba300c3f38de96190173bcc12a9588bc22b84a162615142ed05d44782dad9"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.73.4/spandock-linux-amd64.tar.gz"
      sha256 "6356203ac23d5f017327817aa8cb91754c97889269715b8366e91e8a21426f59"
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

      Every server needs a spandock.com account (a Personal license is free). A
      new server prints a link and a code and waits: approve it on
      spandock.com, from any device, and it starts. Air-gapped Enterprise:
      add -license-file FILE. An upgraded server that isn't activated yet:
      spandock license login

      For a client, use -role=client -accept-eula and paste the pairing code in its dashboard.
      Updates: brew upgrade spandock
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spandock -version")
  end
end
