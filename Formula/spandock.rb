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
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.3/SpanDock-macos-arm64.zip"
      sha256 "036d7c66915500200af5e6d9e28cc050d8c17dfe2d8b3fbbccd0d480331d8229"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.3/SpanDock-macos-amd64.zip"
      sha256 "d57f207639f1657ccb45703fc3a5a664f9595af84e88095cd8f1821991028d49"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.3/spandock-linux-arm64.tar.gz"
      sha256 "171f9a52e40ff4f6d0e9d0cae3573bbd86cf2ec4aef9f88b3e88dd8480ac486f"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v0.6.3/spandock-linux-amd64.tar.gz"
      sha256 "139e2863bd0ad002ba0373e8b20b369587a567b6f6ebbbb82bf9fc9bc26c37d2"
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
