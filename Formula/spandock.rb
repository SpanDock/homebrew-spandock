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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.14.0/SpanDock-macos-arm64.zip"
      sha256 "b2bddc03c7bae3a7de1f6d63e56a85c99831678961f5a8ac17b48d59923ae5b0"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.14.0/SpanDock-macos-amd64.zip"
      sha256 "d22b191e7e07820129161b027ab8bb6ebafb5e2417add62f68da5fa3d37c4ae0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.14.0/spandock-linux-arm64.tar.gz"
      sha256 "abb19c20811d3f0bbd4b8ddcdcd841213bec14b725cce7c218281a21198a773f"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.14.0/spandock-linux-amd64.tar.gz"
      sha256 "51fa7fd1640594a92c7a3246e599ceee4b72102fe1fc01e625bab3a7d6749dbe"
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
