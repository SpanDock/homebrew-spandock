# Generated from packaging/homebrew/spandock.cask.rb in SpanDock/spandock by
# the release workflow; edits in the tap are overwritten.
cask "spandock" do
  arch arm: "arm64", intel: "amd64"

  version "0.8.0"
  sha256 arm:   "7bdc20b3270fe245614e1d161c8cc06661d42ef557ee531e620c8e75fa7a3178",
         intel: "d31c09f65a99709299503e87cb608c2a8f7187cdde4435b7f270a3d1c7aef8e0"

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
  EOS
end
