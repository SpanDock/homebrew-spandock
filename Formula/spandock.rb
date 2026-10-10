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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.38.0/SpanDock-macos-arm64.zip"
      sha256 "fc27f11cfddd58618bc9ddecb068fa2a088e01765e5efae8560c051ba952db70"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.38.0/SpanDock-macos-amd64.zip"
      sha256 "9f25c25691c60f24c9851cc3b14566a87143999b5ce7718bf7a96e774160d708"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.38.0/spandock-linux-arm64.tar.gz"
      sha256 "e975e7abea4f1493c5d91414eed7c89344ece9b4118f2e3067a708d2a199d5de"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.38.0/spandock-linux-amd64.tar.gz"
      sha256 "1d4aa41f9b20d00bfb4be2fb71d5a05e98d9d15e57b52ab24544870caabea5fa"
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
