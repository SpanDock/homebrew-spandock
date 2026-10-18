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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.53.0/SpanDock-macos-arm64.zip"
      sha256 "87d3d73d1252a24a5ef17fd99f377687c6b01c182ab2b0789d8f3a1a79dee65e"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.53.0/SpanDock-macos-amd64.zip"
      sha256 "ea69982b39194b65c4f9e909d35a69ad917c4b857de3837ae45ed6f1f49236b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.53.0/spandock-linux-arm64.tar.gz"
      sha256 "faaabc5793bcd9f50a70e76078a6edb50cab97fa590d595ababf40c9ab66b893"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.53.0/spandock-linux-amd64.tar.gz"
      sha256 "d2d4c4bbba55d3a7bc35ade7017327262e91811ca2f6db46204b9e2b1bd1c042"
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
