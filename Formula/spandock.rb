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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.13.0/SpanDock-macos-arm64.zip"
      sha256 "3ca476a0472ae7a14ba3e61cd1b2f8e497f73a8a9c335b82a8038154691cb94d"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.13.0/SpanDock-macos-amd64.zip"
      sha256 "b148a3ecfa5f5e0292d38720222b75ac7248497982c225275f003afe2a2050cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.13.0/spandock-linux-arm64.tar.gz"
      sha256 "2f06e7362162bfc570f7e672a5bed68b87ab3af325a38f71b7ae2975efa78333"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.13.0/spandock-linux-amd64.tar.gz"
      sha256 "293a6e3c96c56497d2342a4f1c26e2e0ad57b9aa4b544e6dab771c0d1080fdc4"
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
