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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.25.2/SpanDock-macos-arm64.zip"
      sha256 "62e10afc6645329cef857312a2725263b7a06b37a9c8ce2bb6cbe37dbd1825d9"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.25.2/SpanDock-macos-amd64.zip"
      sha256 "b4a00c92a727da408e28f661e976f4ce72dcb397938f6c4ff8912ec3f6bf026b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.25.2/spandock-linux-arm64.tar.gz"
      sha256 "1cb4819b303b9dd833df24ee6fc9d6d239be7baea3536d21299089c082ecc3ee"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.25.2/spandock-linux-amd64.tar.gz"
      sha256 "13efd67e845dd48168a1fd93ac6cd78e84f65d88c0e79f48537baaa2adaa96c3"
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
