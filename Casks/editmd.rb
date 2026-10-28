# Source-of-truth Homebrew cask for EditMD. Bump the version + sha256 lines on
# every release; the DMG is the Developer ID signed, notarized, and stapled
# build from scripts/dist.sh, attached to the matching GitHub Release.
cask "editmd" do
  version "0.49.1"
  sha256 "f440c3cd56ad1a0cf38bfb76e59c90548741bf24c12e3cadca7b742183f4b587"

  url "https://github.com/andryushkin/editmd/releases/download/v#{version}/EditMD-v#{version}.dmg"
  name "EditMD"
  desc "Markdown editor with Source, Visual, and Preview modes"
  homepage "https://dotmd.tools/editmd"

  depends_on macos: :sonoma

  app "EditMD.app"
  binary "#{appdir}/EditMD.app/Contents/MacOS/editmdctl", target: "editmdctl"

  # Strip Homebrew's com.apple.quarantine so brew install/upgrade opens with no
  # "downloaded from the internet" prompt. The app is Developer ID signed,
  # notarized, and stapled, but that only removes the unidentified-developer
  # block and the online check - Gatekeeper still shows the first-launch confirm
  # whenever the quarantine attr is present, and brew re-stamps it on every
  # fresh bundle. The step must not fail the install: when the terminal lacks
  # App Management permission, macOS refuses xattr on the bundle ("Operation not
  # permitted") and brew would roll the whole install back.
  postflight_steps do
    run "/usr/bin/xattr", args:         ["-dr", "com.apple.quarantine", "{{appdir}}/EditMD.app"],
                          must_succeed: false
  end

  zap trash: [
    "~/Library/Preferences/andryushkin.EditMD.plist",
    "~/Library/Saved Application State/andryushkin.EditMD.savedState",
  ]
end
