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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.8.0/SpanDock-macos-arm64.zip"
      sha256 "7bdc20b3270fe245614e1d161c8cc06661d42ef557ee531e620c8e75fa7a3178"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.8.0/SpanDock-macos-amd64.zip"
      sha256 "d31c09f65a99709299503e87cb608c2a8f7187cdde4435b7f270a3d1c7aef8e0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.8.0/spandock-linux-arm64.tar.gz"
      sha256 "21b412017843ef165511093cdd542c0c0526e2c7b89791e20cd14f78558645e4"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.8.0/spandock-linux-amd64.tar.gz"
      sha256 "c3f9b414ee3a7cca14b6eed77aefe8e629c9e3de2ff0381d4e1342e48524d261"
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
