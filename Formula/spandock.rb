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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.23.0/SpanDock-macos-arm64.zip"
      sha256 "106fd8e9229feb479cd40d9fe637be38995b410584fbffcbf857a65b4e9a3132"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.23.0/SpanDock-macos-amd64.zip"
      sha256 "1003c53a4473f3ee01c4b7062cf5d178f4f1aaf11bd87f8519dc26de2bb48c19"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.23.0/spandock-linux-arm64.tar.gz"
      sha256 "314cc6c3abf786945bddf6bfff85faedd1b2b88b421fc2faf02af7d0dcd37c7a"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.23.0/spandock-linux-amd64.tar.gz"
      sha256 "cce9b8cb1db01e88382df1ee07067847df2b994436293b0fd760846e1b1046fb"
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
