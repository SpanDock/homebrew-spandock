# Generated from packaging/homebrew/spandock.formula.rb in h4ux/spandock by
# the release workflow; edits in the tap are overwritten.
class Spandock < Formula
  desc "Local OpenTelemetry gateway and dashboards for AI coding tools"
  homepage "https://github.com/h4ux/spandock-releases"
  version "0.6.1"

  on_macos do
    on_arm do
      url "https://github.com/h4ux/spandock-releases/releases/download/v#{version}/SpanDock-macos-arm64.zip"
      sha256 "b70996d0011da40cde1938c5c622655ca1dd6181d30b11a34305b49b7ba9b0fd"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v#{version}/SpanDock-macos-amd64.zip"
      sha256 "7be2baa3aebd1c2307bd61d7626b5d2bba68c8b53a1aa2029720fe72e61651d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h4ux/spandock-releases/releases/download/v#{version}/spandock-linux-arm64.tar.gz"
      sha256 "c2e3575d43579e25b776b614a1bd58a9ab6e0371433d6b9acecfc396efdf686a"
    end
    on_intel do
      url "https://github.com/h4ux/spandock-releases/releases/download/v#{version}/spandock-linux-amd64.tar.gz"
      sha256 "a382d5f4284c5b2b6a0e5555e91638374a5bcfbda273b8ea4bd6af0cc845702e"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    if OS.mac?
      # The command-line binary is the app's executable.
      bin.install Dir["**/Contents/MacOS/SpanDock"].fetch(0) => "spandock"
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
