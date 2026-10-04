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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.4/SpanDock-macos-arm64.zip"
      sha256 "a8d1b6a6fab68a695f70d24d38e08c05645689faa2b1dfe6d9d34a5fcc1c6638"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.4/SpanDock-macos-amd64.zip"
      sha256 "d1ce14a09146d4673e245d1a24bdb6da9c8d713a33eaa62f64565b6cad26043c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.4/spandock-linux-arm64.tar.gz"
      sha256 "a4f045bb8463a06884caf6974f7cb63960e2bee93dfa1c80e1353e0cf27c2461"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.4/spandock-linux-amd64.tar.gz"
      sha256 "4bcc953d8202b23626143aaa2610a5497f49b63ebc19a3d793ab0739277dcdf1"
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
