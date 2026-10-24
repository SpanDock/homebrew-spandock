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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.62.0/SpanDock-macos-arm64.zip"
      sha256 "6236c5c31591a99021bbc7a9c1c812e1e10ae6c1166c26e7464c90c6e8fed1c7"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.62.0/SpanDock-macos-amd64.zip"
      sha256 "175a12a7a861796f4acb57788cd7733cfe36d1b1f55d01b7063b21fde2470818"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.62.0/spandock-linux-arm64.tar.gz"
      sha256 "0d9e9eb13fbd57873ce3fcc1ff9a2bbfa064c18da06c7692d545ce2d35517665"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.62.0/spandock-linux-amd64.tar.gz"
      sha256 "6369c9cde6beb5dc8e2a903cc98805fbd8a5e56fe9d1eff1f6196c8746cfddc8"
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
