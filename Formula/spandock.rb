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
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.5/SpanDock-macos-arm64.zip"
      sha256 "7f8455fd854f81bd67af86cd3320e943d2273eb7291a046bbf9498ec0b819dcd"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.5/SpanDock-macos-amd64.zip"
      sha256 "a7ba532068083b4dd7ff8a19d7a6aca5831f51e5f5ba36c13b6b7d633eee2a48"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.5/spandock-linux-arm64.tar.gz"
      sha256 "71a081c92542bd78187f3ca1935ede90d5687f481f7fec1ae3260fd9850494c6"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.5/spandock-linux-amd64.tar.gz"
      sha256 "f33021804b0a0a0a639ec066eb9de0742d8d3f3f8205dc822da536cb2332a720"
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
