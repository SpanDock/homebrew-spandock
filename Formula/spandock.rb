# Generated from packaging/homebrew/spandock.formula.rb in h4ux/spandock by
# the release workflow; edits in the tap are overwritten.
class Spandock < Formula
  desc "Local OpenTelemetry gateway and dashboards for AI coding tools"
  homepage "https://github.com/h4ux/spandock-releases"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.2/SpanDock-macos-arm64.zip"
      sha256 "e7ef9784a7adfc6ce7288420a4adbf4ad6b5aa397ca1640fffded37b6cb84929"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.2/SpanDock-macos-amd64.zip"
      sha256 "b51dcaa8166271592f4f646c214f316f0d92d2b53d42025653f151cfba18cb0d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.2/spandock-linux-arm64.tar.gz"
      sha256 "c3f80cbbe49a7180b3df20731a240faf547224411254bcd08db9a95573c7dd6d"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.2/spandock-linux-amd64.tar.gz"
      sha256 "13211e2fc03e6f4834d24c8f5fed1d0ab8c5e3ccc15d372d36630e5c8f6ed39c"
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
        spandock -role=server -open=false -menubar=false   # Ctrl-C after it starts
        brew services start spandock

      For a client, use -role=client and paste the pairing code in its dashboard.
      Updates: brew upgrade spandock
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spandock -version")
  end
end
