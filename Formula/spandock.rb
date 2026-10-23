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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.56.0/SpanDock-macos-arm64.zip"
      sha256 "e785eb57d4296a6aa2e70b6219e842087a401d7b30327854c5b71e867c64572c"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.56.0/SpanDock-macos-amd64.zip"
      sha256 "1d6be62e362d8be54816da03e2c8256d3f898dcaa912c32c4a9ef80ccb1b6300"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.56.0/spandock-linux-arm64.tar.gz"
      sha256 "6176f97705cb0c073b904e8719701884c41d04f4952ee0697b147cdff7e0d27e"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.56.0/spandock-linux-amd64.tar.gz"
      sha256 "a543b3e5cbef53bf9d7a0db0ea1b5ff69b20b27d514353ae933ce30eca71bbda"
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
