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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.33.0/SpanDock-macos-arm64.zip"
      sha256 "1bff99ec1fbbdd3ed946cb8c30225612806dca46de193bdc55cd6cb9a21706c4"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.33.0/SpanDock-macos-amd64.zip"
      sha256 "09521fddb5e7f548854b730710b79359f2128ee899b724549fe32187b66ee55b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.33.0/spandock-linux-arm64.tar.gz"
      sha256 "015cc0d88dfdf000d58a4fbdb2ca58484cef8353f6aeb6b4acba6462a6b7633a"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.33.0/spandock-linux-amd64.tar.gz"
      sha256 "8ecfa80425d16d627d77a6397a440abc5b7b02dd9b75b24602575d294cbb1092"
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
