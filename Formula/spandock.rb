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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.64.2/SpanDock-macos-arm64.zip"
      sha256 "a792db43ad72186ee6c6f6a36e0303ddb5fc33b7fd2bce9bb022da287d054028"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.64.2/SpanDock-macos-amd64.zip"
      sha256 "ead25f454efb2158a177aeda173f61e49f91f14819024e9a1a4e3a425f82d705"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.64.2/spandock-linux-arm64.tar.gz"
      sha256 "73d66f53d5d5f92e4bb49c648be25e730e56bee5a86b6d5ed834960f7d3b7fb8"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.64.2/spandock-linux-amd64.tar.gz"
      sha256 "4ee7f86286bd7b2abfd426c90cd68ce66ec34c2661a934083a932121b9d71cc4"
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
