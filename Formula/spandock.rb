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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.65.0/SpanDock-macos-arm64.zip"
      sha256 "889713ad1ff2b758e7f8140ef7e17dfa054adc62b3cb3d75941c0816b954828c"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.65.0/SpanDock-macos-amd64.zip"
      sha256 "c4a083b4771bc2155f2d1c3b9d545bf21b008ed1152f20bd501d4287f33d090a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.65.0/spandock-linux-arm64.tar.gz"
      sha256 "51845792a9283ace03f7648cf07b34fbc59e9c00e0b837a7e7a15e5596d12ce4"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.65.0/spandock-linux-amd64.tar.gz"
      sha256 "74aff0b4c7880027ec5e4ec646276a3204eaa9c9681a08ee0aa60084a8c2c98d"
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
