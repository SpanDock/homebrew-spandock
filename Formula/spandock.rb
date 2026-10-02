# Generated from packaging/homebrew/spandock.formula.rb in h4ux/spandock by
# the release workflow; edits in the tap are overwritten.
class Spandock < Formula
  desc "Local OpenTelemetry gateway and dashboards for AI coding tools"
  homepage "https://github.com/h4ux/spandock-releases"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.7.0/SpanDock-macos-arm64.zip"
      sha256 "e74b181ab4d50e71a500e6d4563ccc8c26fddd6403117940d30164457657c2b9"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.7.0/SpanDock-macos-amd64.zip"
      sha256 "cd980700d8cdbe51a5469b9491d73d9787afb9b6236edf9f13e90b7f7be3a214"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.7.0/spandock-linux-arm64.tar.gz"
      sha256 "65a906035d16f45b9f607259cfb1ab70298fdc0a6fcb83ae46b32bd31fc5c3fd"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.7.0/spandock-linux-amd64.tar.gz"
      sha256 "00845504cd62e3e8c2adc89fa6c454d51db57d5493889b64c099e0cddce36351"
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
        spandock -role=server -open=false -menubar=false   # Ctrl-C after it starts
        brew services start spandock

      For a client, use -role=client and paste the pairing code in its dashboard.
      Updates: brew upgrade spandock
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spandock -version")
  end
end
