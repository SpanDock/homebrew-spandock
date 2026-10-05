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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.21.2/SpanDock-macos-arm64.zip"
      sha256 "513a5db0640da73c6a94193b8d33ce196180ff512fec33f37fef33faf7d43e7f"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.21.2/SpanDock-macos-amd64.zip"
      sha256 "f7cc41c8687c9cf81d0bbbd1afe262ac4ae951039b6093ab724cf39fb87a0327"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.21.2/spandock-linux-arm64.tar.gz"
      sha256 "5168c3173dd323225536194befa19193c0113baf9a38d3e5a18cf5c3db92ef80"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.21.2/spandock-linux-amd64.tar.gz"
      sha256 "1fad2e44b38cdacf3eda22ae6a6a6d30070b9ac38fdd09de3f49f16e978c3732"
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
