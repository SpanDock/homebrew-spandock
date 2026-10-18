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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.51.0/SpanDock-macos-arm64.zip"
      sha256 "9999bc7dfac79331f769a7a5d8c66f73bf6007a207cfd8eb34f51f32618523c9"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.51.0/SpanDock-macos-amd64.zip"
      sha256 "c38d07d9b31faa8dcaf60f3fd80c944ec456aab62e6a93cf87d91c2f145422c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.51.0/spandock-linux-arm64.tar.gz"
      sha256 "3cc23164d2bb65f62942abd5cceed7eea4ce4432635ced432f0ab52107046b10"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.51.0/spandock-linux-amd64.tar.gz"
      sha256 "b032a150a471cee398a4b59bf587da4a1efa46d94ff2dc89686d9827e550247b"
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
