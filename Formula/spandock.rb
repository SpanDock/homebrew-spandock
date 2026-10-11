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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.40.0/SpanDock-macos-arm64.zip"
      sha256 "3a0e16da7afd5ffc812bb2b27a0b114b3a7b220282cb69d89fc26e652eaf2a67"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.40.0/SpanDock-macos-amd64.zip"
      sha256 "09b889795e3a64fd2066d045b860c9c4f1ff8cf86f0c53078e6348f002a7b7e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.40.0/spandock-linux-arm64.tar.gz"
      sha256 "a7e28d28050f75e10059ecb82e2ec4148e0b5fe3ea6019da49792f0f30d1f067"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.40.0/spandock-linux-amd64.tar.gz"
      sha256 "ad11fac769c2da8a5ae28b5ba9a3b4a09896ada6ad8199b512aee898ce668469"
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
