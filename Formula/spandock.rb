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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.18.0/SpanDock-macos-arm64.zip"
      sha256 "ed4478e0116b9f0615626f7ff483f8fbc719f6f05206c13f2f8b48d5abfac5f9"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.18.0/SpanDock-macos-amd64.zip"
      sha256 "5a566101bb39623b7e7293bfc573816abb1db21c69b709816934d1818e49d30a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.18.0/spandock-linux-arm64.tar.gz"
      sha256 "957293ac3d51eb7186edcd694828ccab65f2f6b2507f2b79a4f42fe350f2cd40"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.18.0/spandock-linux-amd64.tar.gz"
      sha256 "7367a224574d7fbce8731e1a026cab5af1dac99bd7dfa130569bbc80f67e7e45"
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
