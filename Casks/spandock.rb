# Generated from packaging/homebrew/spandock.cask.rb in SpanDock/spandock by
# the release workflow; edits in the tap are overwritten.
cask "spandock" do
  arch arm: "arm64", intel: "amd64"

  version "0.67.1"
  sha256 arm:   "2f619e7a91a2b86fcd4818d4deb3d2c0086c3a2b817242f1526e3e8185e3ce0e",
         intel: "2c27dfb7253fe41f2235331941cb3df74617e41a155ccf8150d47f0a6263adc7"

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
