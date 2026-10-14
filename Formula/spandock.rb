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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.49.0/SpanDock-macos-arm64.zip"
      sha256 "bf849a6fd3d809c1fbe1c577347407d2018da445a8c16e3e6d080d3f33af3ca2"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.49.0/SpanDock-macos-amd64.zip"
      sha256 "89f433c727dbceff69cd75c401056057883d6d07b0e414b3c7d22ba0234d2cbe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.49.0/spandock-linux-arm64.tar.gz"
      sha256 "a1748944dd7348dd6beb4a3f32a272521b45453eca39499d5f5f9cd968466d33"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.49.0/spandock-linux-amd64.tar.gz"
      sha256 "f6d7dc4f65cb1de651037daad4f00bc8a1f85c90cc4d8b88d4e1a2dad3c73a36"
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
