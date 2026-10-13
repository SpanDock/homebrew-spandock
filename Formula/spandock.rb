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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.45.2/SpanDock-macos-arm64.zip"
      sha256 "ccd523108484615467ad9a07ee807dd2bfbcf3097dcefad99c98db1468ea6325"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.45.2/SpanDock-macos-amd64.zip"
      sha256 "6cfc9c73c380bcab870a2d6da677319e3a1f9e4ef6179437118d531e2289e744"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.45.2/spandock-linux-arm64.tar.gz"
      sha256 "864fb962aeb756695653557f878886523e4c25d726f377ea11b1588593457c17"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.45.2/spandock-linux-amd64.tar.gz"
      sha256 "f1a29417e2488b7fd794277f31e1632e4a7ea161f182707df59a8e33f24de2d9"
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
