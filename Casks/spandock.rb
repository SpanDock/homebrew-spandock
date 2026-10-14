# Generated from packaging/homebrew/spandock.cask.rb in SpanDock/spandock by
# the release workflow; edits in the tap are overwritten.
cask "spandock" do
  arch arm: "arm64", intel: "amd64"

  version "0.49.0"
  sha256 arm:   "bf849a6fd3d809c1fbe1c577347407d2018da445a8c16e3e6d080d3f33af3ca2",
         intel: "89f433c727dbceff69cd75c401056057883d6d07b0e414b3c7d22ba0234d2cbe"

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
