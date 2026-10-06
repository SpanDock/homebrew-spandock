# Generated from packaging/homebrew/spandock.cask.rb in SpanDock/spandock by
# the release workflow; edits in the tap are overwritten.
cask "spandock" do
  arch arm: "arm64", intel: "amd64"

  version "0.25.0"
  sha256 arm:   "75c5ae5d7b4dcd63279bdde347664f85e9ed866462a2e104bf02abb71f5f8f8c",
         intel: "0d99d24ee0e446b354ae616df20bb12ab596baf5ca0bc019976ce1c03799115b"

  url "https://github.com/SpanDock/spandock-releases/releases/download/v#{version}/SpanDock-macos-#{arch}.zip"
  name "SpanDock"
  desc "Local OpenTelemetry gateway and dashboards for AI coding tools"
  homepage "https://github.com/SpanDock/spandock-releases"

  livecheck do
    url :url
    strategy :github_latest
  end

  # SpanDock updates itself; `brew upgrade --greedy` also works.
  auto_updates true
  depends_on macos: :ventura

  app "SpanDock.app"

  # SpanDock is ad-hoc signed until it has a Developer ID, so clear the
  # download quarantine; otherwise macOS asks to "Open Anyway" first.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/SpanDock.app"],
        writable_paths: ["SpanDock.app"],
        writable_base:  :appdir,
        must_succeed:   false
  end

  uninstall quit: "io.spandock.app"

  zap trash: [
    "~/Library/Application Support/SpanDock",
    "~/Library/Logs/SpanDock*.log",
  ]

  caveats <<~EOS
    On first launch SpanDock asks whether this Mac is a server or a client.
    Every server needs a spandock.com account: a new server is activated by
    signing in once (a Personal license is free). Clients need only a pairing code.
  EOS
end
