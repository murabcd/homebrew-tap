class Productboard < Formula
  desc "Read-only Jira Cloud workspace for your terminal"
  homepage "https://github.com/murabcd/productboard"
  url "https://github.com/murabcd/productboard/releases/download/v0.1.0/productboard-0.1.0.tar.gz"
  sha256 "529a402ecc99e76ebb0e850e2453515a152c7ed4d300e0658a9cf544f4811a0c"

  depends_on "bun"
  depends_on :macos
  depends_on "node@24"

  def install
    bun = formula_opt_bin("bun")/"bun"
    system bun, "install", "--frozen-lockfile", "--production"

    libexec.install "agent", "bin", "node_modules", "package.json", "src", "tsconfig.json"
    (bin/"productboard").write_env_script libexec/"bin/productboard",
                                         BUN: bun, PATH: "#{formula_opt_bin("node@24")}:$PATH"
  end

  test do
    assert_match "Usage: productboard", shell_output("#{bin}/productboard --help")
  end
end
