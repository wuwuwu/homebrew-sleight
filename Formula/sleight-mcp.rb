class SleightMcp < Formula
  desc "Deterministic action layer for macOS agents (MCP server)"
  homepage "https://sleight.sh"
  url "https://sleight.sh/dl/sleight-0.8.0.zip"
  sha256 "50b332f3bd91a9e8e315eecb035a7eb0ee6a7bed55328664960042de97688b58"
  license "Apache-2.0"

  livecheck do
    url "https://sleight.sh/appcast.json"
    regex(/"version"\s*:\s*"([^"]+)"/i)
  end

  bottle do
    root_url "https://github.com/wuwuwu/homebrew-sleight/releases/download/sleight-mcp-0.8.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3950a74c488e0cab57769be396283335d4b56a35829d391d2d2781517b6848d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42c0e70daefe55b864189ed77f1bea9bae5a3acdcbbab193ec8fae481fab987f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d92158d6ab4c004c202609c6a73fef2255efcd44e23cb2825caa7346da1895f"
    sha256 cellar: :any_skip_relocation, sequoia:       "b9b098bc0667ca17335a0f42771712dbec2e4af39ab63216eee661f1b0cdd8b4"
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

      Add it to your MCP client, e.g. Claude Desktop
      (~/Library/Application Support/Claude/claude_desktop_config.json):
        "sleight": { "command": "#{opt_bin}/sleight-mcp" }

      Strategies are found automatically next to the binary
      (#{opt_pkgshare}/strategies); override with --strategy-dir if needed.

      Upgrade with `brew upgrade` (the built-in auto-updater is for the
      curl-installed ~/.sleight copy, not the Homebrew one).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sleight-mcp --version")
  end
end
