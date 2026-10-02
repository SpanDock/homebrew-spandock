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
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.4/SpanDock-macos-arm64.zip"
      sha256 "19c45170df1bb233c268c73c4e9a666e41c001021d4728376816afc66c8a12ab"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.4/SpanDock-macos-amd64.zip"
      sha256 "67e38a4c7cfbb8aadaf6a03f14e63d4f76a6785a96eab66216b12573c587b989"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.4/spandock-linux-arm64.tar.gz"
      sha256 "febcce7bfa8d7a856f438903de5481ca08e407edce9cffbc221e0e548d2906ed"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.4/spandock-linux-amd64.tar.gz"
      sha256 "2d3c7708361ed196b3dd5e2c527b7559386d50cfb59ecf36b138048de4737907"
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
