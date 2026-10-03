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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.9.0/SpanDock-macos-arm64.zip"
      sha256 "dd2433438b899c2dff696e0241beb375c7a488bc63546a988a9e88bef7c316d8"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.9.0/SpanDock-macos-amd64.zip"
      sha256 "143755ffca55eb3525be65e93c2801511a1f6de9b0246c3c375091b4c132c2b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.9.0/spandock-linux-arm64.tar.gz"
      sha256 "9b21cae23287f98a043e61a81aed9199ac6dc4376da4fda43e78930f490e36d0"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.9.0/spandock-linux-amd64.tar.gz"
      sha256 "3a80a76ac73df85a99fca9dd04b07c4e168be8028b8cad88b69a3e1eac3102a1"
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
