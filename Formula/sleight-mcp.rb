class SleightMcp < Formula
  desc "Deterministic action layer for macOS agents (MCP server)"
  homepage "https://sleight.sh"
  url "https://sleight.sh/dl/sleight-0.7.0.zip"
  sha256 "f042eb8c9ba984a66a6f0e5bb6b0cc050c86938c63dc31497ad22aa9bfbfb2b3"
  license "Apache-2.0"

  livecheck do
    url "https://sleight.sh/appcast.json"
    regex(/"version"\s*:\s*"([^"]+)"/i)
  end

  depends_on macos: :sonoma # macOS 14+ (bare symbol = this version or newer)

  def install
    # The release zip has a single top-level sleight-<version>/ directory that
    # Homebrew descends into before running install.
    bin.install "sleight-mcp"
    pkgshare.install "strategies"
  end

  def caveats
    <<~EOS
      sleight-mcp needs Accessibility + Automation permissions
      (System Settings > Privacy & Security). Homebrew cannot grant these.

      Point your MCP client at the installed strategies, e.g. Claude Desktop
      (~/Library/Application Support/Claude/claude_desktop_config.json):
        "sleight": {
          "command": "#{opt_bin}/sleight-mcp",
          "args": ["--strategy-dir", "#{opt_pkgshare}/strategies"]
        }

      Upgrade with `brew upgrade` (the built-in auto-updater is for the
      curl-installed ~/.sleight copy, not the Homebrew one).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sleight-mcp --version")
  end
end
