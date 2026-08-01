# Source-of-truth Homebrew cask for EditMD. Bump the version + sha256 lines on
# every release; the DMG is the Developer ID signed, notarized, and stapled
# build from scripts/dist.sh, attached to the matching GitHub Release.
cask "editmd" do
  version "0.47.15"
  sha256 "3c0c7a0382ffe8e8b63894e2b468fb2e3b8240bcd6b2da15eb82c24e6a0dcaeb"

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
  # fresh bundle.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/EditMD.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Preferences/andryushkin.EditMD.plist",
    "~/Library/Saved Application State/andryushkin.EditMD.savedState",
  ]
end
