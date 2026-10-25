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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.64.3/SpanDock-macos-arm64.zip"
      sha256 "529f98f5ec15ad62ec27a578ec5fab71359ea35a7626ef26131d42e507f04b8f"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.64.3/SpanDock-macos-amd64.zip"
      sha256 "e897d5c5252306b1e72de47eb4ab20b89f32ce2418c034cb3ad8587f8c86f563"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.64.3/spandock-linux-arm64.tar.gz"
      sha256 "604b5fa6de58d1610c1ea873f53339ac9aa785bdc14622e65b9e5891f09fa39c"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.64.3/spandock-linux-amd64.tar.gz"
      sha256 "e4a494b9eef826ae455fd213dbf3d279e4d7d64604e6273f42eaafa315804460"
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
