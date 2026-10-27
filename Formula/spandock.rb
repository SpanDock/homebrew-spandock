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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.70.0/SpanDock-macos-arm64.zip"
      sha256 "75627deda6669b3b68dca7485c392df88b3dd6f50175c86ca4ed00ff1005ab36"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.70.0/SpanDock-macos-amd64.zip"
      sha256 "8b802011c0bbcc4b7dd1ae2c6eacf679f7653a38b2be9bf11f9440c5ce087ca1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.70.0/spandock-linux-arm64.tar.gz"
      sha256 "eca6e30a2b1b1edbeb85a5aad0d0c23d3ac63da3627935c5962f4384912c1f1c"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.70.0/spandock-linux-amd64.tar.gz"
      sha256 "68db65f4b0bb3a47fe41e36a1adf714e545c7b88d204e1ee94b2b12433e8c127"
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
