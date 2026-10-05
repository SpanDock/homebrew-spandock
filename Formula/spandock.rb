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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.18.1/SpanDock-macos-arm64.zip"
      sha256 "8edbb5a0a9caea3d5884311478c61729c9586980f45ca1cfac8e4e45ef0bd5cf"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.18.1/SpanDock-macos-amd64.zip"
      sha256 "f4be1bfc03980caf7d436d7f08d9fd527a195367efa8c2b9a900b2d175d52077"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.18.1/spandock-linux-arm64.tar.gz"
      sha256 "8ed4c486a625d8707e81ee2d73410dda06b763e7262ff87e5f9fe64ea18c2aed"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.18.1/spandock-linux-amd64.tar.gz"
      sha256 "6427ac3dda232f3b73b1aa280ddb7f65cd176e887d5de1dc27059d6f81c17f13"
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
