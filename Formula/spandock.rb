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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.30.0/SpanDock-macos-arm64.zip"
      sha256 "a4c99f88c4f76e351e661dd296502c03a7d70a18ec3c0a5266e2fb3388f907c3"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.30.0/SpanDock-macos-amd64.zip"
      sha256 "f19e66d455ad02785405e3384df94d96b768a6e34b9ee17248028157dc5c9c31"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.30.0/spandock-linux-arm64.tar.gz"
      sha256 "835386bcf97ef7a55bd5949e88ef9e9e857464040022de6094678d1e09945719"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.30.0/spandock-linux-amd64.tar.gz"
      sha256 "324cdfd973cfd4f7367fc3f7b1223590f6341b36c8f7596ae9f26823ea0dd0ff"
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
