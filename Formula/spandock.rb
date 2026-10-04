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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.2/SpanDock-macos-arm64.zip"
      sha256 "864e58c81c86848dbfee654fbb661938d8d94b2367b5f408e12f145a6ca455b2"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.2/SpanDock-macos-amd64.zip"
      sha256 "87f5ecf812d86cb4fe074f050d9be81f75d6b8a9a6f83bbc2ddbfc83a5a02a6b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.2/spandock-linux-arm64.tar.gz"
      sha256 "c2f321430e16951fb4e03fe127372116dfa0318d01434c728e63fc9ee9410407"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.16.2/spandock-linux-amd64.tar.gz"
      sha256 "b1e9f9dae9d89cb6386e9e489d94410ccfc5a3a9c708be384d2a14d22bb8af23"
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
