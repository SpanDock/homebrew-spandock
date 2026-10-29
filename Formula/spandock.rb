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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.75.3/SpanDock-macos-arm64.zip"
      sha256 "c555476f9af586b828fd5c5646a86d63b4eb62e382aa2068cc3112274e093ea2"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.75.3/SpanDock-macos-amd64.zip"
      sha256 "ccdd482537049bac5fa768dc6334c87966b3cf3d1a79057a4085dc943ff93a98"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.75.3/spandock-linux-arm64.tar.gz"
      sha256 "5e07b71a051a91b5d0ee8126350ce0cf8c5a00ec6a9e9b6243d0ec4158b9f999"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.75.3/spandock-linux-amd64.tar.gz"
      sha256 "287ae378ddc5d6bc7b23352cca67694b143a883ff52c21c54532915fade0bf8b"
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
