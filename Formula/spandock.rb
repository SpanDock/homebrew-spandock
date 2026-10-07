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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.31.0/SpanDock-macos-arm64.zip"
      sha256 "7b896889b72da4ba47a5b214da334ce8d32eb0b94352f2e07cfa9a75eec699da"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.31.0/SpanDock-macos-amd64.zip"
      sha256 "5f4687885274570b88898d6e4bf462e3d7f1a6d4ece6478fb61a1d4cada31093"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.31.0/spandock-linux-arm64.tar.gz"
      sha256 "2950a17f45ade046d3cfdd50adfa2ed0877eca36233186b4c07aff587adfc8dc"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.31.0/spandock-linux-amd64.tar.gz"
      sha256 "4ba2ff3a68fd1fbbbe1235bdbc2a742b547e4a76ee50db7f829fd7fe8e244787"
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
