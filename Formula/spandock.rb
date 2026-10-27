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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.70.1/SpanDock-macos-arm64.zip"
      sha256 "8e0a309f87a2bc04d7cdc0f8107ddd6d87e05e9c274090ee891684d7e6998072"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.70.1/SpanDock-macos-amd64.zip"
      sha256 "73de1f55c7e4165ddc9168d3a8849a382f8a3f898e05175dad274b5d89266dfb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.70.1/spandock-linux-arm64.tar.gz"
      sha256 "df826bea58c9e2a22b443ba7924faa31102a01507149e10575ddaa8fe46d0503"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.70.1/spandock-linux-amd64.tar.gz"
      sha256 "2c98a21425ea917fe77ba5f28d89a9fc6dcc185762c53cf6abfc7a5873e4a385"
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
