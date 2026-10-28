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
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.75.0/SpanDock-macos-arm64.zip"
      sha256 "dc156db87230595a6a92335cca41079e65433425f4aa6381e5618dafb1683091"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.75.0/SpanDock-macos-amd64.zip"
      sha256 "3bdb93b3a39f6cc7cb354d4ce5b9bae8c3d1a620e0e943abb3574b60e42a42c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.75.0/spandock-linux-arm64.tar.gz"
      sha256 "51f03534e633acfe95d20994b5b1ec677a68c707e28e702937c36b5dfa752fb6"
    end
    on_intel do
      url "https://github.com/SpanDock/spandock-releases/releases/download/v0.75.0/spandock-linux-amd64.tar.gz"
      sha256 "f3b9efc8473dc3d3fcfe6d48ca8c02c58ad17fc7730bb007281d418fb190967b"
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
