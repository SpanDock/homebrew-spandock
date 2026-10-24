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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.63.2/SpanDock-macos-arm64.zip"
      sha256 "fb13a5454fedd9cc1baec0f2ba87fca6e841562de18d9e6b1a1929310abc93c8"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.63.2/SpanDock-macos-amd64.zip"
      sha256 "5094805523df7ad3c109f55da8c5186ceb6054e2bbd979b3fb4690d105ee4fd5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.63.2/spandock-linux-arm64.tar.gz"
      sha256 "37066c77762c8a56fed3fdd29407bbbdcd4c1e323acb9439d4020cec58045c0f"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.63.2/spandock-linux-amd64.tar.gz"
      sha256 "1eeaae2daa3f2b547f832e899d3e9af687ae6350f2fbda71c0ccb49c3a4597f1"
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
