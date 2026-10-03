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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.12.1/SpanDock-macos-arm64.zip"
      sha256 "0731a4720caf3dc7a38844ff9dfad883681fcfb9d9aabb638b600f45f63f3498"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.12.1/SpanDock-macos-amd64.zip"
      sha256 "a238f5f0528b9ea20673b9da2c6b1dcb8c3f9c5b46d346e9124e0ca398f690dc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.12.1/spandock-linux-arm64.tar.gz"
      sha256 "ae6be7cc10c0ba3199031a63e2bdd4fc9a0fcfd273ac5133cced294c1690e469"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.12.1/spandock-linux-amd64.tar.gz"
      sha256 "591d237769888d317315ed047ad5bc490ff0ced3c0748e40fc90024a275de5d7"
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
