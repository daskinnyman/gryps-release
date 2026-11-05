class Gryps < Formula
  desc "QA engineer skills and a small harness CLI for coding agents"
  homepage "https://github.com/daskinnyman/gryps-release"
  url "https://github.com/daskinnyman/gryps-release/releases/download/v0.1.0/gryps-0.1.0.tgz"
  sha256 "714702406ce399f4e579f3b9b0f4214841bb0ae6058c63a9d934b6f32d417fb2"
  version "0.1.0"
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
