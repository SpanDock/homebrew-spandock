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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.73.1/SpanDock-macos-arm64.zip"
      sha256 "836bcfaebcd1ecf9f4e0e3bda8fc9284ef9359f0612f8d9e346083fc89ad8813"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.73.1/SpanDock-macos-amd64.zip"
      sha256 "8a42e81cbaea665456069b5dc6c1f4dd09f76637d9ba68b1770bafedcf7d3b6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.73.1/spandock-linux-arm64.tar.gz"
      sha256 "47ec9e34986172b8da5d667fe98b94e90cd1ebc17091f8a35401f6958ede80e7"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.73.1/spandock-linux-amd64.tar.gz"
      sha256 "51a873f64fd0b03cb0b92b259c0df640bdbf0298e3a9f9f5f1b704c79807893c"
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
