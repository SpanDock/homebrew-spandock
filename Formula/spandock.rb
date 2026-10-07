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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.32.0/SpanDock-macos-arm64.zip"
      sha256 "1be80f4825938af2b3dbe031b71da946e6256d55e605a0cb5fe4bd852eb047ec"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.32.0/SpanDock-macos-amd64.zip"
      sha256 "58e543ac883dfec35c7e53dcebf9b0d3b56a0731f8fe64c611e9bfa1bd07cb40"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.32.0/spandock-linux-arm64.tar.gz"
      sha256 "a8234b406756f4c2fcf38e63c24b032af22652e925e9243a7c6c9a1449451e3d"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.32.0/spandock-linux-amd64.tar.gz"
      sha256 "bc2f26122c7d9c328515c93b8b77e1ef8a911d3d235edbc32b1a043ab941e081"
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
