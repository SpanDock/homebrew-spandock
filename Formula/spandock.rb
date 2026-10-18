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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.52.1/SpanDock-macos-arm64.zip"
      sha256 "15f090e7071033ad57e478173d3319019800f64d2bb9738a5d7eaf2a84dd81a4"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.52.1/SpanDock-macos-amd64.zip"
      sha256 "c70a912120c5a74513fa8a9e9b965d35bd3594d6034f4f51b6e957161651711d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.52.1/spandock-linux-arm64.tar.gz"
      sha256 "72e6cb4265f033d47f4f9a8b30152403dfe25cfb0ef2a3651c4714b4d76b35c2"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.52.1/spandock-linux-amd64.tar.gz"
      sha256 "08130bd6fa68990fd0536c42fb9bc80f3da3820b8a31fed68b984a02af5b1365"
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
