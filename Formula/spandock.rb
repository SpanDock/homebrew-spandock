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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.58.0/SpanDock-macos-arm64.zip"
      sha256 "508f4c431a9a2dc719a24001c5211d076e1d25ad8b16dbdfd81dc1a05125a38d"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.58.0/SpanDock-macos-amd64.zip"
      sha256 "f108de2e6c06021490e5f3a68dc90cc8f98461fe1989cad3335196bde0047864"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.58.0/spandock-linux-arm64.tar.gz"
      sha256 "ada0dff3b084c7b5ecd0681b29444cf8ecf4e85f67f95fea483fd30938474a8d"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.58.0/spandock-linux-amd64.tar.gz"
      sha256 "814fa00e69e074525aa514719be15cf6abe0831d6ed1a9e439b991fe5b38b84f"
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
