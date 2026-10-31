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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.77.0/SpanDock-macos-arm64.zip"
      sha256 "9f45841ed53cf7994a78452a6e7c3f5a9e508940dfe1c89abc543a1d12e6a844"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.77.0/SpanDock-macos-amd64.zip"
      sha256 "c2dfa1e034c2606fbdaa119c0bff3ce502f56e92aaa8295d9f6b94f2c514d8e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.77.0/spandock-linux-arm64.tar.gz"
      sha256 "bd67f71e1cbb57ff08e8c31d54cbfb138bfbda8b335424b8a70f68a497931691"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.77.0/spandock-linux-amd64.tar.gz"
      sha256 "798e963ec1aaa7ef4edbd26a92827595c7abb409070d1017802d8bcb91ae23cd"
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
