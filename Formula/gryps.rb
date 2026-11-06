class Gryps < Formula
  desc "QA engineer skills and a small harness CLI for coding agents"
  homepage "https://github.com/daskinnyman/gryps-release"
  url "https://github.com/daskinnyman/gryps-release/releases/download/v0.2.0/gryps-0.2.0.tgz"
  sha256 "a185d0df779094be570f9ab4c9f7c9e473f20b50c94a59cc600f9ca262462d3d"
  version "0.2.0"
  license "MIT"

  depends_on "node"

  def install
    # Scripts are skipped: the postinstall downloads Chromium into the home folder.
    system "npm", "install", "--ignore-scripts", "--omit=dev", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      Install the Chromium that Gryps drives, once:
        #{opt_libexec}/lib/node_modules/gryps/node_modules/.bin/playwright install chromium
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gryps --version")
  end
end
