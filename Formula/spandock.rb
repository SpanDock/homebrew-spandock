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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.1/SpanDock-macos-arm64.zip"
      sha256 "b9152b614660d5417febb692ae44a07b7f23af0ab3c6482e2ea86f6b7de892d8"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.1/SpanDock-macos-amd64.zip"
      sha256 "062813c0d22d1b9d85ea2a7b753ed1fb2a52f4c65210f8d99e4e3540dd2cb281"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.1/spandock-linux-arm64.tar.gz"
      sha256 "30e049403449d625c5359d7daea34ed7dde2249853607a9897b91e076e1293c9"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.1/spandock-linux-amd64.tar.gz"
      sha256 "5bc052f283aebfd575bdec26731602edcec6a3faa225344e3ca6eeaadda9e2ae"
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
