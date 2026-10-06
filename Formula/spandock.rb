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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.25.1/SpanDock-macos-arm64.zip"
      sha256 "46433a81c5ced17d16e5cdd21e1aa0c914578043f55ff7b57e971328db551e4e"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.25.1/SpanDock-macos-amd64.zip"
      sha256 "73909391ebffa3af2e97d367b4c64d2368f095400be17a938b8ef5e6e1b9ae11"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.25.1/spandock-linux-arm64.tar.gz"
      sha256 "3075357b7ca1d2a63a244723bc3a1a6009c522246a6d931a1a3d35dc7fccc0cc"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.25.1/spandock-linux-amd64.tar.gz"
      sha256 "7192920fe3a618ada51c4fab6a70865d28d405ff1ccb14f9b6bb5e9f43bd3ec3"
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
