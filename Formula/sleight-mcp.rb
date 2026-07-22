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
    root_url "https://github.com/wuwuwu/homebrew-sleight/releases/download/sleight-mcp-0.9.1"
    sha256                               arm64_tahoe:   "b474e26a881a86a0ec43812daa60346ac6b7092726d598958ea9b523d4ae1299"
    sha256                               arm64_sequoia: "60bf4b3891658d38f960868ae578f55f87b086b74749b67aec5b7b0f24cdbfc1"
    sha256                               arm64_sonoma:  "e36e46270be8c0cdcd0f6effb3ba5abcdb3cc4b4093fa8b3454ce34da0719941"
    sha256 cellar: :any_skip_relocation, sequoia:       "6006a9fb3c72874340769eb4da9b5742930bd596ba7ceb134f9034e3d0f0ce02"
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
