class SleightMcp < Formula
  desc "Deterministic action layer for macOS agents (MCP server)"
  homepage "https://sleight.sh"
  url "https://sleight.sh/dl/sleight-0.9.1.zip"
  sha256 "5503b22cbf46a0089eedd2dd062a6fdc1318dedbff6a423a122444868a07569a"
  license "Apache-2.0"

  livecheck do
    url "https://sleight.sh/appcast.json"
    regex(/"version"\s*:\s*"([^"]+)"/i)
  end

  bottle do
    root_url "https://github.com/wuwuwu/homebrew-sleight/releases/download/sleight-mcp-0.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f5eabccffa1edfb44c06403b4d41263e4c4e1649aceb2510f8728918d780cb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4a8404637a822dce60f6daa0371e6c987be68a13fc850b1b0331828a7c9832"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f70d2c19f2f65626ccbfaa73cb93741c5960ceb3428981d4871053ce0f806858"
    sha256 cellar: :any_skip_relocation, sequoia:       "4158ef417ca995c254ab4fff764f37f1e6d4b577c3a7945cf8436aab636cfb1a"
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
