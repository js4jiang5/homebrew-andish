cask "andish" do
  version "0.0.3"
  sha256 "7df9910f4c02eaa8cd75b17295759fddf2188a2e530f88975fee45fa3e382567"

  url "https://github.com/js4jiang5/Andish/releases/download/v#{version}/Andish_v#{version}.dmg"
  name "Andish"
  desc "Monitor Android device battery health, cycle, and temperature information."
  homepage "https://github.com/js4jiang5/Andish"

  app "Andish.app"

  # This runs AFTER the app is moved to /Applications
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-rd", "com.apple.quarantine", "#{appdir}/Andish.app"],
                   sudo: false
  end

  uninstall_preflight do
    current_uid = Process.uid
    system_command "/bin/launchctl",
                   args: ["bootout", "gui/#{current_uid}", "#{appdir}/Andish.app/Contents/Library/LaunchAgents/com.buddha-path.Andish.daemon.plist"],
                   must_succeed: false

    system_command "/usr/bin/pkill", 
                   args: ["-9", "-x", "Andish"], 
                   must_succeed: false
  end

  zap trash: [
        "~/Library/Application Support/andish/andish.sock",
        "~/Library/Logs/andish/andish.log",
        "~/Library/Caches/com.buddha-path.Andish",
        "~/Library/Preferences/com.buddha-path.Andish.plist",
      ]
end