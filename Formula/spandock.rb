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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.61.0/SpanDock-macos-arm64.zip"
      sha256 "57b73aed16a602d43f22bc15d9cd76a16138793d967c8766f181ca903e93eed6"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.61.0/SpanDock-macos-amd64.zip"
      sha256 "4cd3912ac619e719f4f0c3a9768c839198e5df939a0a26b61aef34b2d11238c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.61.0/spandock-linux-arm64.tar.gz"
      sha256 "bcfc77ef65d750c3fd76ddb0d4a55aea463ba2da4f93a159080d07f444c52b8f"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.61.0/spandock-linux-amd64.tar.gz"
      sha256 "c1f5351dd70dad9b7ebb3b273c88e5169bf705d1cde0b90dee87536c407cd755"
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
