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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.67.1/SpanDock-macos-arm64.zip"
      sha256 "2f619e7a91a2b86fcd4818d4deb3d2c0086c3a2b817242f1526e3e8185e3ce0e"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.67.1/SpanDock-macos-amd64.zip"
      sha256 "2c27dfb7253fe41f2235331941cb3df74617e41a155ccf8150d47f0a6263adc7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.67.1/spandock-linux-arm64.tar.gz"
      sha256 "c739a744cd3fd39c0141037b2cda03eecee541273b7b2d654121fd7cb4de9249"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.67.1/spandock-linux-amd64.tar.gz"
      sha256 "05d72a1bbffb6eb06730e485a473104e00aee57a21cdf0be2d68b9780b9512c3"
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
