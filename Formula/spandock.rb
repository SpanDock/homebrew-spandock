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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.41.0/SpanDock-macos-arm64.zip"
      sha256 "31538ba7d078977dc27c08039b4b4723d185198e21f351451e11b7e0e204ce28"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.41.0/SpanDock-macos-amd64.zip"
      sha256 "b1b0a0c6380b1c5b4c8cc047605b86fd1046bc098d71f5297ebead235a0a3bcd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.41.0/spandock-linux-arm64.tar.gz"
      sha256 "a9e890b73fbcb9484395046148a016eac53f0139cdbb93d1d27a5808bdce8945"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.41.0/spandock-linux-amd64.tar.gz"
      sha256 "739ce1e830e8c169028b3d0334f488b0d31c939a9dce6ddd9ba56d65806c99ee"
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
